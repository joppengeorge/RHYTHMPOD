import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class UploadAudioScreen extends StatefulWidget {
  const UploadAudioScreen({super.key});

  @override
  UploadAudioScreenState createState() => UploadAudioScreenState();
}

class UploadAudioScreenState extends State<UploadAudioScreen> {
  late String title;
  late String artist;
  late String album;
   String type='Music';
   File? imageFile;
   File? audioFile;
String? dropdownValue = 'Music'; 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _uploadAudio() async {
    // Upload image to Firebase Storage
    final imageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final imageUploadTask = imageRef.putFile(imageFile!);
    final imageUrl = await (await imageUploadTask).ref.getDownloadURL();

    // Upload audio to Firebase Storage
    final audioRef = FirebaseStorage.instance
        .ref()
        .child('audio/${DateTime.now().millisecondsSinceEpoch}.mp3');
    final audioUploadTask = audioRef.putFile(audioFile!);
    final audioUrl = await (await audioUploadTask).ref.getDownloadURL();
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;

    // Add audio details to Firebase Firestore
    try {
      final docRef = await FirebaseFirestore.instance.collection('audio').add({
        'user_id' : uid,
        'title': title,
        'artist': artist,
        'album': album,
        'type': type,
        'image_url': imageUrl,
        'audio_url': audioUrl,
      });
      //TODO: Do something with the docRef, if needed
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('Error adding audio details to Firestore: $e')));
      print('Error adding audio details to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Audio'),
      toolbarHeight: 70,
      backgroundColor: const Color.fromARGB(255, 71, 68, 214),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16.0),
              TextFormField(
                decoration:  InputDecoration(hintText: 'Title',border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  if(mounted)
                  {
                    setState(() {
                    title = value!;
                  });
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration:  InputDecoration(hintText: 'Artist',border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an artist';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    artist = value!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration:  InputDecoration(hintText: 'Album',border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an album';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    album = value!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
             // set initial value

                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Color.fromARGB(255, 71, 68, 214)),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      type=dropdownValue!;
                    });
                  },
                  items: <String>['Music', 'Podcast'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 71, 68, 214),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(10,50)
                ),
                child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children:  [
                          Icon(
                            imageFile != null ? Icons.check_circle : Icons.camera_alt,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            imageFile != null ? 'Image Selected' : 'Choose Image',
                            style: const TextStyle(color: Colors.white,fontSize: 15),
                          ),
                        ],
                      ),
                onPressed: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile == null) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No Image Selected")));
                    return;
                  }
                  setState(() {
                    imageFile = File(pickedFile.path);
                  });
                },
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 71, 68, 214),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(10,50)
                  //maximumSize: const Size(50, 70)
                ),
                child:  Row(
                        mainAxisSize: MainAxisSize.min,
                        children:  [
                          Icon(
                              audioFile != null ? Icons.check_circle : Icons.audio_file,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              audioFile != null ? 'Audio Selected' : 'Choose Audio',
                              style: const TextStyle(color: Colors.white,fontSize: 15),
                              
                            ),
                        ],
                        
                      ),
                      
                onPressed: () async {
                  final result =
                      await FilePicker.platform.pickFiles(type: FileType.audio);
                  if (result == null) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No Audio Selected")));
                    return;
                  }
                  setState(() {
                    audioFile = File(result.files.single.path!);
                  });
                },
              ),
              const SizedBox(height: 100.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 71, 68, 214),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  minimumSize: const Size(10,60)
                ),
                child: const Text('Upload',style: TextStyle(fontSize: 20),),
                
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if(imageFile!=null && audioFile!=null)
                    {
                      _uploadAudio();
                      // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("UPLOADED SUCCESSFULLY")));
                    Navigator.pop(context);
                    }
                    else
                    {
                        // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("PLEASE SELECT THE FILES")));
                    }
                    
                  }
                },
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
