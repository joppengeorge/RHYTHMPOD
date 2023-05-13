import 'package:flutter/material.dart';
//import 'package:just_audio_background/just_audio_background.dart';
import 'package:ui/home_page.dart';
import 'package:ui/global.dart';
//import 'package:just_audio/just_audio.dart';

class AudioTrackListPage extends StatefulWidget {

  const AudioTrackListPage({Key? key}) : super(key: key);
  @override
  State<AudioTrackListPage> createState() => AudioTrackListPageState();
}

class AudioTrackListPageState extends State<AudioTrackListPage> {

  @override
  Widget build(BuildContext context) {
    List<Music> musicList = MusicOperation.getmusic();

    return Scaffold(
        appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('Audio Tracks'),
        backgroundColor: const Color.fromARGB(255, 71, 68, 214),
      ),

      body:
      ListView.builder(
        itemCount: musicList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(musicList[index].image),),
            title: Text(musicList[index].title),
            subtitle: Text(musicList[index].artist),
            onTap: () {
                setState(() {
                  playlist=MusicOperation.getmusic();
                  currentindex.value=index;
                  //isPlaying=false;
                  MiniplayerWidgetState.audioPlayer.seek(Duration.zero,index: index);
                });
                
            },
          );
        },
      ),
    );
  }
}
