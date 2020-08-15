import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:najibkado/api/api.dart';

import 'constant.dart';
import 'resource.dart';

class Utils {
  Resource resource = new Resource();
  String token;

//Sending get request
  makeHttpgetRequest(url) async {
    await resource.getUserToken().then((tokn) => token = tokn);
    try {
      var res = await CallApi().getDataCurrentUser(url, token);
      var body = json.decode(res.body);
      if (res.statusCode == 200) {
        return body;
      } else if (res.statusCode == 401) {
        var errorMsg = "";
        json.encode(body['error']) != null
            ? errorMsg = json.encode(body['error'])
            : errorMsg = json.encode(body['message']);
        //Utils().showTostError(errorMsg);
      } else {
        Utils().showTostError('Unknown error occure please try again later');
      }
    } catch (e) {
      if (e is TimeoutException) {
        //Timed out
        Utils().showTostError("Error in Network Connection");
      }
    }
  }

  // sending get request
  makeHttpDeleteRequest(url) async {
    await resource.getUserToken().then((tokn) => token = tokn);
    try {
      var res = await CallApi().deleteDataCurrentUser(url, token);
      var body = json.decode(res.body);
      if (res.statusCode == 200) {
        return true;
      } else if (res.statusCode == 401) {
        Utils().showTostError(json.encode(body['error']));
      } else {
        Utils().showTostError("Unknown error occure please try again later");
      }
    } catch (e) {
      if (e is TimeoutException) {
        Utils().showTostError("Error in Network Connection");
      }
    }
    return false;
  }

//sending follow request
  submitFollowerUser(id) async {
    try {
      await resource.getUserToken().then((tokn) => token = tokn);
      var res = await CallApi().getDataCurrentUser('follow/${id}', token);
      var body = json.decode(res.body);
      if (res.statusCode == 200) {
      } else if (res.statusCode == 401) {
        Utils().showTostError(json.encode(body['error']));
      } else {
        Utils().showTostError("Unknown error occure please try again later");
      }
    } catch (e) {
      if (e is TimeoutException) {
        //Timed out
        Utils().showTostError("Error in Network Connection");
      }
    }
  }

// sending block request
  submitBlockedUser(id) async {
    try {
      await resource.getUserToken().then((tokn) => token = tokn);
      var res = await CallApi().getDataCurrentUser('block/${id}', token);
      var body = json.decode(res.body);
      if (res.statusCode == 200) {
      } else if (res.statusCode == 401) {
        Utils().showTostError(json.encode(body['error']));
      } else {
        Utils().showTostError("Unknown error occure please try again later");
      }
    } catch (e) {
      if (e is TimeoutException) {
        //Timed out
        Utils().showTostError("Error in Network Connection");
      }
    }
  }

// get no data message
  Widget getNoDataWidget(asyncLoaderState, message, {color}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 60.0,
            child: new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(noEmojiImage),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          new Text(message,
              style: TextStyle(
                  color: color == null ? Colors.black : Colors.white)),
          new FlatButton(
              color: Colors.green,
              child: new Text(
                "Refresh",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => asyncLoaderState.currentState.reloadState())
        ],
      ),
    );
  }

  // get no connection message
  Widget getNoConnectionWidget(asyncLoaderState, {color}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 60.0,
          child: new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage(noNetworkImage),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        new Text("No Internet Connection",
            style:
                TextStyle(color: color == null ? Colors.black : Colors.white)),
        new FlatButton(
            color: Colors.red,
            child: new Text(
              "Retry",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => asyncLoaderState.currentState.reloadState())
      ],
    );
  }

// get toast error message
  showTostError(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

// get toast success message
  showTostSuccess(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

//text field decoration
  inputTextDeco() {
    return BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 1.0)
        ]);
  }

/*showMessage(BuildContext context, msg){
  final snackBar = SnackBar(
    content: Text(msg),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () => {},
    )
  ),

  Scaffold.of(context).showSnackBar(snackBar);
}*/

}
