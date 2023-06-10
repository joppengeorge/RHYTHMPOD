List musicartist = [
  {
    "title" : "podcast chart",
    "img" : "images/eminem.jpeg",
    "name" : 'Eminem'
  },
  {
    "title" : "New's & Politic",
    "img" : "images/postmalone.jpeg",
    "name" : 'POST MALONE'
  },
  {
    "title" : "Raps",
    "img" : "images/sushin.jpeg",
    "name" : 'Sushin Shyam'
  },
  {
    "title" : "Raps & hip hop",
    "img" : "images/arijith.jpg",
    "name" : 'Arijith Singh'
  },
];

List podcastartist = [
  {
    "img" : "images/joe rogan.jpg",
    "name" : 'Joe Rogan Experience'
  },
  {
    "img" : "images/lex freedman.png",
    "name" : 'Lex Freedman'
  },
  {
    "img" : "images/marques brownlee.jpg",
    "name" : 'WVFRM podcast'
  },
  {
    "img" : "images/rizwan ramzan.jpg",
    "name" : 'The mallu podcast'
  },
  {
    "img" : "images/the athletic football.jpg",
    "name" : 'Athletic Football Podcast'
  },
];

class Music{
  String id;
  String image;
  String title;
  String album;
  String artist;
  String audio;
  String type;
  Music(this.id,this.image,this.title,this.album,this.artist,this.audio,this.type);
}


List<Music> favList=[];

//bool heartvis=true;


List<Music> fav = [];


bool favpage =false;


 