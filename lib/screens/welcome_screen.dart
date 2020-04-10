/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : welcome_screen.dart
Theme : Covid Hackathon

*/
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protectfuture/module/hidden.dart';
import '../module/round_rectangle_button.dart';
import 'signup.dart';
import '../constants.dart';
import '../module/text_field.dart';
import 'start.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool showSpinner = false;
  Hidden hidden = Hidden();
  String email;
  String password;
  String loginError = ' ';
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child:
              ListView(padding: EdgeInsets.only(top: 80.0), children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Hero(
                            tag: 'logo',
                            child: Image(
                              height: 40.0,
                              image: AssetImage('images/logo.png'),
                            ),
                          ),
                          Text(
                            'Covid-Q',
                            style: kHeadTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text(
                      'Save the Future India',
                      style: TextStyle(
                        color: Colors.white30,
                        fontSize: 20.0,
                        fontFamily: 'SourceCode',
                      ),
                    ),
                  ),
                  Divider(
                    indent: 120.0,
                    endIndent: 120.0,
                    thickness: 1.5,
                    color: Colors.white30,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: TextField(
                          onChanged: (value) {
                            email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: 'Email',
                              icon: Icon(Icons.email))),
                    ),
                  ),
                  Container(
                      child: CustomTextField(
                    onChanged: (value) {
                      password = value;
                    },
                    padding: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                    onPressed: () {
                      setState(() {
                        hidden.visible();
                      });
                    },
                    icon: Icon(Icons.person_pin),
                    obscureText: hidden.visibilityOff,
                    text: 'Password',
                    suffixIconChild: hidden.eyeImage,
                  )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    loginError,
                    style: TextStyle(color: Colors.red),
                  ),
                  RoundRectangleButton(
                    text: 'Login',
                    color: Colors.blueAccent,
                    padding: EdgeInsets.only(top: 50.0, bottom: 5.0),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final loginUser =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (loginUser != null) {
                          Navigator.pushNamed(context, StartUp.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                          loginError =
                              'Your Email or Password Doesn\'t Match! ';
                        });
                        print(e);
                      }
                    },
                  ),
                  Divider(
                    indent: 150.0,
                    endIndent: 150.0,
                    thickness: 1.5,
                    color: Colors.white30,
                  ),
                  Text(
                    'or',
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 20.0,
                      fontFamily: 'SourceCode',
                    ),
                  ),
                  RoundRectangleButton(
                    text: 'Sign Up',
                    color: Colors.green,
                    padding: EdgeInsets.only(top: 10.0),
                    onPressed: () {
                      setState(() {
                        loginError = ' ';
                      });
                      Navigator.pushNamed(context, SignUpScreen.id);
                    },
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
