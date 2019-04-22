import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'feed.dart';
import 'user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Navigation extends StatefulWidget
{
  final FirebaseAuth auth;
  final VoidCallback onSignedOut;

  Navigation({this.auth, this.onSignedOut});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 4;
  var _widgetOptions = [];

  @override
  void initState() {
    super.initState();

    _widgetOptions = [
      Feed(auth: widget.auth),
      Text('Search'),
      Text('Add'),
      Text('Favorites'),
      UserProfile(auth: widget.auth,),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text(''),
            ),
          ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}