import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/HomePage/BottomNavBar.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';


class SplashScreen3 extends StatefulWidget {
  @override
  _SplashScreen3State createState() => _SplashScreen3State();
}

class _SplashScreen3State extends State<SplashScreen3> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
  }

  void timer() async {
    Future.delayed(const Duration(milliseconds: 1500), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Provider.of<DropDown>(context, listen: false).setAppInfo(
          packageInfo.appName,
          packageInfo.packageName,
          packageInfo.version,
          packageInfo.buildNumber);
      Provider.of<DropDown>(context, listen: false)
          .setEmail(prefs.getString('email'));
      Provider.of<DropDown>(context, listen: false).setUserInfo(
          prefs.getString('name'),
          prefs.getString('phone'),
          prefs.getString('constituency'));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return BottomNavBar();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: MediaQuery.of(context).size.height*0.5,
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.contain,
              child: Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width*0.8,
                height: MediaQuery.of(context).size.height*0.5,
              ),
            ),),
          Container(
            alignment: Alignment.bottomCenter,
            child: CircularProgressIndicator(
            ),
          )
        ],
      ),
    );
  }
}
