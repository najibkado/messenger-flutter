import 'dart:io';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:najibkado/models/user_model.dart';
import 'package:najibkado/models/user_profile_model.dart';
import 'package:najibkado/utils/constant.dart';
import 'package:najibkado/utils/utils.dart';
import 'package:najibkado/widget/loading.dart';

import 'chat_screen.dart';
import 'editprofile.dart';

class UserProfile extends StatefulWidget {
  int profileUserID;
  UserProfile({this.profileUserID});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File file;
  bool _isLoading = false;
  ProfileUser profileUser;
  User profileUserDetails;
  Widget _appBarTitle = new Text('My Profile');
  Widget _settingIcons = IconButton(
      icon: Icon(
        Icons.settings,
        color: Colors.white,
      ),
      onPressed: null);
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  Future<Null> _handleRefresh() async {
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  _showProfilePage(User profileUserDetails) {
    return profileUserDetails == null
        ? Utils()
            .getNoDataWidget(asyncLoaderState, "User not found", color: 'white')
        : _body();
  }

  Widget _body() {
    return SingleChildScrollView(
        child: profileUserDetails.profile.isBlockedMe ? Center(child: Text("Sorry ${profileUserDetails.username} has blocked you")): Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          //image
          Padding(
            padding: EdgeInsets.only(top: 50, bottom: 30),
            child: Column(
              children: <Widget>[
                Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.black12,
                      backgroundImage:
                          profileUserDetails.profilePix.profileThumbnail == null
                              ? AssetImage(noImage)
                              : NetworkImage(appImageUrl +
                                  profileUserDetails
                                      .profilePix.profileThumbnail),
                    ),
                  ),
                  profileUserDetails.id == getCurrentUser.id
                      ? Positioned(
                          bottom: 0.0,
                          right: 12.0,
                          //top: 102.0,
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.userEdit),
                              color: Colors.white,
                              iconSize: 24,
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EditProfile())),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue, shape: BoxShape.circle),
                          ),
                        )
                      : SizedBox.shrink(),
                ]),
              ],
            ),
          ),

          //following section

          Padding(
            padding: EdgeInsets.only(
              right: 80.0,
              left: 80,
              top: 15,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(profileUserDetails.profile.followersCount.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)),
                    Text('Followers',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ],
                ),
                Container(
                  color: Colors.black,
                  width: 0.2,
                  height: 22.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(profileUserDetails.profile.followingCount.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)),
                    Text('Following',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ],
                ),
              ],
            ),
          ),

          //divider
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Divider(
              color: Colors.black26,
            ),
          ),

          //name section
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20),
            child: Container(
              decoration: BoxDecoration(color: Colors.black12),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            profileUserDetails.username == null
                                ? SizedBox.shrink()
                                : Text(
                                    "Name",
                                    style: TextStyle(
                                        color: Colors.black,
                                        wordSpacing: 1,
                                        letterSpacing: 1.0),
                                  ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 0.0,
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      child: Text(
                                        profileUserDetails.username,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            wordSpacing: 1,
                                            letterSpacing: 1.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, top: 25, bottom: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            profileUserDetails.username == null
                                ? SizedBox.shrink()
                                : Text(
                                    "Email",
                                    style: TextStyle(
                                        color: Colors.black,
                                        wordSpacing: 1,
                                        letterSpacing: 1.0),
                                  ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 0.0,
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      child: Text(
                                        profileUserDetails.email,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            wordSpacing: 1,
                                            letterSpacing: 1.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          //button section
          Padding(
            padding: EdgeInsets.only(
              right: 30.0,
              left: 30,
              top: 90,
              bottom: 12,
            ),
            child: profileUserDetails.id == getCurrentUser.id
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                        GestureDetector(
                          onTap: () => logout(context),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.only(
                              left: 18,
                              right: 18,
                              top: 8,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.blue, Color(0xff4059F1)],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.centerLeft),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.powerOff,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Logout',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ])
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                      user: profileUserDetails,
                                    ))),
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 8,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.blue, Color(0xff4059F1)],
                                begin: Alignment.bottomRight,
                                end: Alignment.centerLeft),
                            borderRadius: BorderRadius.all(Radius.circular(33)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Message',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //block and unblock
                      Container(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: profileUserDetails.profile.isBlocked ? [Colors.green, Colors.green[900]]:[Colors.red, Colors.black],
                              begin: Alignment.bottomRight,
                              end: Alignment.centerLeft),
                          borderRadius: BorderRadius.all(Radius.circular(33)),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Utils().submitBlockedUser(widget.profileUserID);
                            if (profileUserDetails.profile.isBlocked) {
                              setState(() {
                                
                                profileUserDetails.profile.isBlocked = false;
                              });
                            } else {
                              setState(() {
                                profileUserDetails.profile.isBlocked = true;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  profileUserDetails.profile.isBlocked
                                      ? FontAwesomeIcons.unlock
                                      : FontAwesomeIcons.ban,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  profileUserDetails.profile.isBlocked
                                      ? 'Unblock'
                                      : 'Block',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),


                      //follow and unfollow
                      Container(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.blue, Color(0xff4059F1)],
                              begin: Alignment.bottomRight,
                              end: Alignment.centerLeft),
                          borderRadius: BorderRadius.all(Radius.circular(33)),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Utils().submitFollowerUser(widget.profileUserID);
                            if (profileUserDetails.profile.isFollowing) {
                              setState(() {
                                profileUserDetails.profile.followersCount -= 1;
                                profileUserDetails.profile.isFollowing = false;
                              });
                            } else {
                              setState(() {
                                profileUserDetails.profile.followersCount += 1;
                                profileUserDetails.profile.isFollowing = true;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  profileUserDetails.profile.isFollowing
                                      ? FontAwesomeIcons.userCheck
                                      : FontAwesomeIcons.userPlus,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  profileUserDetails.profile.isFollowing
                                      ? 'Following'
                                      : 'Follow',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async {
        var body = await Utils()
            .makeHttpgetRequest('profile/${widget.profileUserID.toString()}');
        if (body != null) {
          profileUser = ProfileUser.fromJson(body);
          profileUserDetails = profileUser.userDetails;
          setState(() {
            if (profileUserDetails.id != getCurrentUser.id) {
              _appBarTitle = Text('${profileUserDetails.username} Profile');
              _settingIcons = SizedBox.shrink();
            }
          });
          return profileUserDetails;
        }
      },
      renderLoad: () => Loading(),
      renderError: ([error]) =>
          Utils().getNoConnectionWidget(asyncLoaderState, color: 'white'),
      renderSuccess: ({data}) => _showProfilePage(data),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _appBarTitle,
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: <Widget>[_settingIcons],
      ),
      body: Scrollbar(
        child: RefreshIndicator(
            onRefresh: () => _handleRefresh(), child: _asyncLoader),
      ),
    );
  }
}
