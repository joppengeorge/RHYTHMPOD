import 'package:flutter/material.dart';
//import 'package:audioplayers/audioplayers.dart';
import '../home_page.dart';

class AudioPlayerScreen extends StatefulWidget {

  final int currentindex;
  final VoidCallback play;
  final VoidCallback pause;
  final VoidCallback previous;
  final VoidCallback next;
  const AudioPlayerScreen({Key? key,
                                    required this.currentindex,
                                    required this.pause,
                                    required this.play,
                                    required this.previous,
                                    required this.next,
                                    }) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {

  Duration _duration = const Duration();
  Duration _position = const Duration();

  final ScrollController _scrollController = ScrollController();

  double _miniplayerPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);

    
   MiniplayerWidgetState.audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    MiniplayerWidgetState.audioPlayer.onAudioPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });

  }


  @override
  void dispose() {
    _scrollController.dispose();
    MiniplayerWidgetState.audioPlayer.stop();
    MiniplayerWidgetState.audioPlayer.dispose();
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
                              image: NetworkImage(playlist[widget.currentindex].image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          playlist[widget.currentindex].title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          playlist[widget.currentindex].artist,
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
                        Controls(
                            pause: widget.pause,
                            play: widget.play,
                            previous:widget.previous,
                            next:widget.next),

            ]
            ),
                   ),
         )
        )
      )
      );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    Key? key,
    required this.pause,
    required this.play,
    required this.previous,
    required this.next
  }) : super(key: key);


  final VoidCallback pause;
  final VoidCallback play;
  final VoidCallback previous;
  final VoidCallback next;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            IconButton(
                      onPressed: previous,
                      icon: const Icon(Icons.skip_previous),
                      iconSize: 40,
                      color: Colors.white,),
            CircleAvatar(
              radius: 25,
              child: IconButton(
                              onPressed:()
                              {
                                if(isPlaying)
                                {
                                  pause();
                                }
                                else{
                                  play();
                                }
                              },
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                            ),
            ),
            IconButton(
                      onPressed: next,
                      icon: const Icon(Icons.skip_next),
                      iconSize: 40,
                      color: Colors.white,),
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
