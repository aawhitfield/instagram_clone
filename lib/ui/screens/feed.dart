import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:recase/recase.dart';
import 'dart:math';

class Feed extends StatefulWidget {
  final FirebaseAuth auth;
  final VoidCallback onSignedOut;

  Feed({this.auth, this.onSignedOut});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String uid;

  void inputData() async {
    final FirebaseUser user = await widget.auth.currentUser();
    setState(() {
      uid = user.uid;
    });
    // here you write the codes to input the data into firestore
  }

  @override
  void initState() {
    super.initState();
    inputData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
              ),
            Text(
              'Instagram',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Amarillo',
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.live_tv,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.send,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(uid)
              .collection('cards')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return FireStoreListView(
              documents: snapshot.data.documents,
            );
          }),
    );
  }
}

class UserStoriesListView extends StatelessWidget {
  int _numberOfStories = 10;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105.0,
      child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: _numberOfStories,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: CircleAvatar(
                backgroundColor: Colors.red,
                maxRadius: 50.0,
              ),
            );
          }),
    );
  }
}

class Story {
  String imageURL;
  String userName;
  String city;
  String state;

  Story({this.imageURL, this.userName, this.city, this.state});
}

class FireStoreListView extends StatefulWidget {
  final List<DocumentSnapshot> documents;

  FireStoreListView({this.documents});

  @override
  _FireStoreListViewState createState() => _FireStoreListViewState();
}

class _FireStoreListViewState extends State<FireStoreListView> {
  List<Story> stories = <Story>[];

  Future<List<Story>> _getStories(int size) async {
    String url = "https://randomuser.me/api/?results=" + '$size';

    var response = await http.get(url);
    Map<String, dynamic> data = await jsonDecode(response.body);

    for (int i = 0; i < size; i++) {
      String _name = data['results'][i]['login']['username'];
      String _picture = data['results'][i]['picture']['medium'];
      String _city =
          ReCase(data['results'][i]['location']['city'].toString()).titleCase;
      String _state =
          ReCase(data['results'][i]['location']['state'].toString()).titleCase;

      Story story = new Story(
        userName: _name,
        imageURL: _picture,
        city: _city,
        state: _state,
      );

      stories.add(story);
    }
    return stories;
  }

  Widget InstagramCard(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(stories[index].imageURL),
                backgroundColor: Colors.transparent,
              ),
              title: Text(
                stories[index].userName,
                style: TextStyle(
                  fontSize: 13.0,
                ),
              ),
              subtitle: Text(
                stories[index].city + ', ' + stories[index].state,
                style: TextStyle(
                  fontSize: 11.0,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.more_vert,
                ),
                onPressed: _showOptions,
              ),
            ),
            Center(
              child: Container(
                child: Image.network(
                  widget.documents[index].data['url'].toString(),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            ListTile(
              leading: Row(
                children: <Widget>[
                  Icon(Icons.favorite_border),
                  SizedBox(
                    width: 16.0,
                  ),
                  Icon(Icons.chat_bubble_outline),
                  SizedBox(
                    width: 16.0,
                  ),
                  Icon(Icons.send),
                ],
              ),
              trailing: Icon(Icons.bookmark_border),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                '${Random().nextInt(168) + 1} likes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                stories[index].userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Text(
                  'Take up one idea. Make that one idea your life - think of it, '
                  'dream of it, live on that idea. Let the brain, muscles, nerves, '
                  'every part of your body, be full of that idea, and just leave '
                  'every other idea alone. This is the way to success.'),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 15.0,
                backgroundImage: NetworkImage(
                    'https://pbs.twimg.com/profile_images/1010928229471809536/beEVHdnf_400x400.jpg'),
              ),
              title: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                    hintText: 'Enter a comment...',
                    hintStyle: TextStyle(
                      fontSize: 12.0,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 0.0, bottom: 16.0),
              child: Text(
                '15 minutes ago',
                style: TextStyle(
                  fontSize: 11.0,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: _getStories(10),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else
            return ListView.builder(
                shrinkWrap: true,
                itemCount: widget.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 105,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: stories.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                    left: 11.0,
                                    right: 0.0),
                                child: Column(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 35.0,
                                      backgroundImage:
                                          NetworkImage(stories[index].imageURL),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      stories[index].userName,
                                      style: TextStyle(
                                        fontSize: 11.0,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        InstagramCard(index),
                      ],
                    );
                  }
                  return InstagramCard(index);
                });
        });
  }

  void _showOptions() async {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Share Link...'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              SimpleDialogOption(
                child: Text('Report...'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              SimpleDialogOption(
                child: Text('Turn On Post Notifications...'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              SimpleDialogOption(
                child: Text('Unfollow...'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              SimpleDialogOption(
                child: Text('Mute...'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        }
    );
  }
}
