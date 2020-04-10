/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : end_screen.dart
Theme : Covid Hackathon

*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../module/round_rectangle_button.dart';
import 'welcome_screen.dart';

class EndScreen extends StatefulWidget {
  static String id = 'endPage';
  @override
  _EndScreenState createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Thank You,\nPlease Login after 3hrs',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 60.0,
              ),
              RoundRectangleButton(
                padding: EdgeInsets.all(30.0),
                text: 'Done',
                textStyle: TextStyle(color: Colors.blue),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    Navigator.popUntil(
                        context, ModalRoute.withName(WelcomeScreen.id));
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
