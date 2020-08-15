import 'package:flutter/material.dart';
import 'package:najibkado/models/message_model.dart';
import 'package:najibkado/models/user_model.dart';
import 'package:najibkado/screen/chat_screen.dart';
import 'package:najibkado/utils/constant.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecentChat extends StatelessWidget {
  int index;
  Messages chat;
  Function onDelete;
  RecentChat({this.index, this.chat, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
          child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: chat.sender,
                        ))),
            child: Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
              /*decoration: BoxDecoration(color: chat.unread ? Colors.grey[100] : Colors.white,
                
                borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                ),*/
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage:
                            chat.sender.profilePix.profileImage == null
                                ? AssetImage(noImage)
                                : NetworkImage(appImageUrl +
                                    chat.sender.profilePix.profileThumbnail),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(chat.sender.username,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0)),
                          SizedBox(
                            height: 2.0,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Text(
                                chat.message == null ? 'image' : chat.message,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 13.0),
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(timeago.format(DateTime.parse(chat.createdAt)),
                          style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                      SizedBox(height: 2.0),
                      chat.senderId == currentUser.id
                          ? SizedBox.shrink()
                          : chat.unread
                              ? Container(
                                  height: 20.0,
                                  width: 40.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '.',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.bold),
                                  ))
                              : Container(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
          child: Divider(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
