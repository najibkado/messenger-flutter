import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:najibkado/agora/call.dart';
import 'package:najibkado/agora/joinvideocall.dart';
import 'package:najibkado/api/api.dart';
import 'package:najibkado/models/message_model.dart';
import 'package:najibkado/models/user_model.dart';
import 'package:najibkado/utils/constant.dart';
import 'package:najibkado/utils/imageutils.dart';
import 'package:najibkado/utils/resource.dart';
import 'package:najibkado/utils/utils.dart';
import 'package:najibkado/widget/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as Math;
import 'profile.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';

import 'videocall.dart';
import 'voicecall.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class ChatScreen extends StatefulWidget {
  static final String id = 'chatscreen_id';

  final User user;
  final LocalFileSystem localFileSystem;
  ChatScreen({this.user, this.localFileSystem});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Resource resource = new Resource();
  Message message;
  List<Messages> messages;
  bool _isTyping = false;
  bool _isSending = false;
  TextEditingController editingController = new TextEditingController();
  String token;
  TimeOfDay now = TimeOfDay.now();
  File file;
  bool isShowingSticker = false;
  var _channel;

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  String _inputBoxHint = 'Send a message...';
  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    _init();
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  Future<bool> onBackPress() {
    if (isShowingSticker) {
      setState(() {
        isShowingSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  _hideEmoji() {
    // _captionController.
    FocusScope.of(context).requestFocus(myFocusNode);
    return Container();
  }

  Widget buildSticker() {
    FocusScope.of(context).unfocus();
    return EmojiPicker(
        rows: 4,
        columns: 7,
        buttonMode: ButtonMode.MATERIAL,
        //recommendKeywords: ["love,", "kiss"],
        numRecommended: 10,
        onEmojiSelected: (emoji, category) {
          print(emoji);
        });
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/kado_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }

  _recordButton() {
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          _start();
          break;
        }
      case RecordingStatus.Recording:
        {
          _pause();
          break;
        }
      case RecordingStatus.Paused:
        {
          _resume();
          break;
        }
      case RecordingStatus.Stopped:
        {
          _init();
          break;
        }
      default:
        break;
    }
  }

  void _getImage(BuildContext context, ImageSource source) async {
    // Closes the bottom sheet
    Navigator.pop(context);
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      image = await cropImage(image);
      setState(() {
        file = image;
        _sendMessage();
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

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  Future<List<Messages>> fetchChats() async {
    //fetch user chat list
    var body = await Utils().makeHttpgetRequest('chat/${widget.user.id}');
    if (body != null) {
      message = Message.fromJson(body);
      messages = message.messages;
      return messages;
    }
  }

  void addNewMessage() {
    if (editingController.text.trim().isNotEmpty) {
      Messages newMessage = Messages(
          message: editingController.text.trim(),
          createdAt: new DateTime.now().toString(),
          recieverId: widget.user.id,
          updatedAt: new DateTime.now().toString(),
          id: 0,
          senderId: getCurrentUser.id,
          isLiked: false,
          unread: true,
          type: file == null ? 'text' : 'image',
          sender: User(
              username: getCurrentUser.username,
              profile:
                  Profile(image: getCurrentUser.profile.profileThumbnail)));

      setState(() {
        if (messages == null) {
          messages = [];
          messages.add(newMessage);
        } else {
          messages.add(newMessage);
        }
        editingController.text = '';
      });
    }
  }

  _sendMessage() async {
    if (editingController.text.trim().isNotEmpty || file != null) {
      setState(() {
        _isSending = true;
      });
      String baseUrl = appApiUrl + 'send-chat';
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
      sendiSmartRequest.fields['message'] = editingController.text;
      sendiSmartRequest.fields['reciever_id'] = widget.user.id.toString();
      sendiSmartRequest.fields['sender_id'] = getCurrentUser.id.toString();
      sendiSmartRequest.fields['type'] = file == null ? 'text' : 'image';
      sendiSmartRequest.fields['isLiked'] = '0';
      sendiSmartRequest.fields['unread'] = '1';

      //if user choose to upload new photo
      if (file != null) {
        //compressImage();
        // Find the mime type of the selected file by looking at the header bytes of the file
        final mimeTypeData =
            lookupMimeType(file.path, headerBytes: [0xFF, 0xD8]).split('/');
        // Attach the file in the request
        final fileimage = await http.MultipartFile.fromPath('image', file.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
        sendiSmartRequest.files.add(fileimage);
      }

      try {
        final streamedResponse = await sendiSmartRequest.send();

        final response = await http.Response.fromStream(streamedResponse);

        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);

        if (response.statusCode == 200) {
          setState(() {
            editingController.text = '';
          });
        } else {
          Utils().showTostError("Error");
        }
        setState(() {
          _isSending = false;
          clearImage();
        });

        //return responseData;
      } catch (e) {
        print(e);
        //return null;
      }
    }
  }

  _sendMessageold() async {
    if (editingController.text.trim().isNotEmpty) {
      setState(() {
        _isSending = true;
      });

      var data = {
        'message': editingController.text,
        'reciever_id': widget.user.id,
        'sender_id': getCurrentUser.id,
        'type': file == null ? 'text' : 'image',
        'isLiked': false,
        'unread': true,
      };

      await resource.getUserToken().then((tokn) {
        setState(() {
          token = tokn;
        });
      });
      var res = await CallApi().postDataCurrentUser(data, 'send-chat', token);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        //addNewMessage();
        setState(() {
          editingController.text = '';
        });
      } else if (res.statusCode == 401) {
        Utils().showTostError(json.encode(body['error']));
      } else {
        Utils().showTostError("Unknown error occure please try again later");
      }

      setState(() {
        _isSending = false;
      });
    }
  }

  _buildMessage(Messages message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.black12,
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(7.0),
                  bottomLeft: Radius.circular(7.0))
              : BorderRadius.only(
                  topRight: Radius.circular(7.0),
                  bottomRight: Radius.circular(7.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              message.image != null
                  ? Container(
                      width: 110.0,
                      height: 110.0,
                      decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(80.0),
                          image: DecorationImage(
                              image: NetworkImage(appImageUrl +
                                  message.image), //FileImage(file),
                              fit: BoxFit.cover)))
                  : Text(message.message,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600)),
              Text(
                formatTimeOfDay(TimeOfDay.fromDateTime(
                        DateTime.parse(message.createdAt)))
                    .toString(),
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );

    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        //IconButton(icon: message.isLiked ?
        //Icon(Icons.favorite): Icon(Icons.favorite_border), onPressed: () {}, iconSize: 20.0, color: message.isLiked ? Colors.red : Colors.blueGrey,)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.black12,
            backgroundImage: widget.user.profilePix.profileThumbnail == null
                ? AssetImage(noImage)
                : NetworkImage(
                    appImageUrl + widget.user.profilePix.profileThumbnail),
          ),
        ),
        msg,
      ],
    );
    //return  msg;
  }

  _buildMessageComposer() {
    bool changeIcon = false;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _chatInputComposer(),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: _isTyping
                    ? IconButton(
                        icon: Icon(Icons.send),
                        iconSize: 25.0,
                        onPressed: () {
                          _sendMessage();
                        },
                        color: Colors.white,
                      )
                    : IconButton(
                        icon: Icon(Icons.mic),
                        iconSize: 25.0,
                        onPressed: () {
                          _recordButton();
                        },
                        color: Colors.white,
                      ),
              ),
            ),
          ],
        ));
  }

  _chatInputComposer() {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 3.0),
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      height: 50.0,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.insert_emoticon),
            iconSize: 25.0,
            onPressed: () {
              setState(() {
                isShowingSticker = !isShowingSticker;
              });
            },
            color: Colors.blueGrey,
          ),
          Expanded(
            child: TextField(
              controller: editingController,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              focusNode: myFocusNode,
              onChanged: (input) {
                if (!input.trim().isEmpty) {
                  setState(() {
                    _isTyping = true;
                  });
                } else {
                  setState(() {
                    _isTyping = false;
                  });
                }
              },
              decoration: InputDecoration.collapsed(hintText: _inputBoxHint),
            ),
          ),
          //IconButton(icon: Icon(Icons.attach_file), iconSize: 25.0, onPressed: () {}, color: Colors.blueGrey,),
          !_isTyping
              ? IconButton(
                  icon: Icon(Icons.image),
                  iconSize: 25.0,
                  onPressed: () {
                    _openImagePickerModal(context);
                  },
                  color: Colors.blueGrey,
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          titleSpacing: -10,
          //leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.white, iconSize: 25.0, onPressed: () => Navigator.pop(context) ,),
          title: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => UserProfile(
                          profileUserID: widget.user.id,
                        ))),
            child: Text(
              widget.user.username,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          //centerTitle: true,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.videocam),
              iconSize: 28.0,
              color: Colors.white,
              onPressed: () {
                //onJoin();
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => JoinCallPage(
                              user: widget.user,
                            )));

                //Navigator.push(context,MaterialPageRoute(builder: (_) => JoinCallPage(user: widget.user,)));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 10),
              child: IconButton(
                icon: Icon(Icons.call),
                iconSize: 28.0,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => VoiceCallPage(
                                user: widget.user,
                              )));
                },
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    child: FutureBuilder(
                      future: fetchChats(),
                      initialData: Loading(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return Loading();
                            break;
                          case ConnectionState.done:
                            return (snapshot.hasData)
                                ? ListView.builder(
                                    reverse: true,
                                    padding: EdgeInsets.only(top: 15.0),
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final Messages message =
                                          snapshot.data[index];
                                      bool isMe =
                                          message.senderId == currentUser.id;
                                      return _buildMessage(message, isMe);
                                    })
                                : Center(child: Text('No recent chat'));

                          default:
                        }
                      },
                    ),
                  ),
                ),
              ),
              widget.user?.profile?.isBlockedMe == null
                  ? _buildMessageComposer()
                  : widget.user.profile.isBlockedMe
                      ? Center(
                          child: Text(
                              'sorry ${widget.user.username} has blocked you'),
                        )
                      : _buildMessageComposer(),
              (isShowingSticker ? buildSticker() : _hideEmoji()),
            ],
          ),
        ),
      ),
      onWillPop: onBackPress,
    );
  }

  @override
  void dispose() {
    // dispose input controller
    _channel.dispose();
    editingController.dispose();
    super.dispose();
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channel = randomAlpha(5);
    });
    if (_channel.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channel,
            user: widget.user,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
