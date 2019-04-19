import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/ui/screens/home.dart';
import 'package:firebase_auth_example/ui/screens/login.dart';
import 'package:firebase_auth_example/ui/screens/waiting.dart';

void main() => runApp(MyApp());

FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),

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
          return Waiting();
        } else {
          if (snapshot.hasData) {
            return Navigation(auth: auth,);
          }
          return LoginPage(auth: auth,);
        }
      });
}
