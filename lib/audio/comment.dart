import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentSection extends StatefulWidget {
  final String audioId;
  
  const CommentSection({super.key, required this.audioId});

  @override
  CommentSectionState createState() => CommentSectionState();
}

class CommentSectionState extends State<CommentSection> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          Container(
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            'Comments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comments')
                    .where('audio_id', isEqualTo: widget.audioId)
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
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
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB6AFAF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        ),
                        child: const Text(
                          "No Comments Yet !!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }
                
                  List<DocumentSnapshot> comments = snapshot.data!.docs;
                  String userId = FirebaseAuth.instance.currentUser!.uid;
                
                  List<Widget> messageWidgets = [];
                  for (var comment in comments) {
                    bool isCurrentUser = comment['user_id'] == userId;
                    Color boxColor = isCurrentUser ? Colors.blue : Colors.grey;
                    CrossAxisAlignment alignment = isCurrentUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start;
                
                    Widget messageWidget = GestureDetector(
                    onLongPress: () {
                      if (isCurrentUser) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Message'),
                              content: const Text('Are you sure you want to delete this message?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    deleteComment(comment.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: alignment,
                      children: [
                        Text(comment['user_name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment['message'], style: const TextStyle(color: Colors.white, fontSize: 16)),
                              const SizedBox(height: 4.0),
                              Text(
                                _formatDateTime(comment['timestamp']),
                                style: const TextStyle(fontSize: 11.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

                
                    messageWidgets.add(messageWidget);
                  }
                
                  messageWidgets = messageWidgets.reversed.toList();
                
                  return ListView(
                    reverse: true,
                    children: messageWidgets,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Write a comment...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send,color: Colors.blue,),
                  onPressed: () {
                    postComment();
                  },
                ),
              ],
            ),
          ),
        ]
        );
      
  }

  Future<void> postComment() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    var snapshot = await userDoc.get();
    String name = snapshot.data()?['Name'];

    String message = commentController.text;
    String username = name;
    String audioId = widget.audioId;

    if (message.isNotEmpty) {
      FirebaseFirestore.instance.collection('comments').add({
        'user_id': uid,
        'user_name': username,
        'audio_id': audioId,
        'message': message,
        'timestamp': DateTime.now(),
      });

      commentController.clear();
    }
  }

   Future<void> deleteComment(String commentId) async {
    await FirebaseFirestore.instance.collection('comments').doc(commentId).delete();
  }

  String _formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat.yMd().add_jm().format(dateTime);
    return formattedDate;
  }
}


