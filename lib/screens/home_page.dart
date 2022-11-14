import 'package:flutter/material.dart';
import 'package:gnews/style/theme.dart' as Style;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Style.Colors.mainColor,
            title: Text(
              "News App",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder<NavBarItem>(),
        ),
      ),
    );
  }
}
