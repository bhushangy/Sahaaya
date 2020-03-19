import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckBox extends ChangeNotifier {

  bool isResolved = false;
  void changeState(bool st){
    isResolved = st;
    notifyListeners();
  }

}
