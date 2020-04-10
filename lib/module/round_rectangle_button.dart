/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : round_rectangle_button.dart
Theme : Covid Hackathon

*/
import 'package:flutter/material.dart';

class RoundRectangleButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Function onPressed;
  final String text;
  final TextStyle textStyle;
  final Color color;
  RoundRectangleButton(
      {@required this.padding,
      this.onPressed,
      this.text,
      this.textStyle,
      this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(30.0),
          elevation: 5.0,
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ));
  }
}
