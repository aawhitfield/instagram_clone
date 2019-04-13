import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Feed extends StatefulWidget {
  final FirebaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  Feed({this.auth, this.onSignedOut, this.userId});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  void _signOut() async {
    await widget.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Feed'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('My Feed'),
              Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: MaterialButton(
                  color: Colors.blue,
                  child: Text('Sign Out'),
                  onPressed: () {
                    _signOut();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
