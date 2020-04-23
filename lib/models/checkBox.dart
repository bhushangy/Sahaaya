import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDown extends ChangeNotifier {


 String consti = 'Yalahanka';
  void changeState(String constitu){
    consti = constitu;
    notifyListeners();
  }

}
