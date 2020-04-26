import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          FactPages(
              index:0,
              img: 'vote0.png',
              txt1: 'VOTE',
              txt2:
                  'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it'),
          FactPages(
              index:1,
              img: 'vote1.png',
              txt1: 'VOTE',
              txt2:
                  'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it'),
          FactPages(
              index:2,
              img: 'vote2.png',
              txt1: 'VOTE',
              txt2:
                  'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it'),
        ],
      ),
    );
  }
}


class FactPages extends StatelessWidget {
  String img, txt1, txt2;
  int index;
  FactPages({this.index,this.img, this.txt1, this.txt2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 120.0),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: AssetImage('assets/images/$img'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 70,
          width: 70,
        ),
        Text(
          '$txt1',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 35.0,
          ),
        ),
        SizedBox(
          height: 70,
          width: 70,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 30,
          child: Text(
            '$txt2',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20.0,
            ),
          ),
        ),
        SizedBox(
          height: 30,
          width: 30,
        ),
        index==2?Column(
          children: <Widget>[
            ButtonTheme(
              minWidth: 300,
              height: 45.0,
              child: RaisedButton(
                onPressed: () {
                  //REGISTER PAGE
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return SignupPage();
                      }
                  ));
                },
                child: Text('Get Started'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.black45,
                textColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 20.0,
              width: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Already have an account?',
                  style: TextStyle(

                    fontSize: 20,
                  ),),
                SizedBox(
                  height: 8.0,
                  width: 8.0,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context){
                          return LoginPage();
                        }
                    ));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
          :Container(),
      ],
    );
  }
}
