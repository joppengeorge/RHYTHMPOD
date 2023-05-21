import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ui/home_page.dart';
import 'package:ui/global.dart';


class AudioTrackListPage extends StatefulWidget {
final String? keyword;
  const AudioTrackListPage({Key? key,required this.keyword}) : super(key: key);
  @override
  State<AudioTrackListPage> createState() => AudioTrackListPageState();
}

class AudioTrackListPageState extends State<AudioTrackListPage> {

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      toolbarHeight: 70,
      title: const Text('Audio Tracks'),
      backgroundColor: const Color.fromARGB(255, 71, 68, 214),
    ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.keyword!=null? FirebaseFirestore.instance
        .collection('audio')
        .where('artist', isEqualTo: widget.keyword)
        .snapshots(): FirebaseFirestore.instance.collection('audio').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
    
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
    
          if (snapshot.data!.size == 0) {
            return Center(
                      child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      // Add your onPressed event here
                      },
                      style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB6AFAF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      ),
                      child: const Text(
                      "No Songs Uploaded Yet !!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      ),
                    )
                    
                      );
          }
    
          List<Music> musicList = snapshot.data!.docs.map((doc) {
            return Music(
              doc.id,
              doc['image_url'],
              doc['title'],
              doc['album'],
              doc['artist'],
              doc['audio_url'],
              doc['type']
               // Set isFavourite to false by default
            );
          }).toList();
    
            return ListView.builder(
              itemCount: musicList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(musicList[index].image),
                    ),
                    title: Text(
                      musicList[index].title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(
                             musicList[index].artist,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                             musicList[index].album,
                          ),
                        ],
                      ),
                    trailing: Text(
                             musicList[index].type,
                          ),
                    onTap: () {
                      setState(() {
                        heartvis = true;
                        playlist = musicList;
                        currentindex.value = index;
                        MiniplayerWidgetState.audioPlayer.seek(
                          Duration.zero,
                          index: index,
                        );
                      });
                    },
                    
                  ),
                );
              },
            );

        },
      ),
    );
  }
}



/*class MusicListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('audio').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.data!.size == 0) {
          return Text('No songs found.');
        }

        List<Music> musicList = snapshot.data!.docs.map((doc) {
          return Music(
            doc['image_url'],
            doc['title'],
            doc['album'],
            doc['artist'],
            doc['audio_url'],
            false, // Set isFavourite to false by default
          );
        }).toList();

        return ListView.builder(
            itemCount: musicList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(musicList[index].image),
                ),
                title: Text(musicList[index].title),
                subtitle: Text(musicList[index].artist),
                onTap: () {
                  setState(() {
                    playlist = musicList;
                    currentindex.value = index;
                    MiniplayerWidgetState.audioPlayer.seek(
                      Duration.zero,
                      index: index,
                    );
                  });
                },
              );
            },
          );
      },
    );
  }
}*/
