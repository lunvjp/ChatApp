import 'package:flutter/material.dart';
import 'package:chat_app/chatmessage.dart';

class User {
  final String name;
  final String username;
  final String picture;
  List<ChatMessage> listMessage = <ChatMessage>[];

  User({
    this.name,
    this.username,
    this.picture,
    this.listMessage
  });

  static fromMap(Map map) {
    List<ChatMessage> newList = <ChatMessage>[];

    for (var i =0 ;i< 3; i++) {
      var chat_message = new ChatMessage(
        text: 'Lorem ipsum dolor sit amet',
      );
      newList.add(chat_message);
    }

//    User user = new User(
//      name: map['name']['first'] + ' ' + map['name']['last'],
//      username: map['login']['username'],
//      picture: map['picture']['thumbnail'],
//      listMessage: newList
//    );
//
//    print(user);

    return new User(
      name: map['name']['first'] + ' ' + map['name']['last'],
      username: map['login']['username'],
      picture: map['picture']['thumbnail'],
      listMessage: newList
    );
  }
}

/*
      // 'https://lh3.googleusercontent.com/-kKZ097cofhk/AAAAAAAAAAI/AAAAAAAAAAA/AA6ZPT6lQdByaZQ_Dah6W_-SgjJswoni5g/s32-c-mo/photo.jpg'
 */