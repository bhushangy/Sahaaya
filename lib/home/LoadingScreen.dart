import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';
import 'FactsScreen.dart';


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      getInternetData();
    });

  }

  void getInternetData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FactsScreen();
        }));

      }
    } on SocketException catch (_) {
      //print('not connected');
      Alert(
        context: context,
        type: AlertType.error,
        title: "No Network!!",
        desc: "Please check your Internet connection and restart the app",
        buttons: [
          DialogButton(
            child: Text(
              "Restart",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            width: 120,
          )
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(right:20.0),
          child: Center(
            child: Image.asset(
              'assets/images/voting.png',
              width: 125.0,
              height: 125.0,
            ),
          ),
        ),
      ),
    );
  }
}
