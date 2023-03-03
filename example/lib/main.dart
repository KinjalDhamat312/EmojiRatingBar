import 'package:emoji_rating_bar/emoji_rating_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text('Plugin example app'),
        ),
        body: Center(
          // color: Colors.purple,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("How was the our service?"),
                const SizedBox(
                  height: 30,
                ),
                const EmojiRatingBar(
                  rating: 3,
                ),
                const SizedBox(
                  height: 80,
                ),
                const Text("How are you feeling?"),
                const SizedBox(
                  height: 30,
                ),
                const EmojiRatingBar(
                  ratingBarType: RatingBarType.mood,
                  rating: 3,
                ),
                const SizedBox(
                  height: 80,
                ),
                const Text("Customise your rating bar"),
                const SizedBox(
                  height: 30,
                ),
                EmojiRatingBar(
                  rating: 2,
                  isShowTitle: false,
                  applyColorFilter: false,
                  onRateChange: (rating) {
                    debugPrint("Current rating $rating");
                  },
                  list: [
                    EmojiData(icStrong, "Strong", isPackageImg: true),
                    EmojiData(
                      "assets/ic_delighted.png",
                      "Delighted",
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
