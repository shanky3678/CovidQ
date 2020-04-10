/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : signup.dart
Theme : Covid Hackathon

*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';

import '../module/hidden.dart';
import '../module/text_field.dart';
import '../module/round_rectangle_button.dart';

class SignUpScreen extends StatefulWidget {
  static String id = 'register_screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showSpinner = false;
  String fieldError = ' ';
  String imageError = ' ';
  String positionError = ' ';
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  Hidden hidden = Hidden();
  String name, email, password, address, number, age;
  Color passwordError = Colors.white30;
  File _image;
  Position position;

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, left: 15.0, right: 15.0),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 60.0,
                            child: FlatButton(
                              padding: EdgeInsets.all(30.0),
                              onPressed: () {
                                getImage();
                              },
                              child: _image == null
                                  ? Icon(
                                      Icons.person_add,
                                      size: 40.0,
                                    )
                                  : Image.file(
                                      _image,
                                      height: 100.0,
                                      width: 100.0,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          CustomTextField(
                            padding: EdgeInsets.only(top: 30.0),
                            text: 'Name',
                            icon: Icon(Icons.person),
                            obscureText: false,
                            onChanged: (value) {
                              name = value;
                            },
                          ),
                          CustomTextField(
                            keyboardType: TextInputType.multiline,
                            padding: EdgeInsets.only(top: 10.0),
                            text: 'Address',
                            icon: Icon(Icons.my_location),
                            obscureText: false,
                            onChanged: (value) {
                              address = value;
                            },
                          ),
                          CustomTextField(
                            keyboardType: TextInputType.phone,
                            padding: EdgeInsets.only(top: 10.0),
                            text: 'Phone',
                            icon: Icon(Icons.phone),
                            obscureText: false,
                            onChanged: (value) {
                              number = value;
                            },
                          ),
                          CustomTextField(
                            keyboardType: TextInputType.datetime,
                            padding: EdgeInsets.only(top: 10.0),
                            text: 'Age',
                            icon: Icon(Icons.person),
                            obscureText: false,
                            onChanged: (value) {
                              age = value;
                            },
                          ),
                          CustomTextField(
                            padding: EdgeInsets.only(top: 10.0),
                            text: 'Email',
                            icon: Icon(Icons.email),
                            obscureText: false,
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                          CustomTextField(
                            padding: EdgeInsets.only(top: 10.0),
                            text: 'Password',
                            icon: Icon(Icons.person_pin),
                            suffixIconChild: hidden.eyeImage,
                            obscureText: hidden.visibilityOff,
                            onChanged: (value) {
                              password = value;
                            },
                            onPressed: () {
                              setState(() {
                                hidden.visible();
                              });
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Password must contain >=8 characters',
                            style: TextStyle(color: passwordError),
                          ),
                          Text(
                            fieldError,
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            imageError,
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            positionError,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          RoundRectangleButton(
                            text: 'Create',
                            padding: EdgeInsets.all(20.0),
                            color: Colors.green,
                            onPressed: () async {
                              if (email != null &&
                                  password != null &&
                                  age != null &&
                                  number != null &&
                                  _image != null &&
                                  address != null &&
                                  name != null &&
                                  password.length >= 8) {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  position = await Geolocator()
                                      .getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.high);
                                  final newUser = await _auth
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  if (newUser != null && position != null) {
                                    final userInfo = await _firestore
                                        .collection('signUp_Details')
                                        .add({
                                      'image': _image.toString(),
                                      'name': name,
                                      'address': address,
                                      'phone': number,
                                      'email': email,
                                      'age': age,
                                      'position': position.toString()
                                    });
                                    String fileName = basename(_image.path);
                                    StorageReference fireBaseStorageRef =
                                        FirebaseStorage.instance
                                            .ref()
                                            .child(fileName);
                                    StorageUploadTask uploadTask =
                                        fireBaseStorageRef.putFile(_image);
                                    StorageTaskSnapshot taskSnapshot =
                                        await uploadTask.onComplete;
                                    if (newUser != null && userInfo != null) {
                                      Navigator.pop(context);
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    } else {
                                      positionError = 'Please enable Location';
                                    }
                                  }
                                } catch (e) {
                                  setState(() {
                                    showSpinner = false;
                                    fieldError =
                                        'Username Already Exists or Your Email is Invaild. ';
                                    imageError = ' ';
                                    positionError = 'Please enable Location';
                                  });
                                  print(e);
                                }
                              } else {
                                setState(() {
                                  fieldError = 'Some Fields are Empty';
                                  passwordError = Colors.red;
                                });
                                if (_image == null) {
                                  setState(() {
                                    imageError = 'Please add your pic';
                                  });
                                } else {
                                  imageError = " ";
                                }
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
