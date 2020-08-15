import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  //loading bar
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.blue,
      ),
    );
  }
}
