import 'package:flutter/material.dart';
import 'package:chat_app/chatmessage.dart';
import 'package:chat_app/user.dart';
import 'package:chat_app/main.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';



const user = 'LunVjp';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Chatapp',
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  State createState() => new HomePageState();
}

//class HomePageState extends State<HomePage> with TickerProviderStateMixin {
class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final DatabaseReference reference = FirebaseDatabase.instance.reference().child('messages');

  List<ChatMessage> listsMessage = <ChatMessage>[]; // List này sẽ không dùng nữa, thay vào đó là dùng FirebaseAnimatedList
  final TextEditingController _messageController = new TextEditingController();

  bool _checkIconLike = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {                                                //new
    for (ChatMessage message in listsMessage)                           //new
      message.animationController.dispose();                         //new
    super.dispose();                                                 //new
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    // print(user);
    if (user == null)
      user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
      analytics.logLogin();
    }

    if (await auth.currentUser() == null) {                          //new
      GoogleSignInAuthentication credentials =                       //new
      await googleSignIn.currentUser.authentication;                 //new
      await auth.signInWithGoogle(                                   //new
        idToken: credentials.idToken,                                //new
        accessToken: credentials.accessToken,                        //new
      );                                                             //new
    }
  }

  _loadUsers() async {
    String response = await createHttpClient().read('https://randomuser.me/api/?results=25');
    // TODO: 1. Tạo 1 class danh sách chứa các tin nhắn.
//    var result = await JSON.decode(response)['results'].map((obj) => User.fromMap(obj)).toList();
    var result = await JSON.decode(response)['results'];

    List<ChatMessage> newList = <ChatMessage>[];

    for(var i = 0 ; i< result.length; i++) {
      ChatMessage chatMessage = new ChatMessage(
        text: 'Lorem ipsum dolor sit amet',
        url: result[i]['picture']['thumbnail'],
        username: result[i]['login']['username'],
      );
      newList.add(chatMessage);
    }

    setState((){
      listsMessage = newList;
    });
  }

  _checkIconLikeFunction(String text) {
    setState((){
      if (text != '') {
        _checkIconLike = false;
      } else _checkIconLike = true;
    });
  }

  _handleSubmitted(String text) async {
    if (text.trim() != '' && text != null) {
      _messageController.clear();

      await _ensureLoggedIn();

      ChatMessage message = new ChatMessage(
        text: text,
        username: googleSignIn.currentUser.email,
        url: googleSignIn.currentUser.photoUrl,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 300),
          vsync: this
        ),
      );

      setState(() {
        listsMessage.insert(0,message);
        _checkIconLike = true;
      });

      message.animationController.forward();
      analytics.logEvent(name: 'send_message');
    }
  }

  _handleChanged(String text) {
    _checkIconLikeFunction(text);
  }

  _handleLikeClick() async {
    await _ensureLoggedIn();

    ChatMessage likeIcon = new ChatMessage(
      icon: new Icon(
        Icons.thumb_up,
        color: Theme.of(context).accentColor,
        size: 40.0
      ),
      url: googleSignIn.currentUser.photoUrl,
      username: googleSignIn.currentUser.email,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 300),
        vsync: this
      ),
    );

    setState((){
      listsMessage.insert(0,likeIcon);
    });

    likeIcon.animationController.forward();
    analytics.logEvent(name: 'send_message');
  } // const

  Widget _buildText() {
    return new IconTheme(
      data: new IconThemeData(
        color: Theme.of(context).accentColor
      ),
      child: new Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 8.0,
          //          vertical: 10.0
        ),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _messageController,
                decoration: new InputDecoration.collapsed(
                  hintText: 'Type a message'
                ),
                onSubmitted: _handleSubmitted,
                onChanged: _handleChanged,
              )
            ),
            _checkIconLike == true ? new Container(
              child: new IconButton(
                icon: new Icon(Icons.thumb_up),
                onPressed: _handleLikeClick
              )
            ) : new Container(
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmitted(_messageController.text)
              )
            )
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Chatapp'),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(3.0),
              itemBuilder: (_,int index) => listsMessage[index],
              itemCount: listsMessage.length,
              reverse: true,
            ),
          ),
//          new Flexible(
//            child: new FirebaseAnimatedList(
//              query: reference,
//              sort: (a, b) => b.key.compareTo(a.key),                 //new
//              padding: new EdgeInsets.all(8.0),                       //new
//              reverse: true,
//              itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
//                return new ChatMessage(
//                  snapshot: snapshot,
//                  animation: animation,
//                );
//              }
//            )
//          ),
          new Container(
            margin: new EdgeInsets.only(
              top: 10.0
            ),
            child: new Divider(height: 1.0),
          ),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            child: _buildText(),
          ),
        ],
      )
    );
  }
}

/*
new Transform(transform:  new Matrix4.rotationX((3.14/180)*180 * 5),
              alignment: Alignment.center,child: new Icon(Icons.thumb_up)
          )
 */