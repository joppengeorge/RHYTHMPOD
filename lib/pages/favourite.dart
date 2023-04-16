import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Center(
    child: ElevatedButton(
  onPressed: () {
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
    "No Favorite Yet !!",
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
)

    );
  }
}
