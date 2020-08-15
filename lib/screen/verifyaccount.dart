import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:najibkado/api/api.dart';
import 'package:najibkado/utils/constant.dart';
import 'package:najibkado/utils/resource.dart';
import 'package:najibkado/utils/utils.dart';
import 'package:najibkado/widget/loading.dart';
import 'continuelogin.dart';
import 'splash.dart';


class VerifyAccount extends StatefulWidget {
  static final String id = 'login_screen';
  @override
  _VerifyAccountState createState() => _VerifyAccountState();
}


class _VerifyAccountState extends State<VerifyAccount> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
   // reference to our single class that manages the database
  Resource  resource = new Resource();


  TextEditingController _code = TextEditingController();
  

  _submit() async{
  if(_formKey.currentState.validate()){
    _formKey.currentState.save();

    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => SplashScreen()));

    
    /*
    setState(() {_isLoading = true;});

    var data = {
      'code' : _code.text,
    };

    try {
    var res = await CallApi().postData(data, 'verify-account');
    
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => ContinueLogin()));
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
                          padding: const EdgeInsets.only(bottom: 150, left: 30, top: 50),
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Verify your account', style: TextStyle(color: Colors.blue, fontSize: 24), textAlign: TextAlign.left,),
                                  SizedBox(height: 8,),
                                  Text('Please enter the code that has been sent to your email to verify you are the owner of the account', style: TextStyle(color: Colors.blue, fontSize: 14),),
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
                                controller: _code,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Verification Code",
                                  
                                ),
                                validator: (value) {
                                        if (value.isEmpty) {
                                          return "The Code field cannot be empty";
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
                              'Verify',
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