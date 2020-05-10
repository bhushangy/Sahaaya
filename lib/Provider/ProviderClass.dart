import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDown extends ChangeNotifier {

  String consti = 'Yalahanka';
  String email, name, constituency, phone;
  double whichLat = null,
      whichLong = null;
  String a, b, c, d;

  void changeState(String constitu) {
    consti = constitu;
    notifyListeners();
  }

  void map(double a, double b) {
    whichLat = a;
    whichLong = b;
    notifyListeners();
  }

  void setEmail(String e) {
    email = e;
    notifyListeners();
  }

  void setUserInfo(String n, String p, String c) {
    name = n;
    phone = p;
    constituency = c;
    notifyListeners();
  }

  void setAppInfo(String aa, String bb, String cc, String dd) {
    a = aa;
    b = bb;
    c = cc;
    d = dd;
    notifyListeners();
  }
}