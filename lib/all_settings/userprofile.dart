import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui/all_settings/editprofile.dart';


class Userdetails extends StatefulWidget {
  const Userdetails({super.key});


  @override
  State<Userdetails> createState() => _UserdetailsState();
}

class _UserdetailsState extends State<Userdetails> {

  String? name='';
  String? email='';
  String? phone='';
  bool? isLoading;

  Future getdetails() async
  {
    setState(() {
    isLoading = true; // set the isLoading state to true
  });
    await FirebaseFirestore.instance.collection("users")
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get()
    .then((snapshot) async
    {
      if(snapshot.exists)
      {
        setState(() {
          email=snapshot.data()!["Email"];
          phone=snapshot.data()!["Phone"];
         name= snapshot.data()!["Name"];
        });
      }
      
    } 
    );

    setState(() {
    isLoading = false; // set the isLoading state to false
  });
  }
  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
    getdetails();
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading!) {
  return Container(color: Colors.white,
    child: const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 71, 68, 214)),
      ),
    ),
  );
} else {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(255, 71, 68, 214),
        title: const Text('User Profile'),
          actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditUserDetailsPage()));
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Name :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              name!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Phone Number :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              phone!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Email :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              email!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
  }
}
