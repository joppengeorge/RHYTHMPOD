import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../all_settings/settings_page.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: const Color.fromARGB(255, 71, 68, 214),
          title: Container(
              
              margin: const EdgeInsets.only(top: 10),
              child: Center(
                child: Row(
                  children: const [
                     SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Favourite",
                              style: TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                                ],
                ),
              )
          ),
           actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()));
                },
                icon: const Icon(
                  Ionicons.settings_outline,
                  size: 29,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 10,
            ),
          ],
         ),
        body: Center(
        child: ElevatedButton(
        onPressed: () {
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
        "No Favorite Yet !!",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        ),
      )
      
        ),
      ),
    );
  }
}
