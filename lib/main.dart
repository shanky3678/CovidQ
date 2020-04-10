/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : main.dart
Theme : Covid Hackathon

*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protectfuture/screens/covid_q.dart';
import 'package:protectfuture/screens/signup.dart';
import 'package:camera/camera.dart';
import 'screens/welcome_screen.dart';
import 'screens/start.dart';
import 'screens/end_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        initialRoute: WelcomeScreen.id,
        theme: ThemeData.dark().copyWith(unselectedWidgetColor: Colors.black),
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          StartUp.id: (context) => StartUp(),
          PreLoadCovid.id: (context) => PreLoadCovid(),
          EndScreen.id: (context) => EndScreen(),
        });
  }
}
