import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui/all_settings/upload.dart';
import 'package:ui/main.dart';
import 'userprofile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color.fromARGB(255, 71, 68, 214),
        title: const Text('Settings'),
        
      
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Account'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Userdetails()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add music or podcast'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UploadAudioScreen()));
              },
            ),
           /* const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {},
            ),
            const Divider(),
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
          height: 70,
          child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>const HomePage()), (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 71, 68, 214),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(height: 5), // add some top padding
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

    );
  }
}