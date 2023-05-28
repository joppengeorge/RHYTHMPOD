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
      backgroundColor: const Color.fromARGB(234, 11, 11, 11),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color.fromARGB(234, 11, 11, 11),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                'Account',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Userdetails()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.white),
              title: const Text(
                'Add music or podcast',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadAudioScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.queue_music, color: Colors.white),
              title: const Text(
                'My Music',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MymusicList()));
              },
            ),
            /*const Divider(),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate the App'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share the App'),
              onTap: () {},
            ),
            const Divider(),*/
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(100,16,100,20),
          child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:  const Color.fromARGB(255, 62, 62, 62),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(height: 3), // add some top padding
                Center(
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 20, // adjust font size as needed
                      // optional: set font weight
                      color: Colors.white, // optional: set text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
