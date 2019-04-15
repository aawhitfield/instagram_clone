import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/ui/screens/feed.dart';
import 'package:firebase_auth_example/ui/screens/login.dart';

void main() => runApp(MyApp());

FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData(

        primarySwatch: Colors.blue,

      ),
      home: _handleCurrentScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

Widget _handleCurrentScreen() {
  return new StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(child: new CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            return Feed(auth: auth,);
          }
          return LoginPage(auth: auth,);
        }
      });
}
