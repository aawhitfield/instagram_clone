import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/data/card.dart';

class Feed extends StatefulWidget {
  final FirebaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  Feed({this.auth, this.onSignedOut, this.userId});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  Widget _feedBody() {

    return Center(
      child: ListView(
        children: <Widget>[
          Card(
            child: Image.network(card.url),
          ),
        ],
      ),
    );
  }

  InstaCard card = new InstaCard(url: 'https://images.unsplash.com/photo-1555381983-49b080e6ac89?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1525&q=80');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.camera_alt,
                  color: Colors.black,
                ),
              ),
              Text('Instagram',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Amarillo',
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        body: _feedBody(),
    );
  }
}
