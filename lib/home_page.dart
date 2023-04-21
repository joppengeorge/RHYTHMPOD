//import 'dart:ui';

//import 'package:ui/all_settings/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'pages/favourite.dart';
import 'pages/index.dart';
import 'pages/podcast.dart';
import 'pages/search.dart';
//import 'global.dart';
import 'package:flutter/material.dart';
//import 'package:ionicons/ionicons.dart';
//import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  @override
  Widget build(BuildContext context) {

    return const Scaffold(
     
      bottomNavigationBar: CupertinoPage()
         
    );
  }
}

class CupertinoPage extends StatelessWidget {
  const CupertinoPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Colors.red,
          inactiveColor: Colors.black,
        items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Music',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.headphones),
              label: 'Podcast',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
      
      ),
      tabBuilder: (context,index)
      {
        switch(index)
        {
          case 0:
            return CupertinoTabView(builder: (context)
            {
              return const CupertinoPageScaffold(
                child: Index()
                );
            });
           case 1:
            return CupertinoTabView(builder: (context)
            {
              return const CupertinoPageScaffold(
                child: Podcast()
                );
            });
           case 2:
            return CupertinoTabView(builder: (context)
            {
              return const CupertinoPageScaffold(
                child: Favorite()
                );
            });
           case 3:
            return CupertinoTabView(builder: (context)
            {
              return const CupertinoPageScaffold(
                child: Search()
                );
            });
          default:
             return CupertinoTabView(builder: (context)
            {
              return const CupertinoPageScaffold(
                child: Podcast()
                );
            });

        }
      }
    );
  }
}
