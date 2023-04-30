
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:just_audio_background/just_audio_background.dart';

import 'audio/audioplayer.dart';
import 'pages/favourite.dart';
import 'pages/index.dart';
import 'pages/podcast.dart';
import 'pages/search.dart';
import 'package:miniplayer/miniplayer.dart';

import 'global.dart';
import 'package:flutter/material.dart';



ValueNotifier<bool> showMiniplayer = ValueNotifier(false);



class HomePage1 extends StatefulWidget {

  const HomePage1({Key? key}) : super(key: key);
  @override

  HomePage1State createState() => HomePage1State();
}
class HomePage1State extends State<HomePage1> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:  [
          const CupertinoPage(),
          ValueListenableBuilder<bool>(
          valueListenable: showMiniplayer,
          builder: (BuildContext context, bool isMini, Widget? child) 
          {
            if(isMini){
            return Positioned(
                left: 0,
                right: 0,
                bottom: 50.2,
                child: MiniplayerWidget(mediaItem: selectedMediaItem));
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
  const CupertinoPage({super.key,});

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



class MiniplayerWidget extends StatefulWidget {
  
  final MediaItem mediaItem;

  const MiniplayerWidget({super.key, required this.mediaItem});

  @override
  State<MiniplayerWidget> createState() => _MiniplayerWidgetState();
}

class _MiniplayerWidgetState extends State<MiniplayerWidget> {


  late AudioPlayer _audioPlayer;

  final MiniplayerController _miniplayerController = MiniplayerController();



  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(playlist);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
     return  Miniplayer(
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
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.mediaItem.artUri.toString(),
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
                            children:  [
                              Text(
                               widget.mediaItem.title,
                                style: const TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                widget.mediaItem.artist!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                       StreamBuilder<PlayerState>(
                        stream: _audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          if (!(playing ?? false)) {
                            return IconButton(
                              onPressed: _audioPlayer.play,
                              iconSize: 35,
                              color: Colors.white,
                              icon: const Icon(Icons.play_arrow_rounded),
                            );
                          } else if (processingState != ProcessingState.completed) {
                            return IconButton(
                              onPressed: _audioPlayer.pause,
                              iconSize: 35,
                              color: Colors.white,
                              icon: const Icon(Icons.pause_rounded),
                            );
                          }
                          return const Icon(Icons.play_arrow_rounded,
                              size: 35, color: Colors.white);
                        },
                     ),
                      /*IconButton(
                        icon: const Icon(Icons.play_arrow,color: Colors.white,size: 35,),
                        onPressed: () {},
                      ),*/
                      IconButton(
                        icon: const Icon(Icons.cancel_rounded,color: Colors.white,),
                        onPressed: () {
                          setState(() {
                                  showMiniplayer.value = false;
                                });
                          // Your cancel button code here
                        },
                      ),
                    ],
                  ),
                );
              }

              else
              {
                 return  AudioPlayerScreen(audioPlayer: _audioPlayer);
              }
              }
            );
      }
    
  }
