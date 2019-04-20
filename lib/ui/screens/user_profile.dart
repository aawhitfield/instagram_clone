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
    Future<String> _getEmail() async {
      FirebaseUser user = await widget.auth.currentUser();
      String _email = user.email;
      return _email;
    }

    return FutureBuilder<Object>(
        future: _getEmail(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              title: Text(
                snapshot.data,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            endDrawer: Drawer(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 16.0),
                    child: ListTile(
                      title: Text(
                        snapshot.data,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.camera),
                          title: Text('Nametag'),
                        ),
                        ListTile(
                          leading: Icon(Icons.bookmark_border),
                          title: Text('Saved'),
                        ),
                        ListTile(
                          leading: Icon(Icons.list),
                          title: Text('Close Friends'),
                        ),
                        ListTile(
                          leading: Icon(Icons.person_add),
                          title: Text('Discover People'),
                        ),
                        ListTile(
                          leading: Icon(Icons.open_in_new),
                          title: Text('Open Facebook'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () async => await widget.auth.signOut(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Log Out',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Center(
              child: Text('User Accounts'),
            ),
          );
        });
  }
}
