
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

List podcast = [
  {
    "title" : "podcast chart",
    "img" : "images/eminem.jpeg",
  },
  {
    "title" : "New's & Politic",
    "img" : "images/billie.jpeg",
  },
  {
    "title" : "Raps",
    "img" : "images/sixnine.jpg",
  },
  {
    "title" : "Raps & hip hop",
    "img" : "images/drake.jpg",
  },
];


class Music{
  String image;
  String title;
  String artist;
  String audio;
  bool isfavourite;
  Music(this.image,this.title,this.artist,this.audio,this.isfavourite);
}

class MusicOperation{
  MusicOperation._() {}
  static List<Music> getmusic(){
    return <Music>[
      Music('https://m.media-amazon.com/images/M/MV5BNjU0MzgzZmEtYzE2ZC00NWY3LWJlYzYtZWUwNTA2MWRkYWM3XkEyXkFqcGdeQXVyNjU1OTg4OTM@._V1_.jpg',
            'Rockstar',
            'Post Malone', 
            'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/10/c1/3d/10c13d42-fd93-9b85-2576-dcdf3d65ef76/mzaf_1879447237147750935.plus.aac.p.m4a',
            false),
    Music(
     'https://i.scdn.co/image/ab67616d0000b273726d48d93d02e1271774f023',
     'Mockingbird',
     'Eminem',
     'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/50/e9/d7/50e9d798-3a42-f722-3844-95f3751891e9/mzaf_88495725395079396.plus.aac.p.m4a',
     false
      ),
  Music(
     'https://img.onmanorama.com/content/dam/mm/en/entertainment/movie-reviews/images/2023/2/4/romancham-review.jpg',
     'Aadharanjali',
     'Sushin Shyam',
     'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/7d/a2/84/7da284cf-cc03-2a81-e59a-91bc6f8adca2/mzaf_13249433832550769689.plus.aac.p.m4a',
     false
  ),

    ];
  }
  
}
List<Music> fav = [];




 // int _nextMediaId = 0;


/*final playlist = ConcatenatingAudioSource(children: [
    ClippingAudioSource(
      start: const Duration(seconds: 60),
      end: const Duration(seconds: 90),
      child: AudioSource.uri(
        Uri.parse(
          'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/10/c1/3d/10c13d42-fd93-9b85-2576-dcdf3d65ef76/mzaf_1879447237147750935.plus.aac.p.m4a')),
      tag: MediaItem(
        id: '${_nextMediaId++}',
        artist: 'Post Malone',
        title: 'Rockstar',
        artUri: Uri.parse(
            'https://m.media-amazon.com/images/M/MV5BNjU0MzgzZmEtYzE2ZC00NWY3LWJlYzYtZWUwNTA2MWRkYWM3XkEyXkFqcGdeQXVyNjU1OTg4OTM@._V1_.jpg'),
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/50/e9/d7/50e9d798-3a42-f722-3844-95f3751891e9/mzaf_88495725395079396.plus.aac.p.m4a'),
      tag: MediaItem(
        id: '${_nextMediaId++}',
        artist: 'Eminem',
        title: 'MockingBird',
        artUri: Uri.parse(
            'https://i.scdn.co/image/ab67616d0000b273726d48d93d02e1271774f023'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/7d/a2/84/7da284cf-cc03-2a81-e59a-91bc6f8adca2/mzaf_13249433832550769689.plus.aac.p.m4a'),
      tag: MediaItem(
        id: '${_nextMediaId++}',
        artist: 'Sushin Shyam',
        title: 'Aadharanjali',
        artUri: Uri.parse(
            'https://img.onmanorama.com/content/dam/mm/en/entertainment/movie-reviews/images/2023/2/4/romancham-review.jpg'),
      ),
    ),
    
  ]);*/

 