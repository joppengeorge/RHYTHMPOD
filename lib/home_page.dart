import 'package:flutter/cupertino.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:audioplayers/audioplayers.dart'; //as audioplayers;
//import 'package:ui/audio/tracks.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
//import 'audio/audioplayer.dart';
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
  Duration _duration = const Duration();
  Duration _position = const Duration();

final ScrollController _scrollController = ScrollController();

double _miniplayerPosition = 0;

  final MiniplayerController _miniplayerController = MiniplayerController();
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
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

    audioPlayer.onDurationChanged.listen((Duration duration) {
      if(mounted)
      {
      setState(() {
        _duration = duration;
      });
      }
    });

    audioPlayer.onAudioPositionChanged.listen((Duration position) {
      if(mounted)
      {
      setState(() {
        _position = position;
      });
      }
    });
  }

  String formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
     _scrollController.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> play() async {
    if(mounted)
    {
    int result = await audioPlayer.play(playlist[widget.currentindex].audio);
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
    }
    }
  }

  Future<void> pause() async {
    if(mounted)
    {
    int result = await audioPlayer.pause();
    if (result == 1) {
      setState(() {
        isPlaying = false;
      });
    }
    }
  }

  Future<void> next() async {
    if(mounted)
    {
    setState(() {
      if (currentindex.value == playlist.length - 1) {
        currentindex.value = 0;
      } else {
        currentindex.value = currentindex.value + 1;
      }
      isPlaying = false;
    });
    }
  }

  Future<void> previous() async {
    if(mounted)
    {
    setState(() {
      if (currentindex.value == 0) {
        currentindex.value = playlist.length - 1;
      } else {
        currentindex.value = currentindex.value - 1;
      }
      isPlaying = false;
    });
    }
  }

  void togglefav(int index) {
    if(mounted)
    {
    setState(() {
      playlist[index].isfavourite = !playlist[index].isfavourite;
      if (playlist[index].isfavourite) {
        fav.add(playlist[index]);
        print(playlist[index].artist);
      } else {
        fav.remove(playlist[index]);
      }
    });
    }
  }

  void _handleScroll() {
    final maxPosition =
    MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight;
    const minPosition = 120.0;
    final newPosition = _scrollController.offset.clamp(minPosition, maxPosition);
    setState(() {
      _miniplayerPosition = newPosition;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Miniplayer(
        controller: _miniplayerController,
        minHeight: 82,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                playlist[widget.currentindex].image.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
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
                          icon: const Icon(Icons.skip_previous),
                          iconSize: 35,),
                      IconButton(
                        onPressed: isPlaying ? pause : play,
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        iconSize: 40,
                        color: Colors.white,
                      ),
                      IconButton(
                          onPressed: next, icon: const Icon(Icons.skip_next),
                          iconSize: 35,),
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
                    ]
                    )
                    );
          } else {
            return NotificationListener<ScrollNotification>(
                onNotification: (notification) => true,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Scaffold(
                            extendBodyBehindAppBar: true,
                            appBar: AppBar(
                              toolbarHeight: 150,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              leading: const Icon(Icons.arrow_drop_down_sharp),
                              actions: [IconButton(
                                            onPressed: () {
                                              togglefav(widget.currentindex);
                                            },
                                            icon: Icon(playlist[widget.currentindex].isfavourite
                                                ? Icons.favorite
                                                : Icons.favorite_border,),iconSize: 30,
                                                    color: Colors.white,),]
                            ),
                            bottomNavigationBar: null,
                            body: Container(
                              padding: const EdgeInsets.all(20),
                              height: double.infinity,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF144771),
                                    Color(0xFF071A2C)
                                  ],
                                ),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          formatDuration(_position),
                                          style: const TextStyle(
                                              color: Colors.orange),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text("|"),
                                        const SizedBox(width: 10),
                                        Text(
                                          formatDuration(_duration),
                                          style: const TextStyle(
                                              color: Colors.orange),
                                        ),
                                      ],
                                    ),
                                    SleekCircularSlider(
                                      min: 0,
                                      max: _duration.inSeconds.toDouble(),
                                      initialValue:
                                          _position.inSeconds.toDouble().isNaN? 0:_position.inSeconds.toDouble(),
                                      onChange: (value) async {
                                        if(value.isFinite)
                                        {
                                        await audioPlayer.seek(
                                            Duration(seconds: value.toInt()));
                                        }
                                      },
                                      innerWidget: (percentage) {
                                        return Padding(
                                          padding: const EdgeInsets.all(25),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage: NetworkImage(
                                                playlist[widget.currentindex]
                                                    .image),
                                          ),
                                        );
                                      },
                                      appearance: CircularSliderAppearance(
                                          size: 330,
                                          angleRange: 300,
                                          startAngle: 300,
                                          customColors: CustomSliderColors(
                                              progressBarColor: Colors.orange,
                                              dotColor: Colors.blue,
                                              trackColor:
                                                  Colors.grey.withOpacity(.4)),
                                          customWidths: CustomSliderWidths(
                                              trackWidth: 6,
                                              handlerSize: 10,
                                              progressBarWidth: 6)),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      playlist[widget.currentindex].title,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      playlist[widget.currentindex].artist,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: previous,
                                          icon: const Icon(Icons.skip_previous),
                                          iconSize: 40,
                                          color: Colors.white,
                                        ),
                                        CircleAvatar(
                                          radius: 25,
                                          child: IconButton(
                                            onPressed: () {
                                              if (isPlaying) {
                                                pause();
                                              } else {
                                                play();
                                              }
                                            },
                                            icon: Icon(
                                              isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: next,
                                          icon: const Icon(Icons.skip_next),
                                          iconSize: 40,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 71, 68, 214)),
                                            child: const Text('Live Chat'),
                                          ),
                                          const SizedBox(width: 120),
                                          IconButton(
                                            onPressed: () {},
                                            iconSize: 30,
                                            color: Colors.white,
                                            icon: const Icon(Icons.download),
                                          ),
                                          const SizedBox(width: 10),
                                          IconButton(
                                            onPressed: () {},
                                            iconSize: 30,
                                            color: Colors.white,
                                            icon: const Icon(Icons.share),
                                          ),
                                           
                                        ],
                                      ),
                                    ),
                                  ]),
                            )
                            ))
                            )
                            );
          }
        });
  }
}
