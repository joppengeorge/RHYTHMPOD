import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui/global.dart';

import '../all_settings/settings_page.dart';
import '../home_page.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  FavoriteState createState() => FavoriteState();
}

class FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 41, 41),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color.fromARGB(255, 55, 54, 54),
        title: Container(
            margin: const EdgeInsets.only(top: 10),
            child:  const Center(
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Favourites",
                    style: TextStyle(
                        color: Color.fromARGB(255, 235, 235, 235),
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
                Icons.settings,
                size: 30,
                color: Colors.white,
              )),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 55, 54, 54),
              Color.fromARGB(255, 0, 0, 0),
              //  Color.fromARGB(255, 37, 7, 7),
              //  Color.fromARGB(255, 17, 17, 17),
            ],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('favorites')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: const Text(
                  "No Favorite Yet !!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ));
            }

            favList = snapshot.data!.docs.map((doc) {
              return Music(doc['audio_id'], doc['image_url'], doc['title'],
                  doc['album'], doc['artist'], doc['audio_url'], doc['type']
                  // Set isFavourite to false by default
                  );
            }).toList();

            return ReorderableListView.builder(
              itemCount: favList.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(
                      favList[index].id), // Provide a unique key for each item
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  onDismissed: (direction) {
                    // Handle the dismissal action
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('favorites')
                        .where('audio_id', isEqualTo: favList[index].id)
                        .get()
                        .then((querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        doc.reference.delete();
                      }
                      /*FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('favorites')
                              .where('audio_id', isEqualTo:favList[index].id)
                              .delete();*/
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Removed from Favorites')));
                    });
                  },
                  child: Container(
                    color: const Color.fromARGB(
                        255, 42, 41, 41), // Set the desired background color
                    child: ListTile(
                      key: Key(favList[index].id), // Required for reordering
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(favList[index].image),
                      ),
                      title: Text(
                        favList[index].title,
                        style: const TextStyle(
                            color: Color.fromARGB(197, 18, 253, 226),
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        favList[index].artist,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 235, 235, 235),
                        ),
                      ),
                      onTap: () {
                        if(mounted)
                        {
                          setState(() {
                          playlist = favList;
                          currentindex.value = index;
                          MiniplayerWidgetState.audioPlayer.seek(
                            Duration.zero,
                            index: index,
                          );
                        });
                        }
                        
                      },
                    ),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = favList.removeAt(oldIndex);
                  favList.insert(newIndex, item);
                });
              },
            );
          },
        ),
      ),
    );
  }
}
