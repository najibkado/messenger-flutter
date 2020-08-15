import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:najibkado/api/api.dart';
import 'package:najibkado/utils/constant.dart';
import 'package:najibkado/utils/resource.dart';
import 'package:najibkado/utils/utils.dart';
import 'package:najibkado/widget/loading.dart';

import 'home.dart';
import 'login.dart';
import 'verifyaccount.dart';

class SignUp extends StatefulWidget {
  static final String id = 'signup_screen';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _username = TextEditingController();
  bool hidePass = true;
  bool _isLoading = false;
   // reference to our single class that manages the database
  Resource  resource = new Resource();


  _submit() async{
  if(_formKey.currentState.validate()){
    _formKey.currentState.save();
    setState(() {_isLoading = true;});

    var data = {
      'fullname' : _name.text,
      'username' : _username.text,
      'email' : _email.text,
      'password' : _password.text
    };

    try {
    var res = await CallApi().postData(data, 'register');
    
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      //set user details into shareprefrence  
      await resource.setUserDetails(token: body['accessToken'], user: json.encode(body['user']));
      var user = body['user'];
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => VerifyAccount()));
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
                          padding: const EdgeInsets.only(bottom: 100, left: 30, top: 50),
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: Text('Sign Up', style: TextStyle(color: Colors.blue, fontSize: 24),)
                              ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child: ListTile(
                                title: TextFormField(
                                  controller: _name,
                                  decoration: InputDecoration(
                                      hintText: "Full name",
                                      //icon: Icon(Icons.person_outline),
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "The name field cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            
                          ),
                        ),


                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child:  ListTile(
                                title: TextFormField(
                                  controller: _username,
                                  decoration: InputDecoration(
                                      hintText: "Username",
                                      //icon: Icon(Icons.person_outline),
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "The username field cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            
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
                              const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                obscureText: true,
                                controller: _password,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                              
                                  //icon: Icon(Icons.lock_outline),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "The password field cannot be empty";
                                  } else if (value.length < 6) {
                                    return "the password has to be at least 6 characters long";
                                  }
                                  return null;
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
                              'Sign Up',
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
                                              builder: (context) => Login()));
                                    },
                                    child: Text(
                                      "Already have an account? Login Instead",
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