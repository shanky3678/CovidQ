/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : checkbox_button.dart
Theme : Covid Hackathon

*/
import 'package:flutter/material.dart';
import '../constants.dart';

class CustomCheckBoxButton extends StatelessWidget {
  final bool isChecked;
  final String text;
  final Function callBackCheckBoxFunction;
  CustomCheckBoxButton(
      {this.isChecked, this.text, this.callBackCheckBoxFunction});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(unselectedWidgetColor: Colors.black),
      child: CheckboxListTile(
        title: Text(
          text,
          style: kAnswerStyle,
        ),
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: callBackCheckBoxFunction,
      ),
    );
  }
}
