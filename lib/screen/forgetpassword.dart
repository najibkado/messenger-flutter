import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:najibkado/screen/verifyaccount.dart';
import 'package:najibkado/utils/constant.dart';
import 'package:najibkado/utils/resource.dart';
import 'package:najibkado/utils/utils.dart';
import 'package:najibkado/widget/loading.dart';
import 'signup.dart';

class ForgotPassword extends StatefulWidget {
  static final String id = 'login_screen';
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}


class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
   // reference to our single class that manages the database
  Resource  resource = new Resource();


  TextEditingController _email = TextEditingController();
  

  _submit() async{
  if(_formKey.currentState.validate()){
    _formKey.currentState.save();
    
    Navigator.push(context, MaterialPageRoute(builder: (_) => VerifyAccount()));


    /*
    to make use of this feature kindly uncomment this line and remove above nagivation


    //setState(() {_isLoading = true;});
    var data = {
      'email' : _email.text,
    };
    try {
    var res = await CallApi().postData(data, 'forgot-password');
    
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
         Navigator.push(context, MaterialPageRoute(builder: (_) => VerifyAccount()));
    }else if(res.statusCode == 401){
      var errorMsg = "";  
      json.encode(body['error']) != null ?  errorMsg = json.encode(body['error']) : errorMsg = json.encode(body['message']);
      Utils().showTostError(json.encode(body['message']));

    }else{
      Utils().showTostError("Unknown error occure please try again later");
    }

    }catch(e) {
  if (e is TimeoutException) {
    //Timed out
    Utils().showTostError("Error in Network Connection");
  }
}
    
    setState(() {
      _isLoading = false;
    });
*/


      
  }
}




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
                          padding: const EdgeInsets.only(bottom: 150, left: 0, top: 50),
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: <Widget>[
                                  Text('Recover Password', style: TextStyle(color: Colors.blue, fontSize: 24),),
                                  SizedBox(height: 8,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 38),
                                    child: Text('Please enter your register email address', style: TextStyle(color: Colors.blue, fontSize: 14),),
                                  ),
                                ],
                              )
                              ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: _email,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  //icon: Icon(Icons.alternate_email),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value))
                                      return 'Please make sure your email address is valid';
                                    else
                                      return null;
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30.0, 80.0, 30.0, 8.0),


                          child: GestureDetector(
                          onTap: () => _submit(),
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
                              'Submit',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUp()));
                                    },
                                    child: Text(
                                      "Sign up instead",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ))
                                    ),
                          ],
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