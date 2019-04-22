import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Add {


}

class AddWidget extends StatefulWidget {
  NavigationState parent;

  AddWidget({this.parent});

  @override
  _AddWidgetState createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {

  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.parent.setState((){
        widget.parent.selectedIndex = 0;
      });
    });

    return Container();
  }

}