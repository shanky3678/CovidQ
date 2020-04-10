/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : start.dart
Theme : Covid Hackathon

*/
import 'package:flutter/material.dart';

import '../module/round_rectangle_button.dart';
import 'covid_q.dart';

class StartUp extends StatefulWidget {
  static String id = 'startUp';
  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  TextStyle startUpPageFontStyle =
      TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to CovidQ Test',
                textAlign: TextAlign.center,
                style: startUpPageFontStyle,
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                'Instructions',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '1.) All Questions to be answered in detail\n2.) Adjust your face properly to the frame.\n3.) The location feature needs to be enabled on your device.\n4.) For further queries contact on the below given helpline number.\n5.) Thank you for cooperating with us',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25.0),
              ),
              RoundRectangleButton(
                padding: EdgeInsets.all(30.0),
                text: 'Start',
                textStyle: TextStyle(color: Colors.blue),
                color: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, PreLoadCovid.id);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
