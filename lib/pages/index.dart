import 'package:cloud_firestore/cloud_firestore.dart';

import '../all_settings/settings_page.dart';
import '../global.dart';
import 'package:ui/audio/tracks.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../home_page.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  MusicPageState createState() => MusicPageState();
}

class MusicPageState extends State<MusicPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color.fromARGB(255, 71, 68, 214),
          title: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Center(
                child: Row(
                  children: const [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Music",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              )),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                },
                icon: const Icon(
                  Ionicons.settings_outline,
                  size: 29,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15, left: 20),
                child: const Text(
                  "Your favorite artists",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 150,
                // color: Colors.black,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: musicartist.length,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () {
                        // do something when the button is tapped
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.only(
                            left: 20, top: 30, bottom: 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AudioTrackListPage(
                                        keyword: "${musicartist[i]['name']}",
                                      )),
                            );
                            // do something when the button is pressed
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              image: DecorationImage(
                                image: AssetImage("${musicartist[i]['img']}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, left: 20, bottom: 20),
                child: const Text(
                  "TOP SONGS!!!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('audio')
                      .where('type', isEqualTo: 'Music')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                        ),
                        child: const Text(
                          "Not Uploaded Yet !!",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ));
                    }

                    List<Music> musicpage = snapshot.data!.docs.map((doc) {
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

                    return Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: musicpage.length,
                        itemBuilder: (BuildContext context, int index) {
                          final music = musicpage[index];

                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                playlist = musicpage;
                                currentindex.value = index;
                                MiniplayerWidgetState.audioPlayer.seek(
                                  Duration.zero,
                                  index: index,
                                );
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: AspectRatio(
                                        aspectRatio: 1.4,
                                        child: Image.network(
                                          music.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    music.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  music.artist,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  music.album,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
                   Center(
              child: ElevatedButton(
                    onPressed: () {
                       Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AudioTrackListPage(keyword: null,)),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB6AFAF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
            ),
            ]
            ),
      ),
    );
  }
}
