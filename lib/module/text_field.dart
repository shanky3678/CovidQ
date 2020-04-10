/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : text_field.dart
Theme : Covid Hackathon

*/
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool obscureText;
  final String text;
  final Function onPressed;
  final Widget suffixIconChild;
  final Icon icon;
  final TextInputType keyboardType;
  final Color fillColor;

  final Function onChanged;
  CustomTextField(
      {@required this.padding,
      this.onPressed,
      this.suffixIconChild,
      this.icon,
      this.fillColor,
      this.keyboardType,
      this.onChanged,
      @required this.obscureText,
      this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
              fillColor: fillColor,
              filled: true,
              hintText: text,
              suffixIcon: MaterialButton(
                minWidth: 10.0,
                onPressed: onPressed,
                child: suffixIconChild,
              ),
              icon: icon)),
    );
  }
}
