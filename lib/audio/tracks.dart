import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ui/home_page.dart';
import 'package:ui/global.dart';


class AudioTrackListPage extends StatefulWidget {

  const AudioTrackListPage({Key? key}) : super(key: key);
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
        stream: FirebaseFirestore.instance.collection('audio').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
    
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
    
          if (snapshot.data!.size == 0) {
            return const Text('No songs found.');
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
