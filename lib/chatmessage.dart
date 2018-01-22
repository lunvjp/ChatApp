import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:chat_app/main.dart';

const admin = 'lunvjp@gmail.com';

class ChatMessage extends StatelessWidget {
  final DataSnapshot snapshot;
  final Animation animation;

  final String text;
  final Icon icon;
  final String url;
  final String username;
  bool checkIcon = false; // true: only Icon, false: text + Icon
  final AnimationController animationController;

  ChatMessage ({
    this.text = '',
    this.icon,
    this.url = '',
    this.username,
    this.animationController,
    this.snapshot,
    this.animation
  }) {
    if (this.icon != null && this.text == '') {
      this.checkIcon = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      this.username != admin
      ? new Container(
      margin: const EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 10.0
      ),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new CircleAvatar(
            backgroundImage: new NetworkImage(this.url),
          ),
          new Container(
            margin: checkIcon == false ? const EdgeInsets.symmetric(
              horizontal: 12.0
            ) : null,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new Text(text),
                  this.icon != null ? this.icon : new Text('')
                ],
              ),
            ),
            decoration: checkIcon == false ? new BoxDecoration(
              color: Colors.grey[300],
              borderRadius: new BorderRadius.circular(30.0)
            ) : null,
            padding: checkIcon == false ? new EdgeInsets.all(12.0) : new EdgeInsets.symmetric(horizontal: 12.0),

          )
        ],
      )
    ) :
    new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: this.animationController,
        curve: Curves.ease
      ),
      axisAlignment: 0.0,
      child: new Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 10.0
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end, // vertical
          mainAxisAlignment: MainAxisAlignment.end, // text-aign: right
          children: <Widget>[
            new Container(
              margin: checkIcon == false ? const EdgeInsets.symmetric(
//              horizontal: 12.0,
                horizontal: 1.0
              ) : null,
              child: new Container(
                padding: const EdgeInsets.all(0.0),
                alignment: Alignment.bottomCenter,
                child: new Row(
                  children: <Widget>[
                    new Text(
                      text,
                      style: new TextStyle(
                          color: Colors.white
                      )
                    ),
                    this.icon != null ? this.icon : new Text('')
                  ],
                ),
              ),
              decoration: checkIcon == false ? new BoxDecoration(
                color: const Color(0xFF0084ff), // #0084ff
                borderRadius: new BorderRadius.circular(30.0)
              ) : null,
              padding: checkIcon == false ? new EdgeInsets.all(12.0) : new EdgeInsets.symmetric(horizontal: 1.0),

            ),
            new CircleAvatar(
              backgroundImage: new NetworkImage(this.username == admin ? 'https://lh3.googleusercontent.com/-kKZ097cofhk/AAAAAAAAAAI/AAAAAAAAAAA/AA6ZPT6lQdByaZQ_Dah6W_-SgjJswoni5g/s32-c-mo/photo.jpg' : this.url),
              radius: 6.0,
            ),
          ],
        )
      )
    );
  }
}

/*


 */