/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : hidden.dart
Theme : Covid Hackathon

*/
import 'package:flutter/material.dart';

class Hidden {
  var visibilityOff = true;
  Icon eyeImage = Icon(Icons.visibility_off);
  void visible() {
    if (visibilityOff == true) {
      eyeImage = Icon(Icons.visibility);
      visibilityOff = false;
    } else {
      eyeImage = Icon(Icons.visibility_off);
      visibilityOff = true;
    }
  }
}
