import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:ui/home_page.dart';
import 'package:ui/global.dart';



class AudioTrackListPage extends StatefulWidget {
  const AudioTrackListPage({super.key});

  @override
  State<AudioTrackListPage> createState() => AudioTrackListPageState();
}

class AudioTrackListPageState extends State<AudioTrackListPage> {
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('Audio Tracks'),
        backgroundColor: const Color.fromARGB(255, 71, 68, 214)
      ),
      body: 
      ListView.builder(
          itemCount:  mediaItems.length,
          itemBuilder: (BuildContext context, int index) {
            final mediaItem = mediaItems[index];
            return ListTile(
              leading: CircleAvatar(radius: 30,backgroundImage: NetworkImage(mediaItem.artUri.toString())),
              title: Text(mediaItem.title),
              subtitle: Text(mediaItem.artist ?? ''),
              onTap: () {
                setState(() {
                    selectedMediaItem = mediaItem;
                  });
                  showMiniplayer.value = true;
              },
            );
          },
        )

    );
  }
}



 
          
          