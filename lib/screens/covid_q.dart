/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : covid_q.dart
Theme : Covid Hackathon
Function :  getCurrentUser(),getRound(),loadList(),getPermission(),getRound(),checkBoxButtonPressed(),buttonPressed(),startVideoRecording(),stopVideoRecording(),storeIntoDatabase(string)

*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../constants.dart';
import '../module/round_rectangle_button.dart';
import '../module/checkbox_button.dart';
import '../module/task.dart';
import 'end_screen.dart';

class PreLoadCovid extends StatelessWidget {
  static String id = 'covid_q';

  @override
  Widget build(BuildContext context) {
    var assetToLoad = "assets/lists.json";
    return FutureBuilder(
      future:
          DefaultAssetBundle.of(context).loadString(assetToLoad, cache: true),
      builder: (context, snapshot) {
        List myData = json.decode(snapshot.data
            .toString()); // Decodes and Fetches the data from json format /asset/lists.json into variable of MyData
        if (myData == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        } else {
          return CovidQ(myData: myData);
        }
      },
    );
  }
}

// ignore: must_be_immutable
class CovidQ extends StatefulWidget {
  var myData;
  CovidQ({Key key, @required this.myData}) : super(key: key);
  @override
  _CovidQState createState() => _CovidQState(myData);
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CovidQState extends State<CovidQ> with WidgetsBindingObserver {
  bool showSpinner = false;
  Position position;
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  FirebaseUser loggedUser;
  var myData;
  bool value = false;
  int i = 1, j = 1;
  _CovidQState(this.myData);
  CameraController controller;
  String imagePath;
  String videoPath;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  List<Task> questions = []; //questions : It holds the list of questions.
  List<String> selected =
      []; //selected : It holds the list of answers that the user chose.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getCurrentUser();
    getPermission();
    storeIntoDatabase('loggedIn');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /*
  * Function Name: getPermission
  * input:         None
  * output:        gets the permission for camera and location*/
  void getPermission() async {
    onCamera();
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  /*
  * Function Name:    getCurrentUser()
  * input:            None
  * output:           Gives out the current users email id
  *
  */
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  /*
  * Function Name:   loadList
  * input:           Takes in a integer
  * output:          Its retrieves questions from json formatted file and stores it in "questions" list
  * logic:           The data in the variable myData is in the form of array ,we can use simple for statement for printing out
  *                  array data and adding it into a list
  *  */
  void loadList(int i) {
    if (i == 5) {
      j = i;
      j++;
      questions = [];
      // for statement
      for (int k = 0; k < myData[1][j.toString()].length; k++) {
        questions
            .add(Task(answerCheckBox: myData[1][j.toString()][k.toString()]));
      }
    } else {
      questions = [];
      for (int k = 0; k < myData[1][i.toString()].length; k++) {
        questions
            .add(Task(answerCheckBox: myData[1][i.toString()][k.toString()]));
      }
    }
  }

  //this a camera widget which shows up in screen (GUI)
  Widget camera({color}) {
    return Container(
      padding: EdgeInsets.only(left: 230.0),
//      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Center(
        child: _cameraPreviewWidget(),
      ),
      color: color,
    );
  }

  /*
  * Function Name:   getRound
  * input:           None
  * output:          Gives out the round
  * summary:         Since there is two parts of questions, First part contains single choice , Second part contains multiple choice
  * */
  Widget getRound() {
    if (i >= 6) {
      return round2();
    } else {
      if (i == 5) {
        loadList(i);
      }
      return round1();
    }
  }

  //Displays round 1 questions to user
  Widget round1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          child: Text(
            myData[0][i.toString()],
            style: kQuestionStyle,
          ),
        ),
        Expanded(
            flex: 1,
            child: camera(
              color: Colors.lightBlueAccent,
            )),
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(top: 50.0),
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return RoundRectangleButton(
                  text: myData[1][i.toString()][index.toString()],
                  padding: EdgeInsets.all(10.0),
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    buttonPressed(myData[1][i.toString()][index.toString()]);
                  },
                  textStyle: kAnswerStyle,
                );
              },
              itemCount: myData[1][i.toString()].length,
            ),
          ),
        ),
      ],
    );
  }

  //Displays round 2 questions to user
  Widget round2() {
    setState(() {});
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          child: Text(
            myData[0][i.toString()],
            style: kQuestionStyle,
          ),
        ),
        Expanded(
            flex: 1,
            child: camera(
              color: Colors.lightBlueAccent,
            )),
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(top: 50.0),
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CustomCheckBoxButton(
                  text: questions[index].answerCheckBox,
                  isChecked: questions[index].isChecked,
                  callBackCheckBoxFunction: (value) {
                    setState(() {
                      questions[index].toggle();
                    });
                    selected.add(questions[index].answerCheckBox);
                  },
                );
              },
              itemCount: questions.length,
            ),
          ),
        ),
        RoundRectangleButton(
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          text: 'Next >>',
          textStyle: kNextStyle,
          onPressed: () {
            setState(() {
              checkBoxButtonPressed();
            });
          },
        ),
      ],
    );
  }

  /*
  * Function Name: buttonPressed()
  * input:         Takes in a String
  * output:        Starts the camera recording ,Stores the response of users in the database and updates the set of questions to user*/
  void buttonPressed(String response) {
    try {
      if (controller == null &&
          !controller.value.isInitialized &&
          position == null) {
        getPermission(); //If camera permission is not provided and also geolocation
      } else if (!controller.value.isRecordingVideo) {
        onVideoRecordButtonPressed(); //Start the camera recording
      } else {
        storeIntoDatabase(
            response); // calls the storeIntoDatabase to store data
        setState(() {
          i++; //incrementing i for next set of questions
        });
      }
    } catch (e) {
      print(e);
    }
  }

  /*
  * Function Name: checkBoxButtonPressed
  * input:         None
  * output:        call the storeIntoDataBase function and updates the database , updates the new set of questions
  *                 and also it terminates to next screen
  * */
  void checkBoxButtonPressed() async {
    if (i < myData[1].length) {
      storeIntoDatabase(selected);
      i++;
      loadList(i); // calls loadList function to load new set of questions
      selected = [];
    } else {
      setState(() {
        showSpinner = true;
      });
      onStopButtonPressed();
    }
  }

  /*
  * Function Name:  storeIntoDatabase
  * input:          Takes in string
  * output:         Stores users response in the database
  * */
  Future storeIntoDatabase(userData) async {
    try {
      var now = DateTime.now();
      position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high); // getting current location
      await _fireStore.collection('userData').add({
        'DateTime': now.toString(),
        'user': loggedUser.email,
        'answer$i': userData,
        'position': position.toString()
      });
    } catch (e) {
      print("location $e");
    }
  }

  //camera functions (GUI)
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        ' ',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

