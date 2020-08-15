import 'dart:convert';

import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'screen/home.dart';
import 'screen/login.dart';
import 'screen/signup.dart';
import 'screen/splash.dart';
import 'utils/resource.dart';

//Main Function
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool isFirstLunch = true;
  Resource resource = new Resource();

  //Check if its the first time of lunching the app on the device
  _checkLunch() async {
    await resource.getFirstLunchStatus().then((first) async {
      if (!first) {
        setState(() {
          isFirstLunch = false;
        });
      }
    });
  }

  //Check user login
  _checkLogin() async {
    await resource.getUserToken().then((token) async {
      if (token != null) {
        await resource.getAllUserDetails().then((user) {
          if (user != null) {
            setState(() {
              var userLogged = json.decode(user);
              setCurrentUser(userLogged);
            });
          }
        });

        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }

  //get screen for login
  Widget _getScreenId() {
    if (isLoggedIn) {
      return HomeScreen();
    } else {
      return Login();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkLogin();
    super.initState();
  }

  // This widget is the root of the application.

  @override
  Widget build(BuildContext context) {
    final newTextTheme = Theme.of(context).textTheme.apply(
          bodyColor: Colors.pink,
          displayColor: Colors.pink,
        );

    return MaterialApp(
      title: 'Messenger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xff09031D),
          primaryColorDark: Colors.white,
          accentColor: Color(0xFFFEF9EB),
          backgroundColor: Colors.black,
          textTheme: new TextTheme(
            //body1: new TextStyle(color: Colors.red),
            display1: new TextStyle(color: Colors.black),
            display2: new TextStyle(color: Colors.white),
          ),
          primaryTextTheme:
              new TextTheme(title: TextStyle(color: Colors.white))),
      home: _getScreenId(),
      routes: {
        Login.id: (context) => Login(),
        SignUp.id: (context) => SignUp(),
        //HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
