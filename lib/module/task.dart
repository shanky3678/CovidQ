/*
Team Id : 1907
Author List : Shashank LK, Akhilesh, P Sumantha Aithal, Amruthkrishna P
Filename : task.dart
Theme : Covid Hackathon

*/
class Task {
  final String answerCheckBox;
  bool isChecked;
  Task({this.answerCheckBox, this.isChecked = false});
  void toggle() {
    isChecked = !isChecked;
  }
}
