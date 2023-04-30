import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio_background/just_audio_background.dart';

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class AudioPlayerScreen extends StatefulWidget {

  final AudioPlayer audioPlayer;
  const AudioPlayerScreen({Key? key,required this.audioPlayer}) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {


  

  final ScrollController _scrollController = ScrollController();
  double _miniplayerPosition = 0;

  

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        widget.audioPlayer.positionStream,
        widget.audioPlayer.bufferedPositionStream,
        widget.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);

  }



  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              leading: IconButton(
                  onPressed: () {
                  
                  },
                  icon: const Icon(Icons.swipe_down)),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                )
              ],
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
                children: [
                  StreamBuilder<SequenceState?>(
                    stream: widget.audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        return const SizedBox();
                      }
                      final metaData = state!.currentSource!.tag as MediaItem;
                      return MediaMetadata(
                        imageUrl: metaData.artUri.toString(),
                        artist: metaData.artist ?? '',
                        title: metaData.title,
                      );
                    },
                  ),
                  StreamBuilder<PositionData>(
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
                  ),
                  Controls(audioPlayer: widget.audioPlayer),
                ],
              ),
            ),
                   ),
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
  }) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
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
