import 'package:ionicons/ionicons.dart';
import 'package:ui/audio/tracks.dart';
import '../all_settings/settings_page.dart';
import '../global.dart';
import 'package:flutter/material.dart';

class Podcast extends StatefulWidget {
  const Podcast({Key? key}) : super(key: key);

  @override
  PodcastState createState() => PodcastState();
}

class PodcastState extends State<Podcast> {

  @override
  Widget build(BuildContext context) {
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
                              "Podcast",
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
        
        body: Column(
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
                    margin: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AudioTrackListPage(keyword: null,)),
                            );
                        // do something when the button is pressed
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage("${podcast[i]['img']}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
                              
               })),
    
    
                          
    
    
               
            Container(
              margin: const EdgeInsets.only(top: 15, left: 20),
              child: const Text(
                "All categories",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Row(
              children: [
                Expanded(
    
    
                child:  InkWell(
                        onTap: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AudioTrackListPage(keyword: null,)),
                            );
                          // add your button action here
                        },
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            image: DecorationImage(
                              image: AssetImage(podcast[0]['img']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          margin: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                          child: Text(
                            podcast[0]['title'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ),
                      )
    
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded( 
                child:  InkWell(
                        onTap: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AudioTrackListPage(keyword: null,)),
                            );
                          // add your button action here
                        },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage(podcast[1]['img']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin: const EdgeInsets.only(right: 10, top: 30, bottom: 15),
                    child: Text(
                      podcast[1]['title'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                )
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child:  InkWell(
                        onTap: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AudioTrackListPage(keyword: null,)),
                            );
                          // add your button action here
                        },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage(podcast[2]['img']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                    child: Text(
                      podcast[2]['title'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                )
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child:  InkWell(
                        onTap: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AudioTrackListPage(keyword: null,)),
                            );
                          // add your button action here
                        },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage(podcast[3]['img']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin: const EdgeInsets.only(right: 10, top: 30, bottom: 15),
                    child: Text(
                      podcast[3]['title'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                )
                )
              ],
            ),
           
            Center(
              child: ElevatedButton(
                    onPressed: () {
                       Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AudioTrackListPage(keyword: null,)),
                          );
                      // Add your onPressed event here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB6AFAF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    child: const Text(
                      "View More",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
