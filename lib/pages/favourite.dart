import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
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
      appBar: AppBar(
      toolbarHeight: 70,
      title: const Text('Favourites'),
      backgroundColor: const Color.fromARGB(255, 71, 68, 214),
    ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('favorites').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
    
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
    
          if (snapshot.data!.size == 0) {
            return GestureDetector(
                onTap: () {
                  setState(() {}); // Refresh the page
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: const Text(
                    'No Favourites found. Tap to refresh.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
          }
    
           favList = snapshot.data!.docs.map((doc) {
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
                itemCount: favList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(favList[index].id), // Provide a unique key for each item
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      // Handle the dismissal action
                      setState(() {
                        // Remove the item from the list
                        favList.removeAt(index);
                      });
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(favList[index].image),
                      ),
                      title: Text(favList[index].title),
                      subtitle: Text(favList[index].artist),
                      onTap: () {
                        setState(() {
                          playlist = favList;
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
