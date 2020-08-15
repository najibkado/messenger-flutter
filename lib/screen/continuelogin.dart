import 'package:flutter/material.dart';
import 'login.dart';


class ContinueLogin extends StatefulWidget {
  static final String id = 'login_screen';
  @override
  _ContinueLoginState createState() => _ContinueLoginState();
}


class _ContinueLoginState extends State<ContinueLogin> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

@override
  Widget build(BuildContext context) {
    //final customer = Provider.of<customerProvider>(context);
    return Scaffold(
      key: _key,
      body: Stack(
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
                          padding: const EdgeInsets.only(bottom: 150, left: 30, top: 50),
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Successful!', style: TextStyle(color: Colors.blue, fontSize: 24),),
                                  SizedBox(height: 8,),
                                  Text('Your password has been successfully updated\nYou can now login', style: TextStyle(color: Colors.blue, fontSize: 14),),
                                ],
                              )
                              ),
                        ),

                        
                        
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30.0, 80.0, 30.0, 8.0),


                          child: GestureDetector(
                          onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Login())),
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
                              'Continue to login',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  
                                  fontWeight: FontWeight.bold),
                                  ),
                            ),
                          ),
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