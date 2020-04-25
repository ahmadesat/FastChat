import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/authInputs//rounded_button.dart';
import 'package:flash_chat/authInputs/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool _loading = false;

  String email;
  String password;

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
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kInputDecoration(
                  hintText: "Enter Your Email",
                  colour: Colors.purple[800],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kInputDecoration(
                  hintText: "Enter Your Password",
                  colour: Colors.purple[800],
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  try {
                    final currentUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    print("HAHA");
                    if (currentUser != null) {
                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                    }
                    setState(() {
                      _loading = false;
                    });
                  } catch (e) {
                    print("something is wrong");
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                text: "Log In",
                colour: Colors.purple[800],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
