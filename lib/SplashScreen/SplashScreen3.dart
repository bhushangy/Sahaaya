import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/HomePage/BottomNavBar.dart';
import 'package:voter_grievance_redressal/Authentication//LoginPage.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_){
        timer();
    });
  }
  void timer()async {
    Future.delayed(const Duration(milliseconds: 3500), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Provider.of<DropDown>(context,listen: false).setAppInfo(packageInfo.appName, packageInfo.packageName, packageInfo.version, packageInfo.buildNumber);
      Provider.of<DropDown>(context,listen: false).setEmail(prefs.getString('email'));
      Provider.of<DropDown>(context,listen: false).setUserInfo(prefs.getString('name'),prefs.getString('phone'),prefs.getString('constituency'));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return BottomNavBar();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo,
      statusBarIconBrightness: Brightness.light,
    ));
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            child: Center(
              child: Text('Sahaaya'),
            ),
          ),
          Container(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}