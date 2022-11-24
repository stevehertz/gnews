import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gnews/bloc/bottom_navbar_bloc.dart';
import 'package:gnews/screens/tabs/home_screen.dart';
import 'package:gnews/screens/tabs/search_screen.dart';
import 'package:gnews/screens/tabs/source_screen.dart';
import 'package:gnews/style/theme.dart' as Style;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  BottomNavBarBloc? _bottomNavBarBloc;

  @override
  void initState() {
    getConnectivity();
    _bottomNavBarBloc = BottomNavBarBloc();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Style.Colors.mainColor,
          title: const Text(
            "Global News",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: loadNews(),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc?.itemStream,
        initialData: _bottomNavBarBloc?.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFF5F5F5),
                  spreadRadius: 0,
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                iconSize: 20.0,
                unselectedItemColor: Style.Colors.grey,
                unselectedFontSize: 9.5,
                selectedFontSize: 9.5,
                type: BottomNavigationBarType.fixed,
                fixedColor: Style.Colors.mainColor,
                currentIndex: snapshot.data!.index,
                onTap: _bottomNavBarBloc?.pickItem,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(EvaIcons.homeOutline),
                    activeIcon: Icon(EvaIcons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(EvaIcons.gridOutline),
                    activeIcon: Icon(EvaIcons.grid),
                    label: 'Sources',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(EvaIcons.searchOutline),
                    activeIcon: Icon(EvaIcons.search),
                    label: 'Search',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  loadNews() {
    return SafeArea(
      child: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc?.itemStream,
        initialData: _bottomNavBarBloc?.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.HOME:
              return HomeScreen();
            case NavBarItem.SOURCES:
              return SourceScreen();
            case NavBarItem.SEARCH:
              return SearchScreen();
            default:
              return testScreen();
          }
        },
      ),
    );
  }

  noConnection() {
    return SafeArea(
      child: Center(
        child: Text("No Connection"),
      ),
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text("No connection"),
          content: const Text("Please check your internet connectivity"),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'cancel');
                  setState(() {
                    isAlertSet = false;
                  });
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected) {
                    showDialogBox();
                    setState(() {
                      isAlertSet = true;
                    });
                  }
                },
                child: const Text("OK"))
          ],
        ),
      );

  Widget testScreen() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          Text("Test Screen"),
        ],
      ),
    );
  }
}
