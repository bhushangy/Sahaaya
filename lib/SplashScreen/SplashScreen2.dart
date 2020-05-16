import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/HomePage/BottomNavBar.dart';
import 'package:voter_grievance_redressal/Authentication//LoginPage.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'dart:io';
import 'FactsScreen.dart';

class SplashScreen2 extends StatefulWidget {
  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
  }

  void timer() async {
    Future.delayed(const Duration(milliseconds: 1500), () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Provider.of<DropDown>(context, listen: false).setAppInfo(
          packageInfo.appName,
          packageInfo.packageName,
          packageInfo.version,
          packageInfo.buildNumber);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.contain,
                child: Image.asset(
                  'assets/images/logo.png',
                    height:  MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),),
          ),
        ));
  }
}
