import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

// Alert with single button.
onAlertButtonPressed(context) {
  Alert(
    style: AlertStyle(
        backgroundColor: Colors.blueGrey,
        overlayColor: Colors.black38,
        titleStyle: TextStyle(color: Colors.white),
        descStyle: TextStyle(color: Colors.white)),
    context: context,
    type: AlertType.info,
    title: "About",
    desc: "This is my first Messaging App Using Flutter.\n\n Enjoy =)",
    buttons: [
      DialogButton(
        color: Colors.lightBlue[600],
        child: Text(
          "Close",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}
