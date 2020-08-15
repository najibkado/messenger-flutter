import 'package:flutter/material.dart';
import 'package:najibkado/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String appUrl = 'http://10.0.2.2:8000/';
const APP_ID = '47924ce7d34d4658bdf7f9c7f0a6395c';
final String appImageUrl = appUrl + 'storage/';
final String appApiUrl = appUrl + 'api/';
final String noImage = 'assets/images/no-profile.png';
final String noNetworkImage = 'assets/images/no_wifi.png';
final String noEmojiImage = 'assets/images/emoji.png';
final List fonts = [
  'seven',
  'one',
  'four',
  'five',
  'six',
];

//Colors
final List colors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.blueGrey,
  Colors.lime,
  Colors.orange,
  Colors.pink,
  Colors.yellow,
  Colors.black,
  Colors.purple,
  Colors.redAccent,
  Color(0xff6D0EB5),
  Color(0xff4059F1),
];
Color deepOrange = Colors.deepOrange;
Color black = Colors.black;
Color white = Colors.white;
Color grey = Colors.grey;

//Actionbar texts
const String profileActionBarText = "Profile";
const String settingActionBarText = "Settings";
const String signoutActionBarText = "Signout";

final List actionMenu = [
  profileActionBarText,
  settingActionBarText,
  signoutActionBarText
];

//get user access token
getUserToken() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  return localStorage.getString('token');
}

//set user access token
setUserToken(token) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.setString('token', token);
}

//logs out user
logout(BuildContext context) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.remove('token');
  localStorage.remove('user');
  Navigator.pushReplacement(
      context, new MaterialPageRoute(builder: (context) => Login()));
}
