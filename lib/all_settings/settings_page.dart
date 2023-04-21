import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui/main.dart';
import 'userprofile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
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
                    MaterialPageRoute(builder: (context) => Userdetails()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add music or podcast'),
              onTap: () {},
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
      bottomNavigationBar: Container(
        height: 60,
        child: ElevatedButton(
          onPressed: () {
           FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>HomePage()), (route) => false);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 71, 68, 214)),
          child: const Text('Log Out'),
        ),
      ),
    );
  }
}