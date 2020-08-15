import 'dart:async';
import 'dart:convert';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:najibkado/models/search_user_model.dart';
import 'package:najibkado/models/user_model.dart';
import 'package:najibkado/screen/profile.dart';
import 'package:najibkado/utils/constant.dart';
import 'package:najibkado/utils/resource.dart';
import 'package:najibkado/utils/utils.dart';
import 'package:najibkado/widget/loading.dart';

class SearchScreen extends StatefulWidget {
  static final String id = 'search_screen';
  SearchScreen();

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();
  Resource  resource = new Resource();
  String token;
  List<User> userList;
  SearchUser user;



 Future<Null> _handleRefresh() async {
   if(!_searchController.text.trim().isEmpty)
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  _buildSearchUser(List<User> users){
    return users == null ? Utils().getNoDataWidget(asyncLoaderState, "Search not found"): 
    ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        User searchUser = users[index];

      return Card(
        elevation: 1.0,
              child: GestureDetector(
                onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile(profileUserID: searchUser.id ,))),
                              child: ListTile(
          leading: ClipRRect(
                           borderRadius: BorderRadius.circular(20.0),
                            child:
                            Image(
                                        height: 40.0,
                                        width: 40.0,
                                        image: searchUser.profile.image == null ? AssetImage(noImage): NetworkImage(appImageUrl+searchUser.profile.image),
                                        fit: BoxFit.cover,
                                      ),),
          title: Text(searchUser.username,style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)),
          subtitle: searchUser.fullname == null ? SizedBox.shrink() :Text(searchUser.fullname,style: TextStyle(color: Colors.grey, fontSize: 14.0,)),
          trailing: GestureDetector(
                      onTap: () {
                                        Utils().submitFollowerUser(searchUser.id);
                                        if(searchUser.profile.isFollowing){
                                          setState(() {
                                            searchUser.profile.followersCount -= 1;
                                            searchUser.profile.isFollowing = false;
                                          });
                                        }else{
                                          setState(() {
                                            searchUser.profile.followersCount += 1;
                                            searchUser.profile.isFollowing = true;
                                          });
                                        }
                                      },
                        child: searchUser.id == getCurrentUser.id ? SizedBox.shrink() : Container(
                                      width: 90,
                                      padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8,),
                                      decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [Color(0xff6D0EB5), Color(0xff4059F1)], begin: Alignment.bottomRight, end: Alignment.centerLeft),
                                      borderRadius: BorderRadius.all(Radius.circular(33)),
                                                                ),
                                      child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(searchUser.profile.isFollowing ? FontAwesomeIcons.userCheck : FontAwesomeIcons.userPlus, color: Colors.white, size: 10,),
                                        SizedBox(width: 5,),
                                        Text(searchUser.profile.isFollowing ? 'Following': 'Follow', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                      ],
                                        ),
                                ),
          ) ,
          ),
              ),
      ) ;
     },
    );

  }


  @override
  Widget build(BuildContext context) {
    
var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async {
        var body = await Utils().makeHttpgetRequest('search/${_searchController.text}');
        if(body != null){
        user = SearchUser.fromJson(body);
        userList = user.userSearch;
        return userList;
        }
      },
      renderLoad: () => Center(child: Loading()),
      renderError: ([error]) => Utils().getNoConnectionWidget(asyncLoaderState),
      renderSuccess: ({data}) => _buildSearchUser(data),

    );


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextField(
          autofocus: true,
          controller: _searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
            //prefixIcon: Icon(Icons.search, size: 20.0, color: Colors.white,),
            suffixIcon: IconButton(icon: Icon(Icons.clear), color: Colors.white, onPressed: () => 
            //_searchController.clear()
            Navigator.pop(context),),
            filled: true,
          
          ),
          onSubmitted: (input) async {
          var body = await Utils().makeHttpgetRequest('search/${_searchController.text}');
        if(body != null){
        user = SearchUser.fromJson(body);
        setState(() {
          userList = user.userSearch;
        });
        
        //_handleRefresh();
          }
          }
        ),
      ),
    body: _searchController.text.trim().isEmpty ? Center(child: Text('Search for user'),):
       
Scrollbar(
    child: RefreshIndicator(
      onRefresh: () => _handleRefresh(),
      child: _asyncLoader
    ),
      )

,
    );
  }
}