//startVideoRecording this function set the path for recording
  Future<File> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/covidq';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return File(filePath);
  }

  //stopVideoRecording this functions gives out the path of recording
  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return null;
    }

    await _startUpLoading();
  }

  //onVideoRecordButtonPressed  this function starts the video recording
  void onVideoRecordButtonPressed() {
    startVideoRecording().then((File filePath) {
      if (mounted) setState(() {});
    });
  }

  //onStopButtonPressed this function stops the video recording
  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  //onCamera this function checks for camera and camera permissions
  void onCamera() async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameras[1],
      ResolutionPreset.low,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  //_startUpLoading this function uploads the recorded video to firebase
  Future<void> _startUpLoading() async {
    try {
      String fileName = videoPath.split('/').last;
      StorageReference fireBaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask =
          fireBaseStorageRef.putFile(File(videoPath));
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      print("taskSnapshot $taskSnapshot");
      Navigator.pushNamed(context, EndScreen.id);
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print('fileTransfer error $e');
    }
  }

  // The main file of this current screen
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Covid-Q'),
                  content: Text('You Need to complete The Questions.'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'),
                    ),
                  ],
                ));
      },
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: Colors.lightBlueAccent,
          body: SafeArea(child: getRound()),
        ),
      ),
    );
  }
}

List<CameraDescription> cameras = [];
