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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
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
                  Navigator.of(context,rootNavigator: true).push(
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
        body: fav.isEmpty?
        Center(
        child: ElevatedButton(
        onPressed: () {
          setState(() {});
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
      
        ):
        RefreshIndicator(
                  onRefresh: () async {
                    // Your refresh logic goes here
                    setState(() {
                      
                    });
                  },
      child:  ListView.builder(
        itemCount: fav.length,
        itemBuilder: (BuildContext context, int index) {
          return  Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          isPlaying=false;
          fav[index].isfavourite=false;
          fav.removeAt(index);
        });
      
      },
      child:
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(fav[index].image),),
            title: Text(fav[index].title),
            subtitle: Text(fav[index].artist),
            onTap: () {
                setState(() {
                  playlist=fav;
                  currentindex.value=index;
                  isPlaying=false;
                });
                
            },
          )
          );
        },
      ),
      ),
    ));
  }
}
