import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/home/home_page.dart';
import 'package:voter_grievance_redressal/loginpage/LoginPage.dart';
import 'dart:io';
import 'FactsScreen.dart';


class SplashScreen3 extends StatefulWidget {
  @override
  _SplashScreen3State createState() => _SplashScreen3State();
}

class _SplashScreen3State extends State<SplashScreen3> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return home();
      }));
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FlareActor("assets/Sahaaya.flr", alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "Splash"),
    );
  }
}