import '../all_settings/settings_page.dart';
import '../global.dart';
import 'package:ui/audio/tracks.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';



class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  MusicPageState createState() => MusicPageState();
}

class MusicPageState extends State<MusicPage> {
  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
         appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color.fromARGB(255, 71, 68, 214),
          title: Container(
              
              margin: const EdgeInsets.only(top: 10),
              child: Center(
                child: Row(
                  children: const [
                     SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Music",
                              style: TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                                ],
                ),
              )
          ),
           actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context,rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => const SettingsPage()));
                },
                icon: const Icon(
                  Ionicons.settings_outline,
                  size: 29,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 10,
            ),
          ],
         ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15, left: 20),
                child: const Text(
                  "Your favorite artists",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Container(
                height: 150,
                // color: Colors.black,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: podcast.length,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () {
                        // do something when the button is tapped
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        margin:
                            const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AudioTrackListPage()),
                            );
                            // do something when the button is pressed
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              image: DecorationImage(
                                image: AssetImage("${podcast[i]['img']}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
    
            
    
              ,
              Container(
                margin: const EdgeInsets.only(top: 15, left: 20),
                child: const Text(
                  "Made for you",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AudioTrackListPage()),
                      );
                      // add your button action here
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 180,
                          width: wid,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            image: DecorationImage(
                              image: AssetImage("images/eminem.jpeg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          margin: const EdgeInsets.only(
                              left: 20, top: 30, bottom: 15),
                        ),
                        Container(
                            // color: Colors.red,
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 24),
                            child: const Text(
                                "this is new album from skils and weget ,rbabla "))
                      ],
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AudioTrackListPage()),
                      );
                      // add your button action here
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 180,
                          width: wid,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            image: DecorationImage(
                              image: AssetImage("images/billie.jpeg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          margin: const EdgeInsets.only(
                              right: 10, top: 30, bottom: 15),
                        ),
                        Container(
                            // color: Colors.red,
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 18, left: 4),
                            child: const Text(
                                "this is new album from skils and weget ,rbabla "))
                      ],
                    ),
                  ))
                ],
              ),
              Row(children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AudioTrackListPage()),
                    );
                    // add your button action here
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 180,
                        width: wid,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            image: AssetImage("images/sixnine.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        margin:
                            const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                      ),
                      Container(
                          // color: Colors.red,
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 18, left: 24),
                          child: const Text(
                              "this is new album from skils and weget ,rbabla ")),
                      const SizedBox(
                        height: 300,
                      )
                    ],
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AudioTrackListPage()),
                    );
                    // add your button action here
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 180,
                        width: wid,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            image: AssetImage("images/billie.jpeg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        margin:
                            const EdgeInsets.only(right: 10, top: 30, bottom: 15),
                      ),
                      Container(
                          // color: Colors.red,
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 18, left: 4),
                          child: const Text(
                              "this is new album from skils and weget ,rbabla ")),
                      const SizedBox(
                        height: 300,
                      )
                    ],
                  ),
                ))
              ])
            ],
          ),
        ),
      ),
    );
  }
}
