import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui/all_settings/mymusic.dart';
import 'package:ui/all_settings/upload.dart';
import 'package:ui/main.dart';
import 'userprofile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 42, 41, 41),
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.account_circle,
                  color: Color.fromARGB(197, 18, 253, 226),
                  size: 32,
                ),
                title: const Text(
                  'Account',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Userdetails()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.library_music_outlined,
                  color: Color.fromARGB(197, 18, 253, 226),
                  size: 32
                ),
                title: const Text(
                  'Add music or podcast',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadAudioScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.upload_file_rounded,
                  color: Color.fromARGB(197, 18, 253, 226),
                  size: 32
                ),
                title: const Text(
                  'My Uploads',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MymusicList()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(100, 16, 100, 20),
          child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(197, 18, 253, 226),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 3), // add some top padding
                Center(
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // adjust font size as needed
                      // optional: set font weight
                      color: Color.fromARGB(
                        255,
                        0,
                        0,
                        0, // optional: set text color
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
