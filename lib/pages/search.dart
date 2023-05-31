import 'package:cloud_firestore/cloud_firestore.dart';

import '../all_settings/settings_page.dart';
import '../global.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../home_page.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  String? name;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromARGB(234, 0, 0, 0),
          appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: const Color.fromARGB(234, 0, 0, 0),
            title: Container(
                margin: const EdgeInsets.only(top: 10),
                child:  Center(
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Search",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
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
                width: double.infinity,
                height: 40,
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(25, 25),
                      bottomRight: Radius.elliptical(25, 25),
                      topLeft: Radius.elliptical(25, 25),
                      topRight: Radius.elliptical(25, 25)),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Artists,Tracks,",
                      prefixIcon: const Icon(
                        Ionicons.search_outline,
                        color: Colors.black,
                      )),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('audio')
                      .orderBy('title', descending: false)
                      //.where('title', isGreaterThanOrEqualTo: name)
                      //.where('title', isLessThanOrEqualTo: '$name\uf8ff')
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
                          "No Result found",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ));
                    }
                    List<Music> searchList = snapshot.data!.docs
                        .where((doc) =>
                            doc['title']
                                .toString()
                                .toLowerCase()
                                .contains(name?.toLowerCase() ?? '') ||
                            doc['artist']
                                .toString()
                                .toLowerCase()
                                .contains(name?.toLowerCase() ?? ''))
                        .map((doc) {
                      return Music(
                        doc.id,
                        doc['image_url'],
                        doc['title'],
                        doc['album'],
                        doc['artist'],
                        doc['audio_url'],
                        doc['type'],
                      );
                    }).toList();
                    return ListView.builder(
                      itemCount: searchList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: const Color.fromARGB(189, 63, 63, 63),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(searchList[index].image),
                            ),
                            title: Text(
                              searchList[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4.0),
                                Text(
                                  searchList[index].artist,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  searchList[index].album,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                heartvis = true;
                                playlist = searchList;
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
              )
            ],
          )),
    );
  }
}
