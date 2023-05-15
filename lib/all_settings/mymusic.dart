import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class MymusicList extends StatefulWidget {
  const MymusicList({super.key});

  @override
  MymusicListState createState() => MymusicListState();
}

class MymusicListState extends State<MymusicList> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _audioStream;
  late String userId;
  @override
  void initState() {
    super.initState();
    userId=FirebaseAuth.instance.currentUser!.uid;
    _audioStream = FirebaseFirestore.instance
        .collection('audio')
        .where('user_id', isEqualTo: userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Music'),
      toolbarHeight: 70,
        backgroundColor: const Color.fromARGB(255, 71, 68, 214),),
      body: StreamBuilder<QuerySnapshot>(
        stream: _audioStream,
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
          if(mounted)
          {
            setState(() {});
          }
          
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
        "No Music Yet !!",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        ),
      )
      
        );
          }

         return RefreshIndicator(
                    onRefresh: () async {
                    // Your refresh logic goes here
                    if(mounted)
                    {
                      setState(() {
                      
                    });
                    }
                    
                  },
           child: ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (BuildContext context, int index) {
                  var doc = snapshot.data!.docs[index];
                  return Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      leading: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage(doc['image_url']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        doc['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(
                            doc['artist'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            'Type: ${doc['type']}',
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            'Album: ${doc['album']}',
                          ),
                        ],
                      ),
                      trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Show a confirmation dialog before deleting the audio document and its corresponding files
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Deletion',style: TextStyle(color: Colors.red)),
                              content: const Text('Are you sure you want to delete this music?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel',style: TextStyle(color: Colors.blue),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete',style: TextStyle(color: Colors.red)),
                                  onPressed: () async {
                                    // Delete the audio document from Firestore and the corresponding audio and image files from Firebase Storage
                                    await FirebaseFirestore.instance.collection('audio').doc(doc.id).delete();
                                    await FirebaseStorage.instance.refFromURL(doc['audio_url']).delete();
                                    await FirebaseStorage.instance.refFromURL(doc['image_url']).delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                         const SnackBar(content: Text("Deleted.....")));
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    ),
                  );
                },
              ),
         );

        },
      ),
    );
  }
}
