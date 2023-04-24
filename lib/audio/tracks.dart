import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:ui/home_page.dart';
import 'audioplayer.dart';
import 'package:ui/global.dart';

class AudioTrackListPage extends StatefulWidget {
  @override
  State<AudioTrackListPage> createState() => _AudioTrackListPageState();
}

class _AudioTrackListPageState extends State<AudioTrackListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('Audio Tracks'),
        backgroundColor: const Color.fromARGB(255, 71, 68, 214)
      ),
      body: ListView.builder(
          itemCount:  mediaItems.length,
          itemBuilder: (BuildContext context, int index) {
            MediaItem mediaItem = mediaItems[index];
            return ListTile(
              leading: CircleAvatar(radius: 30,backgroundImage: NetworkImage(mediaItem.artUri.toString())),
              title: Text(mediaItem.title),
              subtitle: Text(mediaItem.artist ?? ''),
              onTap: () {
                currentlyPlaying.value=true;
                // do something when the tile is tapped
              },
            );
          },
        )

    );
  }
}

