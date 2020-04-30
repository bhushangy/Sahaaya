import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:voter_grievance_redressal/loginpage/LoginPage.dart';
import 'package:voter_grievance_redressal/loginpage/SignupPage.dart';

import 'GetInfo.dart';

class FactsScreen extends StatefulWidget {
  @override
  _FactsScreenState createState() => _FactsScreenState();
}

class _FactsScreenState extends State<FactsScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  void initState() {
    super.initState();
    getInternetData();
    //TODO --> Ashwitha
//    Future<String> res = UserDetails().checkInternetStatus();
//    if (res == "Active"){
//
//    }else{
//      Alert(
//        context: context,
//        type: AlertType.error,
//        title: "No Network!!",
//        desc: "Please check your Internet connection and restart the app",
//        buttons: [
//          DialogButton(
//            child: Text(
//              "Restart",
//              style: TextStyle(color: Colors.white, fontSize: 20),
//            ),
//            onPressed: () =>
//                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
//            width: 120,
//          )
//        ],
//      ).show();
//    }
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getInternetData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          FactPages(
              index: 0,
              img: 'angry.png',
              txt:
                  'Have issues in your neighborhood that need to be addressed ?'),
          FactPages(
              index: 1,
              img: 'report.png',
              txt:
                  'Report it here using the Sahaaya app to the concerned authority.'),
          FactPages(
              index: 2,
              img: 'ranking.png',
              txt: 'See where your constituency stands.'),
        ],
      ),
    );
  }
}

class FactPages extends StatelessWidget {
  String img, txt;
  int index;
  FactPages({this.index, this.img, this.txt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25),
          child: Container(
            width: MediaQuery.of(context).size.width*0.4,
            height: MediaQuery.of(context).size.width*0.4 ,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/FactsScreen/$img'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          height:  MediaQuery.of(context).size.width*0.16,
        ),
        Flexible(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              '$txt',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize: 20.0, fontWeight: FontWeight.normal)
            ),
          ),
        ),
        SizedBox(
          height:  MediaQuery.of(context).size.width*0.15,
        ),
        index == 2
            ? Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.height*0.07,
                    child: InkWell(
                      onTap: () =>  Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          })),
                      child: Material(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(5.0),
                        shadowColor: Colors.black38,
                        elevation: 10.0,
                        child: Center(
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
