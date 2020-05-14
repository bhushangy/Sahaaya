import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'dart:io';
import 'FactsScreen.dart';


class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();

    });
  }
  void timer()async{
    Future.delayed(const Duration(milliseconds: 3000), () async{
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Provider.of<DropDown>(context,listen: false).setAppInfo(packageInfo.appName, packageInfo.packageName, packageInfo.version, packageInfo.buildNumber);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return FactsScreen();
      }));
    });
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return  Scaffold(
      backgroundColor: Colors.white,
      body: FlareActor("assets/SplashScreen/SplashScreen1.flr", alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "Splash"),
    );
  }
}