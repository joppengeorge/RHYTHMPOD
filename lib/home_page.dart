import 'package:flutter/cupertino.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:audioplayers/audioplayers.dart'; //as audioplayers;
import 'package:ui/audio/tracks.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'audio/audioplayer.dart';
import 'pages/favourite.dart';
import 'pages/index.dart';
import 'pages/podcast.dart';
import 'pages/search.dart';
import 'package:miniplayer/miniplayer.dart';

import 'global.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> currentindex = ValueNotifier(-1);

bool isPlaying = false;



List<Music> playlist = MusicOperation.getmusic();

class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);
  @override
  State<HomePage1> createState() => HomePage1State();
}

class HomePage1State extends State<HomePage1> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Stack(
        children: [
          const CupertinoPage(),
          ValueListenableBuilder<int>(
              valueListenable: currentindex,
              builder: (BuildContext context, int isopen, Widget? child) {
                if (isopen > -1) {
                  return Positioned(
                      left: 0,
                      right: 0,
                      bottom: 50.2,
                      child: MiniplayerWidget(currentindex: isopen));
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }
}

class CupertinoPage extends StatelessWidget {
  const CupertinoPage({
    super.key,
  });

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
        tabBuilder: (context, index) {
          switch (index) {
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
        });
  }
}

class MiniplayerWidget extends StatefulWidget {
  final int currentindex;

  
  const MiniplayerWidget({super.key, required this.currentindex});

  @override
  State<MiniplayerWidget> createState() => MiniplayerWidgetState();
}

class MiniplayerWidgetState extends State<MiniplayerWidget> {

  final MiniplayerController _miniplayerController = MiniplayerController();
  static final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    //_audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((playerState) {
      if (mounted) {
        if (playerState == PlayerState.COMPLETED) {
          setState(() {
            currentindex.value++;
            if (currentindex.value >= playlist.length) {
              currentindex.value = 0;
            }
            isPlaying = false;
          });
        } else if (playerState == PlayerState.PLAYING) {
          setState(() {
            isPlaying = true;
          });
        } else if (playerState == PlayerState.PAUSED) {
          setState(() {
            isPlaying = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> play() async {
    int result = await audioPlayer.play(playlist[widget.currentindex].audio);
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
    }
  }

  Future<void> pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future<void> next() async {
    setState(() {
      if (currentindex.value == playlist.length - 1) {
        currentindex.value = 0;
      } else {
        currentindex.value = currentindex.value + 1;
      }
      isPlaying = false;
    });
  }

  Future<void> previous() async {
    setState(() {
      if (currentindex.value == 0) {
        currentindex.value = playlist.length - 1;
      } else {
        currentindex.value = currentindex.value - 1;
      }
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Miniplayer(
        controller: _miniplayerController,
        minHeight: 70,
        maxHeight: MediaQuery.of(context).size.height,
        builder: (height, percentage) {
          if (height < 120) {
            return Container(
                height: height,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 71, 68, 214),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        playlist[widget.currentindex].image.toString(),
                        height: 60,
                        width: 50,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playlist[widget.currentindex].title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            playlist[widget.currentindex].artist,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: previous,
                      icon: const Icon(Icons.skip_previous)),
                  IconButton(
                    onPressed: isPlaying ? pause : play,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    iconSize: 35,
                    color: Colors.white,
                  ),
                  IconButton(
                      onPressed: next,
                      icon: const Icon(Icons.skip_next)),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        currentindex.value = -1;
                      });
                      // Your cancel button code here
                    },
                  )
                ]));
          } else {
            return AudioPlayerScreen(
                
                currentindex: widget.currentindex,
                play: play,
                pause: pause,
                previous:previous,
                next:next);
          }
        });
  }
}
