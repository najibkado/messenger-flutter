import 'package:flutter/material.dart';
import 'package:najibkado/screen/home.dart';
import 'package:najibkado/utils/constant.dart';
import 'package:najibkado/utils/resource.dart';
import 'package:najibkado/widget/loading.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  static final String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
   // reference to our single class that manages the database
  Resource  resource = new Resource();
  


@override
  Widget build(BuildContext context) {
    //final customer = Provider.of<customerProvider>(context);
    return Scaffold(
      key: _key,
      body:_isLoading ? Loading() : Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[350],
                      blurRadius:
                      20.0, // has the effect of softening the shadow
                    )
                  ],
                ),
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 40,),
                        Padding(
                          padding: const EdgeInsets.only( left: 30, top: 50),
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: Text('Welcome!', style: TextStyle(color: Colors.blue, fontSize: 24),)
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 150, left: 30, top: 3),
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: Text('Chat with your friends easily! Don\'t worry about nothing, Kiki got you covered.', style: TextStyle(color: Colors.blue, fontSize: 12),)
                              ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                          child: Image.asset(noImage),
                        ),

                        Padding(
                          padding:
                           EdgeInsets.fromLTRB(30.0, 80.0, 30.0, 8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Note: This is a final year project and is only out for testing. Rest assure that your messages are fully encrypted and there is nothing to worry about",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                              SizedBox(height: 8.0,),
                           
                  
                          GestureDetector(
                          onTap: () async {
                            //await resource.setSplash(true);
                            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomeScreen()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width *0.8,
                            padding: EdgeInsets.only(
                              left: 18,
                              right: 18,
                              top: 8,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Color(0xff4059F1)
                                  ],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.centerLeft),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                              'Continue',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  
                                  fontWeight: FontWeight.bold),
                                  ),
                            ),
                          ),
                        )
                        ],
                          )
                          
                        ),

                      ],
                    )),

              ),
            ),
          ),
        ],
      ),
    );
  }


}