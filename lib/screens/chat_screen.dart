import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

final _auth = FirebaseAuth.instance;
final _database = Firestore.instance;

class ChatScreen extends StatefulWidget {
  static const id = "chat_screen";

  ChatScreen({this.clickedUser, this.loggedInUser});
  final String clickedUser;
  final FirebaseUser loggedInUser;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textFieldController = TextEditingController();
  String messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡ ${widget.clickedUser}'),
        backgroundColor: Colors.deepPurple[600],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamMessages(
                myEmail: widget.loggedInUser.email,
                hisEmail: widget.clickedUser,
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFieldController,
                      onChanged: (value) {
                        //Do something with the usehir input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      if (messageText != "") {
                        _database.collection('messages').add({
                          'sender': widget.loggedInUser.email,
                          'to': widget.clickedUser,
                          'message': messageText,
                          "time": FieldValue.serverTimestamp(),
                        });
                        messageText = "";
                        textFieldController.clear();
                      }
                    },
                    child: Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreamMessages extends StatelessWidget {
  StreamMessages({this.myEmail, this.hisEmail});
  final String myEmail;
  final String hisEmail;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _database.collection('messages').orderBy("time").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.deepPurple,
            ),
          );
        }
        List<messageBox> messagesList = [];

        final users = snapshot.data.documents.reversed;
        for (var user in users) {
          messageBox messageIs;

          if (myEmail == user.data['sender'] && hisEmail == user.data['to']) {
            messageIs = messageBox(me: true, message: user.data['message']);
            messagesList.add(messageIs);
          } else if (myEmail == user.data['to'] &&
              hisEmail == user.data['sender']) {
            messageIs = messageBox(
              me: false,
              message: user.data['message'],
            );
            messagesList.add(messageIs);
          }
        }
        return ListView(
          reverse: true,
          children: messagesList,
        );
      },
    );
  }
}

class messageBox extends StatelessWidget {
  const messageBox({
    Key key,
    @required this.message,
    @required this.me,
  }) : super(key: key);

  final String message;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
          crossAxisAlignment:
              me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Material(
              borderRadius: me
                  ? BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))
                  : BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
              color: me ? Colors.teal[900] : Colors.blueGrey[700],
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ]),
    );
  }
}
