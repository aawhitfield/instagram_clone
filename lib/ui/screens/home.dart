import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'feed.dart';
import 'user_profile.dart';
import 'add.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Navigation extends StatefulWidget
{
  final FirebaseAuth auth;
  final VoidCallback onSignedOut;

  Navigation({this.auth, this.onSignedOut});

  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  int selectedIndex = 0;
  var _widgetOptions = [];
  File _image;

  void onItemTapped(int index) {
    setState(() {
      if(index != 2)
        {
          selectedIndex = index;
        }
    });
  }

  @override
  void initState() {
    super.initState();

    _widgetOptions = [
      Feed(auth: widget.auth),
      Text('Search'),
      AddWidget(parent: this,),
      Text('Favorites'),
      UserProfile(auth: widget.auth,),
    ];
  }



  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, 'Take New Photo', Icons.camera_alt, takeImage),
              _createTile(context, 'Camera Roll', Icons.photo_library, getCameraRoll),
              _createTile(context, "Cancel", Icons.cancel, null,),
            ],
          );
        });
  }

  ListTile _createTile(BuildContext context, String name, IconData icon, Function action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  Future takeImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    final FirebaseUser user = await widget.auth.currentUser();
    String uid = user.uid;
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('users').document(uid).collection('cards');
      
//      await reference.add({)
    });
    _image = image;


  }

  Future getCameraRoll() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);


    _image = image;

  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
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
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
      
      floatingActionButton: FloatingActionButton(
          onPressed: () => mainBottomSheet(context),
          backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }



}