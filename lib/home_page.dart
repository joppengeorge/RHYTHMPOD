//import 'dart:ui';

//import 'package:ui/all_settings/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:ui/all_settings/settings_page.dart';
import 'audio/audioplayer.dart';
import 'pages/favourite.dart';
import 'pages/index.dart';
import 'pages/podcast.dart';
import 'pages/search.dart';
import 'package:miniplayer/miniplayer.dart';

//import 'global.dart';
import 'package:flutter/material.dart';
//import 'package:ionicons/ionicons.dart';
//import 'package:sliding_up_panel/sliding_up_panel.dart';

ValueNotifier<bool> currentlyPlaying = ValueNotifier(false);


class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  final MiniplayerController _miniplayerController = MiniplayerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CupertinoPage(),
          ValueListenableBuilder<bool>(
          valueListenable: currentlyPlaying,
          builder: (BuildContext context, bool isPlaying, Widget? child) {
          if(isPlaying)
          {
          return Positioned(
            left: 0,
            right: 0,
            bottom: 51,
            child: Miniplayer(
              controller: _miniplayerController,
              minHeight: 70,
              maxHeight: MediaQuery.of(context).size.height,
              builder: (height, percentage) {
                if(height<120)
                {
                return Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Song Title',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                'Artist Name',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          currentlyPlaying.value=false;
                        },
                      ),
                    ],
                  ),
                );
              }
              else
              {
                 return const AudioPlayerScreen();
              }
              }
            ),
          );
          }
          else
          {
            return Container();
          }
          }
          )
        ],
      ),
    );
  }
}

class CupertinoPage extends StatelessWidget {
  const CupertinoPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: const Color.fromARGB(255, 71, 68, 214),
        inactiveColor: Colors.grey,
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
              return CupertinoTabView(
              builder: (context) => const Index(),
               );
           case 1:
              return CupertinoTabView(
              builder: (context) => const Podcast(),
              
               );
           case 2:
            return CupertinoTabView(
              builder: (context) => const Favorite(),
               );
           case 3:
            return CupertinoTabView(
              builder: (context) => const Search(),
               );

            
          default:
             return CupertinoTabView(
              builder: (context) => const Podcast(),
               );

        }
      }
    );
  }
}
