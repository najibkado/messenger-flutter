import 'package:async_loader/async_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:najibkado/models/message_model.dart';
import 'package:najibkado/models/user_model.dart';
import 'package:najibkado/utils/resource.dart';
import 'package:najibkado/utils/utils.dart';
import 'package:najibkado/widget/loading.dart';
import 'package:najibkado/widget/recent_chats.dart';

import 'profile.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  Resource resource = new Resource();
  String token;
  Message message;
  List<Messages> messages;
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests
  String _searchText = "";
  List filteredNames = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Chat');

  Future<Null> _handleRefresh() async {
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  fetchChat() async {
    //fetch user chat list
    var body = await Utils().makeHttpgetRequest('chats');
    if (body != null) {
      message = Message.fromJson(body);
      messages = message.messages;
      filteredNames = messages;
      return messages;
    }
  }

  removeItem(int index) {
    //print("am call to remove the post id "+ index.toString());
    setState(() {
      messages.removeAt(index);
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Chat');
        filteredNames = messages;
        _filter.clear();
      }
    });
  }

  _HomeScreenState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = messages;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        var checker = filteredNames[i];
        if (checker.sender.username
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: messages == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return RecentChat(chat: messages[index]);
      },
    );
  }

  getListView(List<Messages> messages) {
    return 
    
    (messages == null || messages.length <1) ?  Center(child: Text('Search for friend and start chating...')):  Column(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 500.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
            ),
            child: _buildList(),

            /*ListView.builder(
                itemCount: messages == null ? 1 : messages.length,
                itemBuilder: (BuildContext context, int index) {
                return  RecentChat(chat: messages[index],onDelete: ()=>  removeItem(index),) ;*/
            //},
            //),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await fetchChat(),
      renderLoad: () => Loading(),
      renderError: ([error]) => Utils().getNoConnectionWidget(asyncLoaderState),
      renderSuccess: ({data}) => getListView(data),
    );

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: _appBarTitle,
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.userAlt,
              color: Colors.white70,
              size: 20,
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => UserProfile(
                          profileUserID: currentUser.id,
                        ))),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.search,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () {
                  //_searchPressed();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SearchScreen()));
                }),
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: null),
          ],
        ),
        body: Scrollbar(
          child: RefreshIndicator(
              onRefresh: () => _handleRefresh(), child: _asyncLoader),
        ));
  }
}
