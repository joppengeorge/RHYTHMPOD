import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:ui/audio/comment.dart';
import 'pages/favourite.dart';
import 'pages/index.dart';
import 'pages/podcast.dart';
import 'pages/search.dart';
import 'package:miniplayer/miniplayer.dart';
import 'global.dart';

ValueNotifier<int> currentindex = ValueNotifier(-1);

//bool isPlaying = false;
late List<Music> playlist;
//MusicOperation.getmusic();

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
                      bottom: 52,
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
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          activeColor: const Color.fromARGB(197, 18, 253, 226),
          inactiveColor: const Color.fromARGB(255, 171, 171, 171),
          //border: const Border(top: BorderSide(color:  Color.fromRGBO(58, 58, 58, 1),width: 4),
          //bottom: BorderSide(color:  Color.fromRGBO(58, 58, 58, 1),width: 4)),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.headphones), 
               // label: 'music'
                ),
            BottomNavigationBarItem(
                icon: Icon(Icons.podcasts_rounded), 
               // label: 'podcast'
                ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
               //  label: 'favorites'
                 ),
            BottomNavigationBarItem(icon: Icon(Icons.search),
            // label: 'search'
             ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (context) => const MusicPage(),
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
  final ScrollController _scrollController = ScrollController();

  List<AudioSource> audiosource = [];

  double miniplayerPosition = 0;
  double downloadProgress = 0.0;
  bool isDownloading = false;
  bool isfavourite = false;
  bool isselfloop = false;
  bool isshuffle = false;

  final MiniplayerController _miniplayerController = MiniplayerController();
  static AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    initAudio();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    audioPlayer.stop();
    //audioPlayer.dispose();
    super.dispose();
  }

  Future<void> initAudio() async {
    for (Music music in playlist) {
      audiosource.add(
        AudioSource.uri(
          Uri.parse(music.audio),
          tag: MediaItem(
            id: music.id,
            title: music.title,
            artist: music.artist,
            album: music.album,
            genre: music.type,
            artUri: Uri.parse(music.image),
          ),
        ),
      );
     // print(widget.currentindex);
    }

    final allplaylist = ConcatenatingAudioSource(children: audiosource);

    await audioPlayer.setAudioSource(allplaylist);
    await audioPlayer.seek(Duration.zero, index: currentindex.value);
    await audioPlayer.setLoopMode(LoopMode.all);
  }

  String formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void playNext() async {
    await audioPlayer.seekToNext();
    if (mounted) {
      setState(() {
        if (currentindex.value == playlist.length - 1) {
          currentindex.value = 0;
        } else {
          currentindex.value++;
        }
      });
    }
  }

  void playPrevious() async {
    await audioPlayer.seekToPrevious();
    if (mounted) {
      setState(() {
        if (currentindex.value == 0) {
          currentindex.value = playlist.length - 1;
        } else {
          currentindex.value--;
        }
      });
    }
  }

  void play() async {
    await audioPlayer.play();
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void checkFavoriteStatus(String audioid) {
    String audioId = audioid;

    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .where('audio_id', isEqualTo: audioId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Audio is a favorite for the user
        if (mounted) {
          setState(() {
            isfavourite = true;
          });
        }
      } else {
        // Audio is not a favorite for the user
        if (mounted) {
          setState(() {
            isfavourite = false;
          });
        }
      }
    });
  }

  void toggleFavoriteStatus(String audioId, String title, String artist,
      String album, String type, String imageUrl, String audioUrl) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    if (isfavourite) {
      // Remove audio from favorites
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .where('audio_id', isEqualTo: audioId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
        if (mounted) {
          setState(() {
            isfavourite = false;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Removed from Favourites')));
      });
    } else {
      // Check if audio already exists in favorites
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .where('audio_id', isEqualTo: audioId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          // Audio does not exist in favorites, add it
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('favorites')
              .add({
            'audio_id': audioId,
            'title': title,
            'artist': artist,
            'album': album,
            'type': type,
            'image_url': imageUrl,
            'audio_url': audioUrl,
          }).then((value) {
            if (mounted) {
              setState(() {
                isfavourite = true;
              });
            }
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to  Favourites')));
          });
        } else {
          //print('Duplicate');
          // Audio already exists in favorites
          // Handle the duplicate case as desired
        }
      });
    }
  }

  void _handleScroll() {
    final maxPosition = MediaQuery.of(context).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight;
    const minPosition = 120.0;
    final newPosition =
        _scrollController.offset.clamp(minPosition, maxPosition);
    setState(() {
      miniplayerPosition = newPosition;
    });
  }

  Future<void> downloadSong(String audioUrl, String title, context) async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    final directory = await getExternalStorageDirectory();
    final downloadsDirectory = Directory('${directory!.path}/Download');
    final filePath = '${downloadsDirectory.path}/$title.mp3';
    final file = File(filePath);

    try {
      // Create the necessary directories if they don't exist
      if (!downloadsDirectory.existsSync()) {
        downloadsDirectory.createSync(recursive: true);
      }

      final storageRef =
          firebase_storage.FirebaseStorage.instance.refFromURL(audioUrl);
      final task = storageRef.writeToFile(file);

      task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;

        setState(() {
          downloadProgress = progress;
        });
      });

      await task;

     // print('Song downloaded successfully. File path: $filePath');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Song downloaded successfully. File path: $filePath')));
    } catch (e) {
      //print('Error downloading the song: $e');
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
        stream: audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence.isEmpty ?? true) {
            return const SizedBox();
          }
          final metaData = state!.currentSource!.tag as MediaItem;
          final image = metaData.artUri.toString();
          final artist = metaData.artist ?? '';
          final title = metaData.title;
          final audioid = metaData.id;
          final album = metaData.album;
          final type = metaData.genre;

          checkFavoriteStatus(audioid);
          return Miniplayer(
              controller: _miniplayerController,
              minHeight: 82,
              maxHeight: MediaQuery.of(context).size.height,
              builder: (height, percentage) {
                if (height < 120) {
                  return Container(
                      height: height,
                      decoration: BoxDecoration(
                        gradient:  const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromARGB(255, 58, 9, 2),
                            Color.fromRGBO(68, 33, 33, 1),
                            Color.fromRGBO(7, 7, 7, 1),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0)),
                        //color: const Color.fromARGB(255, 71, 68, 214),
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
                                      image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    /*Text(
                                      artist,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.0,
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: playPrevious,
                              icon: const Icon(Icons.skip_previous),
                              iconSize: 32,
                              color: Colors.white,
                            ),
                            StreamBuilder<PlayerState>(
                              stream: audioPlayer.playerStateStream,
                              builder: (context, snapshot) {
                                final playerState = snapshot.data;
                                final processingState =
                                    playerState?.processingState;
                                final playing = playerState?.playing;
                                if (!(playing ?? false)) {
                                  return IconButton(
                                    onPressed: play,
                                    iconSize: 37,
                                    color: Colors.white,
                                    icon: const Icon(Icons.play_arrow),
                                  );
                                } else if (processingState !=
                                    ProcessingState.completed) {
                                  return IconButton(
                                    onPressed: pause,
                                    iconSize: 37,
                                    color: Colors.white,
                                    icon: const Icon(Icons.pause),
                                  );
                                }
                                return const Icon(Icons.play_arrow_rounded,
                                    size: 37, color: Colors.white);
                              },
                            ),
                            IconButton(
                              onPressed: playNext,
                              icon: const Icon(Icons.skip_next),
                              iconSize: 32,
                              color: Colors.white,
                            ),
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
                  return NotificationListener<ScrollNotification>(
                      onNotification: (notification) => true,
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const ClampingScrollPhysics(),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: SafeArea(
                                child: Scaffold(
                                    extendBodyBehindAppBar: true,
                                    appBar: AppBar(
                                        toolbarHeight: 150,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        leading: const Icon(
                                            Icons.arrow_drop_down_sharp),
                                        actions: [
                                            IconButton(
                                              onPressed: () {
                                                toggleFavoriteStatus(
                                                    audioid,
                                                    title,
                                                    artist,
                                                    album!,
                                                    type!,
                                                    image,
                                                    playlist[
                                                            widget.currentindex]
                                                        .audio);
                                              },
                                              icon: Icon(
                                                isfavourite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                              ),
                                              iconSize: 30,
                                              color:  Colors.white,
                                            ),
                                        ]),
                                    bottomNavigationBar: null,
                                    body: Container(
                                      padding: const EdgeInsets.all(20),
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration:  const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color.fromARGB(255, 58, 9, 2),
                                            Color.fromRGBO(68, 33, 33, 1),
                                            Color.fromRGBO(7, 7, 7, 1),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            StreamBuilder<Duration?>(
                                              stream:
                                                  audioPlayer.durationStream,
                                              builder: (context, snapshot) {
                                                final duration =
                                                    snapshot.data ??
                                                        Duration.zero;
                                                return StreamBuilder<Duration>(
                                                  stream: audioPlayer
                                                      .positionStream,
                                                  builder: (context, snapshot) {
                                                    var position =
                                                        snapshot.data ??
                                                            Duration.zero;
                                                    if (position > duration) {
                                                      position = duration;
                                                    }
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              formatDuration(
                                                                  position),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            const Text("|"),
                                                            const SizedBox(
                                                                width: 10),
                                                            Text(
                                                              formatDuration(
                                                                  duration),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                        SleekCircularSlider(
                                                          min: 0,
                                                          max: duration
                                                              .inSeconds
                                                              .toDouble(),
                                                          initialValue: position
                                                              .inSeconds
                                                              .toDouble(),
                                                          onChange:
                                                              (value) async {
                                                            if (value
                                                                .isFinite) {
                                                              if (value.isNaN) {
                                                                value = 0.0;
                                                              }
                                                              await audioPlayer
                                                                  .seek(Duration(
                                                                      seconds: value
                                                                          .toInt()));
                                                            }
                                                          },
                                                          innerWidget:
                                                              (percentage) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(25),
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        image),
                                                              ),
                                                            );
                                                          },
                                                          appearance:
                                                              CircularSliderAppearance(
                                                            size: 330,
                                                            angleRange: 300,
                                                            startAngle: 300,
                                                            customColors:
                                                                CustomSliderColors(
                                                              progressBarColor:
                                                                  const Color
                                                                          .fromARGB(
                                                                      197,
                                                                      18,
                                                                      253,
                                                                      226),
                                                              dotColor: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  18,
                                                                  253,
                                                                  226),
                                                              trackColor: Colors
                                                                  .grey
                                                            ),
                                                            customWidths:
                                                                CustomSliderWidths(
                                                              trackWidth: 6,
                                                              handlerSize: 10,
                                                              progressBarWidth:
                                                                  6,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),

                                            const SizedBox(height: 20),
                                            //const SizedBox(height: 10),
                                            Text(
                                              title,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              artist,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              album!,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    if (isselfloop == false) {
                                                      audioPlayer.setLoopMode(
                                                          LoopMode.one);
                                                      setState(() {
                                                        isselfloop = true;
                                                      });
                                                    } else {
                                                      audioPlayer.setLoopMode(
                                                          LoopMode.all);
                                                      setState(() {
                                                        isselfloop = false;
                                                      });
                                                    }
                                                  },
                                                  icon: const Icon(Icons.repeat),
                                                  iconSize: 25,
                                                  color: isselfloop
                                                      ? const Color.fromARGB(
                                                          197, 18, 253, 226)
                                                      : Colors.white,
                                                ),
                                                IconButton(
                                                  onPressed: playPrevious,
                                                  icon: const Icon(
                                                      Icons.skip_previous),
                                                  iconSize: 40,
                                                  color: Colors.white,
                                                ),
                                                StreamBuilder<PlayerState>(
                                                  stream: audioPlayer
                                                      .playerStateStream,
                                                  builder: (context, snapshot) {
                                                    final playerState =
                                                        snapshot.data;
                                                    final processingState =
                                                        playerState
                                                            ?.processingState;
                                                    final playing =
                                                        playerState?.playing;
                                                    if (!(playing ?? false)) {
                                                      return CircleAvatar(
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                197,
                                                                18,
                                                                253,
                                                                226),
                                                        radius: 25,
                                                        child: IconButton(
                                                          onPressed: play,
                                                          icon: const Icon(
                                                            Icons.play_arrow,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      );
                                                    } else if (processingState !=
                                                        ProcessingState
                                                            .completed) {
                                                      return CircleAvatar(
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                197,
                                                                18,
                                                                253,
                                                                226),
                                                        radius: 25,
                                                        child: IconButton(
                                                          onPressed: pause,
                                                          icon: const Icon(
                                                              Icons.pause,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      );
                                                    }
                                                    return CircleAvatar(
                                                      radius: 25,
                                                      child: IconButton(
                                                        onPressed: play,
                                                        icon: const Icon(
                                                          Icons.play_arrow,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  onPressed: playNext,
                                                  icon: const Icon(
                                                      Icons.skip_next),
                                                  iconSize: 40,
                                                  color: Colors.white,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    if (isshuffle == false) {
                                                      setState(() {
                                                        isshuffle = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isshuffle = false;
                                                      });
                                                    }
                                                    audioPlayer
                                                        .setShuffleModeEnabled(
                                                            isshuffle);
                                                  },
                                                  icon:
                                                      const Icon(Icons.shuffle),
                                                  iconSize: 25,
                                                  color: isshuffle
                                                      ? const Color.fromARGB(
                                                          197, 18, 253, 226)
                                                      : Colors.white,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 13),
                                              child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [ 
                                                  Stack(
                                                        alignment: Alignment.center,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              downloadSong(
                                                                playlist[widget.currentindex].audio,
                                                                title,
                                                                context,
                                                              );
                                                            },
                                                            iconSize: 32,
                                                            color: Colors.white,
                                                            icon: const Icon(Icons.download_for_offline),
                                                          ),
                                                          if (isDownloading)
                                                            CircularProgressIndicator(
                                                              value: downloadProgress,
                                                              valueColor: const AlwaysStoppedAnimation<Color>(
                                                                 Color.fromARGB(197, 18, 253, 226),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                  IconButton(
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        backgroundColor: Colors
                                                            .transparent, // Set background color to transparent
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  BorderRadius.vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              30.0)),
                                                            ),
                                                            child:
                                                                CommentSection(
                                                                    audioId:
                                                                        audioid),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    iconSize: 32,
                                                    color: Colors.white,
                                                    icon: const Icon(
                                                        Icons.comment),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                    )),
                              ))));
                }
              });
        });
  }
}
