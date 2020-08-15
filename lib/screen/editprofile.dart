import 'dart:convert';
import 'dart:io';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:najibkado/models/user_model.dart';
import 'package:najibkado/models/user_profile_model.dart';
import 'package:najibkado/utils/constant.dart';
import 'package:najibkado/utils/imageutils.dart';
import 'package:najibkado/utils/location.dart';
import 'package:najibkado/utils/resource.dart';
import 'package:najibkado/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;

class EditProfile extends StatefulWidget {
  EditProfile();

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
 bool _status = true;

  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  File file;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _urlController = TextEditingController();
  ProfileUser profileUser;
  User profileUserDetails;
  Address address;
  double longitudeText,latitudeText;
  String _locationTexthome = 'getting location...';
  String _locationText;
  Resource resource = new Resource();
  Map<String, double> currentLocation = Map();
  var myLocation;
  bool isFree = true;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String token;



 _profileSubmit() async {
   if(_formKey.currentState.validate() && isFree){
    _formKey.currentState.save();
   String baseUrl = appApiUrl + 'profile/update';
    setState(() {_isLoading = true;});
    await resource.getUserToken().then((tokn) {
      setState(() {
        token = tokn;
      });
    });

    // Intilize the multipart request
    final sendiSmartRequest =
        http.MultipartRequest('POST', Uri.parse(baseUrl));

        sendiSmartRequest.headers['Content-type'] = 'application/json';
        sendiSmartRequest.headers['Accept'] = 'application/json';
        sendiSmartRequest.headers['Authorization'] = 'Bearer ' + token;

        sendiSmartRequest.fields['fullname'] = _nameController.text;
        sendiSmartRequest.fields['username'] = _usernameController.text;
        sendiSmartRequest.fields['description'] = _bioController.text;
        sendiSmartRequest.fields['url'] = _urlController.text;

     


    //if user choose to upload new photo
    if(file != null){
      //compressImage();
    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
        lookupMimeType(file.path, headerBytes: [0xFF, 0xD8]).split('/');
    // Attach the file in the request
    final fileimage = await http.MultipartFile.fromPath('image', file.path, contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
      sendiSmartRequest.files.add(fileimage);
    }
    
    try {
      final streamedResponse = await sendiSmartRequest.send();

      final response = await http.Response.fromStream(streamedResponse);

final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      
      if (response.statusCode == 200) {
        await resource.setUserDetails(user: json.encode(responseData['user']));
        Utils().showTostSuccess("Profile Updated Successfully!!!");
      }else{
        Utils().showTostError("Profile Update Failed!!!");
      }

      

      setState(() {_isLoading = false;});

      //return responseData;
    } catch (e) {
      print(e);
      //return null;
    }
setState(() {_isLoading = false;});
   }
  }


  @override
  void initState() {
    // TODO: implement initState
    
    //method to call location
    _makeCall();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    //asyncLoaderState.currentState.reloadState();
_makeCall();
    return null;
  }

  
 

  _checkUsername() async {
    //print('am call to check username');
    if(_usernameController.text.trim().isNotEmpty){
    var check = await Utils().makeHttpgetRequest('check-username/${_usernameController.text}');
    
    if(check !=null){
      setState(() {
        isFree = true;
      });
    }else{
        setState(() {
        //_usernameController.text = 'username';
        isFree = false;  
        });
        
    }}
    }


  _showProfileEditPage(){
     if(profileUserDetails == null ){
        return  Center(child: new CircularProgressIndicator());} else{    
        return _body();
        }
  }

  _body(){
    return Container(
      color: Colors.white,
      child:  ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
            children: <Widget>[
              GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                        width: 110.0,
                        height: 110.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          image: file != null ? DecorationImage(
                              image: FileImage(file),
                              fit: BoxFit.cover)
              : DecorationImage(
                              image: getCurrentUser.profile.image == null
                                  ? AssetImage(noImage)
                                  : NetworkImage(appImageUrl+getCurrentUser.profile.profileThumbnail),
                              fit: BoxFit.cover),
                        )),
                  ),
                  onTap: () =>_openImagePickerModal(context)),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text('Change Profile Photo',
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700)),
                ),
                onTap: () => _openImagePickerModal(context),
              )
            ],
          ),
              new Container(
                color: Color(0xffFFFFFF),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: Form(
                    key: _formKey,
                      child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                       
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Name',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    controller: _nameController,
                                    validator: (input) => input.trim().isEmpty || input.length < 4 ? 'not allow':null,
                                    decoration: InputDecoration(
                                      hintText: "Name",
                                      hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey)
                                    ),
                                    
                                    
                                  ),
                                ),
                              ],
                            )),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Username',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                               Flexible(
                                  child: new TextFormField(
                                    controller: _usernameController,
                                    validator: (input)=> input.trim().isEmpty || input.length < 4 || input.contains('/')? 'not allow':null,
                                    onChanged: (input) => _checkUsername(),
                                    //onEditingComplete: _checkUsername,
                                    decoration: InputDecoration(
                                      hintText: "Username",
                                      hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey)
                                    ),
                                    
                                    
                                  ),
                                ),
                              isFree ? SizedBox.shrink() : Text('not available'),
                              ],
                            )),


                            Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Website',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    controller: _urlController,
                                    decoration: InputDecoration(
                                      hintText: "Website",
                                      hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey)
                                    ),
                                    
                                  ),
                                ),
                              ],
                            )),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Bio',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    controller: _bioController,
                                    decoration: InputDecoration(
                                      hintText: "Bio",
                                      hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey)
                                    ),
                                    
                                    
                                  ),
                                ),
                              ],
                            )),


                                                  Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Private Information',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),

                                Padding(
                            padding: EdgeInsets.only(
                                 top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Email Address',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                        hintText: "Email Address",
                                        hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey)),
                                        
                                        enabled: false,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                               top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                        hintText: "Phone Number",
                                        hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey)),
                                  ),
                                ),
                              ],
                            )),
                                                   
                                





                             
                              ],
                            ),

                            ),

                            



                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _makeCall() async {
    var body = await Utils().makeHttpgetRequest('profile/${getCurrentUser.id}');
        if (body != null) {
          setState(() {
          profileUser =  ProfileUser.fromJson(body);
          profileUserDetails =  profileUser.userDetails; 

          _nameController.text = profileUserDetails.fullname;
          _usernameController.text = profileUserDetails.username;
          _emailController.text = profileUserDetails.email;
          _phoneController.text = profileUserDetails.phoneNumber;
          _urlController.text = profileUserDetails.profile.url;
          _bioController.text = profileUserDetails.profile.description;
          });
          
          
        }
  }

 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 1,
        title: Text('Edit Profile', style: TextStyle(color: Colors.white,)),
        leading: GestureDetector(
          child: Icon(Icons.close, color: Colors.white),
          onTap: () => Navigator.pop(context),
        ),
        actions: <Widget>[
           _isLoading ? CircularProgressIndicator(semanticsValue: 'updating...',) : GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(Icons.done, color: Colors.white),
            ),
            onTap: _isLoading ? null : () {
              //make http call here
             // _startUpdating();
             _profileSubmit();

            },
          )
        ],
      ),
        body: GestureDetector(
          onTap:()=> FocusScope.of(context).unfocus(),
                  child: Scrollbar(
          child: RefreshIndicator(
              onRefresh: () => _handleRefresh(), child: _showProfileEditPage()),
      ),
        ),
    ); 
  }

  

  

  void _getImage(BuildContext context, ImageSource source) async {
    // Closes the bottom sheet
    Navigator.pop(context);
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      image = await cropImage(image);
      setState(() {
        file = image;
      });

      //compressImage();

    }
  }

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: flatButtonColor,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: IconButton(
                          onPressed: () {
                            _getImage(context, ImageSource.camera);
                          },
                          icon: Icon(Icons.camera_alt),
                          color: Colors.white),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: IconButton(
                          onPressed: () {
                            _getImage(context, ImageSource.gallery);
                          },
                          icon: Icon(Icons.image),
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Math.Random().nextInt(10000);

    Im.Image image = Im.decodeImage(file.readAsBytesSync());
    Im.copyResize(image, height: 500, width: 500);

//    image.format = Im.Image.RGBA;
//    Im.Image newim = Im.remapColors(image, alpha: Im.LUMINANCE);

    var newim2 = File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      file = newim2;
    });
    print('done');
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }
}