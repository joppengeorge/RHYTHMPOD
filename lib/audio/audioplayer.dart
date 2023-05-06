import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';// as audioplayers;
//import 'package:just_audio/just_audio.dart';
//import 'package:rxdart/rxdart.dart';
//import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:just_audio_background/just_audio_background.dart';
import 'package:ui/global.dart';

import '../home_page.dart';

/*class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}*/

class AudioPlayerScreen extends StatefulWidget {

  final AudioPlayer audioPlayer;
  final Music currentmusic;
  
  final Function play;
  final Function pause;
  const AudioPlayerScreen({Key? key,required this.audioPlayer,
                                    required this.currentmusic,
                                   // required this.isPlaying,
                                    required this.pause,
                                    required this.play}) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {

  Duration _duration = const Duration();
  Duration _position = const Duration();

  final ScrollController _scrollController = ScrollController();

  double _miniplayerPosition = 0;


  /*Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        widget.audioPlayer.positionStream,
        widget.audioPlayer.bufferedPositionStream,
        widget.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );*/

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    widget.audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    widget.audioPlayer.onAudioPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });

    widget.audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = const Duration();
        isPlaying=false;
        
      });
    });
  }



  void _playPause() async {
    if (isPlaying) {
      widget.pause;
      setState(() {
        isPlaying = false;
      });
    } else 
    {
      widget.play;
      setState(() {
      isPlaying = true;
      });
    }
  }



  @override
  void dispose() {
    _scrollController.dispose();
    widget.audioPlayer.stop();
    widget.audioPlayer.dispose();
    super.dispose();
  }



  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
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
              leading:  const Icon(Icons.arrow_drop_down_sharp),
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
                  colors: [Color(0xFF144771), Color(0xFF071A2C)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                      const SizedBox(height: 20),
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(widget.currentmusic.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: InkWell(
                            onTap: _playPause,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Stack(
                                children: [
                                  CircularProgressIndicator(
                                    value: 1.0,
                                    strokeWidth: 3,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                  ),
                                  CircularProgressIndicator(
                                    value: _position.inMilliseconds.toDouble() / _duration.inMilliseconds.toDouble(),
                                    strokeWidth: 3,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.currentmusic.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.currentmusic.artist,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(formatDuration(_position)),
                            const SizedBox(width: 10),
                            const Text("|"),
                            const SizedBox(width: 10),
                            Text(formatDuration(_duration)),
                          ],
                        ),
                        const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},                    
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 71, 68, 214)),
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
               /* children: [
                  
                       MediaMetadata(
                        imageUrl: widget.currentmusic.image,
                        artist: widget.currentmusic.artist,
                        title: widget.currentmusic.title,
                      ),
                      Slider(
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble(), 
                        onChanged: (value)
                        {
                          final position=Duration(seconds: value.toInt());
                          widget.audioPlayer.seek(position);
                          widget.audioPlayer.resume();
                        }
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatTime(position.inSeconds)),
                              Text(formatTime((duration-position).inSeconds)),
                            ],
                          ),
                        ),
                   
                 /* StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return ProgressBar(
                        barHeight: 7,
                        baseBarColor: Colors.grey[600],
                        bufferedBarColor: Colors.grey,
                        progressBarColor: const Color.fromARGB(255, 71, 68, 214),
                        thumbColor: const Color.fromARGB(255, 71, 68, 214),
                        timeLabelTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        progress: positionData?.position ?? Duration.zero,
                        buffered: positionData?.bufferedPosition ?? Duration.zero,
                        total: positionData?.duration ?? Duration.zero,
                        onSeek: widget.audioPlayer.seek,
                      );
                    },
                  ),*/
                  Controls(audioPlayer: widget.audioPlayer,
                            isPlaying:widget.isPlaying,
                            pause: widget.pause,
                            play: widget.play,),
                ],
              ),*/
            ]
            ),
                   ),
         )
        )
      )
      );
  }
}

class MediaMetadata extends StatelessWidget {
  const MediaMetadata({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
  });

  final String imageUrl;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 4),
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          artist,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
        
      ],
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    Key? key,
    required this.audioPlayer,
    required this.isPlaying,
    required this.pause,
    required this.play
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final bool isPlaying;
  final Function pause;
  final Function play;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              child: IconButton(
                              onPressed:()
                              {
                                if(isPlaying)
                                {
                                  pause;
                                }
                                else{
                                  play;
                                }
                              },
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                            ),
            ),
            /*IconButton(
              onPressed: audioPlayer.seekToPrevious,
              iconSize: 50,
              color: Colors.white,
              icon: const Icon(Icons.skip_previous_rounded),
            ),
             const SizedBox(width: 10),
            StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (!(playing ?? false)) {
                  return IconButton(
                    onPressed: audioPlayer.play,
                    iconSize: 60,
                    color: Colors.white,
                    icon: const Icon(Icons.play_arrow_rounded),
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    onPressed: audioPlayer.pause,
                    iconSize: 60,
                    color: Colors.white,
                    icon: const Icon(Icons.pause_rounded),
                  );
                }
                return const Icon(Icons.play_arrow_rounded,
                    size: 60, color: Colors.white);
              },
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: audioPlayer.seekToNext,
              iconSize: 50,
              color: Colors.white,
              icon: const Icon(Icons.skip_next_rounded),
            ),*/
          ],
        ),
        
         const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},                    
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 71, 68, 214)),
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
      ],
    );
  }
}
