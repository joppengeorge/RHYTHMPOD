import 'package:flutter/material.dart';
import 'package:ui/home_page.dart';
import 'package:ui/global.dart';

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

      body: ListView.builder(
        itemCount: musicList.length,
        itemBuilder: (BuildContext context, int index) {
          Music? a=musicList[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(a.image),),
            title: Text(a.title),
            subtitle: Text(a.artist),
            onTap: () {
                setState(() {
                  currentmusic.value=a;
                  isPlaying=false;
                });
                
            },
          );
        },
      ),
    );
  }
}
