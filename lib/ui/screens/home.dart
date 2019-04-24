import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'feed.dart';
import 'user_profile.dart';
import 'add.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


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
  String url;

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


          void takeAndSave() async {
              String url = await _uploadFromCamera();
              print('returned url' + url);
              _updateFeed(url);


          }

          void pickAndSave() async {
            String url = await _uploadFromCameraRoll();
            print('returned url' + url);
            _updateFeed(url);


          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, 'Take New Photo', Icons.camera_alt, takeAndSave),
              _createTile(context, 'Camera Roll', Icons.photo_library, pickAndSave),
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



  Future<String> _uploadFromCamera() async {
    // open camera
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    // save image to temp storage
    final String fileName = "${Random().nextInt(10000)}.jpg";

    Directory directory = await getApplicationDocumentsDirectory(); // AppData folder path
    String appDocPath = directory.path;



    // copy image to path
    File savedImage = await image.copy('$appDocPath/' + fileName);

    // upload file to Firebase Storage
    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask task = ref.putFile(savedImage);

    // ?
    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    try {
      var url = await taskSnapshot.ref.getDownloadURL() as String;
      print('url: ' + url);
      return url;
    } on Exception catch (e) {

      print('exception_error' + e.toString());
    }

    //    _image = image;

    return url;


  }



  Future<String> _uploadFromCameraRoll() async {
    // open camera
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    // save image to temp storage
    final String fileName = "${Random().nextInt(10000)}.jpg";

    Directory directory = await getApplicationDocumentsDirectory(); // AppData folder path
    String appDocPath = directory.path;



    // copy image to path
    File savedImage = await image.copy('$appDocPath/' + fileName);

    // upload file to Firebase Storage
    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask task = ref.putFile(savedImage);

    // ?
    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    try {
      var url = await taskSnapshot.ref.getDownloadURL() as String;
      print('url: ' + url);
      return url;
    } on Exception catch (e) {

      print('exception_error' + e.toString());
    }

    //    _image = image;

    return url;


  }

  Future<void> _updateFeed(String url) async {
    final FirebaseUser user = await widget.auth.currentUser();
    String uid = user.uid;
    print('uid = ' + uid);
    print('input url: ' + url);
      // upload URL to Firebase Firestore Cloud Storage

      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentReference _newPhoto = Firestore.instance.collection('users').document(user.uid);

        await _newPhoto.collection('cards').add({"url" : url});

      });
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