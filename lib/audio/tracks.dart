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


/*class AudioTrackDetailsPage extends StatelessWidget {
  final AudioTrack track;

  AudioTrackDetailsPage({required this.track});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(track.title),
         backgroundColor: Color.fromARGB(255, 71, 68, 214)
      ),
      body: Center(
        child: Text('Details for ${track.title}'),
      ),
    );
  }
}
*/



/*class AudioTrackDetailsPage extends StatelessWidget {
  final String trackName;
  final String imageUrl;

  AudioTrackDetailsPage({required this.trackName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                trackName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '00:00',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    '00:00',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_previous),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.loop),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

