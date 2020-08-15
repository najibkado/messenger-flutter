import 'dart:convert';
import 'package:najibkado/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resource {
  SharedPreferences localStorage;

//setting user details
  Future<void> setUserDetails({String token, String user}) async {
    localStorage = await SharedPreferences.getInstance();
    if (token != null) localStorage.setString('token', token);
    if (user != null) localStorage.setString('user', user);
    if (user != null) currentUser = User.fromJson(json.decode(user));
  }

//set splash page
  Future<void> setSplash(bool op) async {
    localStorage = await SharedPreferences.getInstance();
    localStorage.setBool('splash', true);
  }

//check if its users first lunch
  Future<bool> getFirstLunchStatus() async {
    localStorage = await SharedPreferences.getInstance();
    return localStorage.getBool('splash');
  }

//get user access token
  Future<String> getUserToken() async {
    localStorage = await SharedPreferences.getInstance();
    return localStorage.getString('token');
  }

//get all users details
  Future<String> getAllUserDetails() async {
    localStorage = await SharedPreferences.getInstance();
    return localStorage.getString('user');
  }

//get user picture
  Future<bool> hasProfilePix() async {
    localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));
    String pix =
        user['profile']['image'] == null ? null : user['profile']['image'];
    if (pix == null)
      return false;
    else
      return true;
  }

//get user detail
  Future<String> getUserDetail(String id) async {
    localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));
    return user[id];
  }

//get user profile
  Future<String> getUserProfileDetail(String id) async {
    localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));
    return user['profile'][id];
  }
}
