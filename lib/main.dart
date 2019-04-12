import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/utils/root_page.dart';
import 'package:firebase_auth_example/ui/screens/feed.dart';

void main() => runApp(MyApp());

FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Blog Reader',
      theme: ThemeData(

        primarySwatch: Colors.blue,

      ),
      home: RootPage(auth: auth,),
      routes: {
        '/root' : (context) => RootPage(auth: auth,),
        '/feed' : (context) => Feed(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

