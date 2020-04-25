import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDown extends ChangeNotifier {


 String consti = 'Yalahanka';
 double whichLat=null,whichLong=null;
  void changeState(String constitu){
    consti = constitu;
    notifyListeners();
  }
  void map(double a,double b)
  {
    whichLat=a;
    whichLong=b;
    notifyListeners();
  }

}
