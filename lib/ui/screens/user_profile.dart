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


    Widget _buildHeader() {

      return Row(
        children: <Widget>[
          Container(
            width: 90.0,
            height: 100.0,
            child: Align(
              alignment: Alignment(-1, 0),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/me.jpg'),
                    radius: 40.0,
                  ),
                  Positioned(
                    top: 50.0,
                    left: 60.0,
                    right: 0.0,
                    child: RawMaterialButton(
                      onPressed: () {},
                      child: new Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.blue,
                      padding: const EdgeInsets.all(0.0),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('176',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0,),
                        Text('Posts',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('520',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0,),
                        Text('Followers',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    Column( children: <Widget>[
                      Text('470',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0,),
                      Text('Following',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],),
                  ],
                ),
                SizedBox(height: 8.0,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Colors.white,
                        child: Text(' Edit Profile'),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }






    Widget _buildBody() {

      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildHeader(),
          ),
        ],
      );
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
            body: _buildBody()
          );
        });
  }
}
