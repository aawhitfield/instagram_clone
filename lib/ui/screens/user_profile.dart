import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile extends StatefulWidget {
  final FirebaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  UserProfile({this.auth, this.onSignedOut, this.userId});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black,),
        backgroundColor: Colors.white,
        title: Text('User name',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          reverse: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  onPressed: () async => await widget.auth.signOut(),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text('Log Out',
                      textAlign: TextAlign.left,
                      ),
                  ),
                  ),
              ),

          ],
        ),
      ),
      body: Center(
        child: Text('User Accounts'),),
    );
  }
}