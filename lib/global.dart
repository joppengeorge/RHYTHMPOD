import 'package:just_audio_background/just_audio_background.dart';

import 'package:just_audio/just_audio.dart';



late MediaItem selectedMediaItem;

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


List<MediaItem> mediaItems = [
  MediaItem(
    id: '0',
    title: 'Rockstar',
    artist: 'Post Malone',
    artUri: Uri.parse('https://m.media-amazon.com/images/M/MV5BNjU0MzgzZmEtYzE2ZC00NWY3LWJlYzYtZWUwNTA2MWRkYWM3XkEyXkFqcGdeQXVyNjU1OTg4OTM@._V1_.jpg'),
   
  ),
  MediaItem(
    id: '1',
    title: 'Mockingbird',
    artist: 'Eminem',
    artUri: Uri.parse('https://i.scdn.co/image/ab67616d0000b273726d48d93d02e1271774f023'),
   
  ),
  MediaItem(
    id: '2',
    title: 'Aadharanjali',
    artist: 'Sushin Shyam',
    artUri: Uri.parse('https://img.onmanorama.com/content/dam/mm/en/entertainment/movie-reviews/images/2023/2/4/romancham-review.jpg'),
   
  ),
];

final playlist = ConcatenatingAudioSource(
  children: [
    AudioSource.uri(
      Uri.parse('asset:///assets/audio/Post_Malone_Ft_21_Savage_-_Rockstar.mp3'),
      tag: mediaItems[0],
    ),
    AudioSource.uri(
      Uri.parse('asset:///assets/audio/Mockingbird.mp3'),
      tag: mediaItems[1],
    ),
    AudioSource.uri(
      Uri.parse('asset:///assets/audio/Aadharanjali.mp3'),
      tag: mediaItems[2],
    ),
  ],
);