import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noteapp/homepage.dart';
import 'package:noteapp/remainder.dart';
import 'package:noteapp/thirumalai.dart';
import 'package:noteapp/userpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart' as Theme;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteApp',
      color: Colors.white,
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/RegisterPage': (BuildContext context) => new UserPage(),
        '/HomePage': (BuildContext context) =>
            new HomePage(), //Redirect to homepage
      },
    );
  }
}

//creation of Splashscreen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
//Initialize startTime() for predict duration limit.
  startTime() async {
    SharedPreferences prefsnote = await SharedPreferences.getInstance();
// prefs.clear();
    bool firstTime = prefsnote.getBool('first_time');
    print("firstTime" + firstTime.toString());

    var _duration = new Duration(seconds: 2);
    if (firstTime != null && !firstTime) {
      // Not first time
      return new Timer(_duration, navigationPageHome);
    } else {
      // First time

      return new Timer(_duration, navigationPageWel);
    }
  }

  void navigationPageHome() {
    //  toast(context, "You are already Registered!!");
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  void navigationPageWel() {
    //  toast(context, "User enter into registration page");
    Navigator.of(context).pushReplacementNamed('/RegisterPage');
  }

  @override
  void initState() {
    super.initState();

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    //Find current device size
    Size screenSize = MediaQuery.of(context).size;
    double wt = screenSize.width; //width

    var ts = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,

        //  fontSize: wt/13,

        letterSpacing: 2);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.red[800],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('MyNotes', style: ts.copyWith(fontSize: wt / 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
