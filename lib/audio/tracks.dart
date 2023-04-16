import 'package:flutter/material.dart';
import 'audioplayer.dart';

class AudioTrackListPage extends StatelessWidget {
  final List<AudioTrack> tracks = [
    AudioTrack(title: 'Episode 1', duration: '30:00'),
    AudioTrack(title: 'Episode 2', duration: '25:30'),
    AudioTrack(title: 'Episode 3', duration: '28:45'),
    AudioTrack(title: 'Episode 4', duration: '34:20'),
    AudioTrack(title: 'Episode 5', duration: '31:10'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Tracks'),
        backgroundColor: Color.fromARGB(255, 71, 68, 214)
      ),
      body: ListView.builder(
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(backgroundColor: Colors.black),
            title: Text(tracks[index].title),
            subtitle: Text(tracks[index].duration),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioPlayerScreen()),
                );
              
            },
          );
           const Divider();
        },
      ),
    );
  }
}

class AudioTrack {
  final String title;
  final String duration;

  AudioTrack({
    required this.title,
    required this.duration,
  });
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

