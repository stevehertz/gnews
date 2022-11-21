import 'package:flutter/material.dart';
import 'package:gnews/widgets/headline_slider.dart';
import 'package:gnews/widgets/hot_news.dart';
import 'package:gnews/widgets/top_channels.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HeadlineSliderWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Top channels",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ),
        TopChannels(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Hot News",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ),
        HotNews(),
      ],
    );
  }
}
