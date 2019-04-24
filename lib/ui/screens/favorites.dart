import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';

class Favorites extends StatefulWidget {

  FirebaseAuth auth;

  Favorites({this.auth});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  final FlareControls flareControls = FlareControls();

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Stack(
        children: <Widget>[
          Align(
            child: Container(
              width: double.infinity,
              height: 550,
              color: Colors.black,
            ),
          ),
          Align(
              child: Image.asset('assets/laptop.jpg')),
          Align(
            child: GestureDetector(
              onDoubleTap: () {
                flareControls.play("like");
              },
              child: Container(
                width: 250,
                height: 250,
                child: FlareActor(
                  'assets/instagram_like.flr',
                  controller: flareControls,
                  animation: 'idle',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}