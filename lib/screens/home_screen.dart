import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

final _auth = FirebaseAuth.instance;
FirebaseUser loggedInUser;

class HomeScreen extends StatefulWidget {
  static const id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _database = Firestore.instance;
  List<Text> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final currentUser = await _auth.currentUser();
      if (currentUser != null) {
        loggedInUser = currentUser;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => onAlertButtonPressed(context),
          ),
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Fast Chat'),
        backgroundColor: Colors.deepPurple[600],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _database.collection('accounts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                }
                List<userBox> usersList = [];
                final users = snapshot.data.documents;
                for (var user in users) {
                  if (loggedInUser.email != user.data['email']) {
                    final userEmail = userBox(user: user.data['email']);
                    usersList.add(userEmail);
                  }
                }
                return Expanded(
                  child: ListView(
                    children: usersList,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class userBox extends StatelessWidget {
  const userBox({
    Key key,
    @required this.user,
  }) : super(key: key);

  final String user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListTile(
        leading: Icon(
          Icons.account_circle,
          size: 40,
        ),
        title: InkWell(
          onTap: () {
            if (user == null) {
              Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.deepPurple,
                ),
              );
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        clickedUser: user, loggedInUser: loggedInUser)));
          },
          child: Text(
            user,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
