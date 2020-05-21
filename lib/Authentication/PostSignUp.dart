import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/HomePage/BottomNavBar.dart';
import 'package:voter_grievance_redressal/HomePage/HomePage.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

class PostSignUp extends StatefulWidget {
  String email;
  PostSignUp({this.email});
  @override
  _PostSignUpState createState() => _PostSignUpState();
}

class _PostSignUpState extends State<PostSignUp> {
  final databaseReference = Firestore.instance;
  String name;
  final _formKey = GlobalKey<FormState>();
  int phone;
  String constituency;
  bool showSpinner = false;

  void initState(){
    super.initState();
    getConnectivityStatus();
  }


  void _showDialog(
    String a,
    String b,
  ) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(
              SizeConfig.safeBlockHorizontal * 6.2,
              SizeConfig.safeBlockHorizontal * 2,
              SizeConfig.safeBlockHorizontal * 4,
              SizeConfig.safeBlockHorizontal * 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: new Text(
            a,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 5),
          ),
          content: new Text(
            b,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.normal,
              fontSize: SizeConfig.safeBlockHorizontal * 4,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                " OK",
                style:
                    TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void  getConnectivityStatus()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      }
    } on SocketException catch (_) {
      _showDialog("No Internet!", "Please check your internet connection.");
    }
  }
  Future<bool> dontgoback() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(
              SizeConfig.safeBlockHorizontal * 6.2,
              SizeConfig.safeBlockHorizontal * 2,
              SizeConfig.safeBlockHorizontal * 4,
              SizeConfig.safeBlockHorizontal * 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Exit",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 5),
          ),
          content: Text(
            "Do you want to exit the app ?",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 4),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                " YES",
                style:
                    TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
            new FlatButton(
              child: new Text(
                " NO",
                style:
                    TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: dontgoback,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          child: Stack(
                        children: <Widget>[
                          Container(
                            width: SizeConfig.safeBlockHorizontal * 93,
                            padding: EdgeInsets.fromLTRB(
                                0,
                                SizeConfig.safeBlockVertical * 6,
                                SizeConfig.safeBlockHorizontal * 40,
                                0),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Hello',
                                style: GoogleFonts.montserrat(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Container(
                            width: SizeConfig.safeBlockHorizontal * 60,
                            padding: EdgeInsets.fromLTRB(
                                0, SizeConfig.safeBlockVertical * 16, 0, 0),
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: 'there',
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '.',
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.indigo),
                                    ),
                                  ]),
                                )),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical * 4,
                            left: SizeConfig.safeBlockHorizontal * 5,
                            right: SizeConfig.safeBlockHorizontal * 5),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextField(
                                cursorColor: Colors.indigo,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.indigo),
                                  ),
                                  labelText: 'NAME',
                                  labelStyle: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 4,
                                    color: Colors.grey,
                                  ),
                                ),
                                onChanged: (value) {
                                  name = value;
                                },
                              ),
                              SizedBox(
                                height: SizeConfig.safeBlockVertical * 5,
                              ),
                              TextField(
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  phone = int.parse(value);
                                },
                                cursorColor: Colors.indigo,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.indigo),
                                  ),
                                  labelText: 'PHONE',
                                  labelStyle: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 4,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.safeBlockVertical * 5,
                              ),
                              TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                onChanged: (value) {
                                  constituency = value;
                                },
                                cursorColor: Colors.indigo,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.indigo),
                                  ),
                                  labelText: 'CONSTITUENCY',
                                  labelStyle: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 4,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.safeBlockVertical * 10,
                              ),
                              Container(
                                height: SizeConfig.safeBlockVertical * 7,
                                child: InkWell(
                                  onTap: () async {
                                    if (name == null ||
                                        constituency == null ||
                                        phone == null) {
                                      _showDialog("Fields empty",
                                          "Please fill all fields.");
                                    } else if (name.trim() == '' ||
                                        constituency.trim() == '') {
                                      _showDialog("Fields empty",
                                          "Please fill all fields.");
                                    } else {
                                      if (phone.toString().length != 10) {
                                        _showDialog("Invalid Phone Number",
                                            "Enter a valid 10 digit phone number.");
                                      } else {
                                        setState(() {
                                          showSpinner = true;
                                        });
                                        try {
                                          await databaseReference
                                              .collection("UserInfo")
                                              .document(widget.email)
                                              .updateData({
                                            'Name': name.trim(),
                                            'Phone': phone,
                                            'Constituency': constituency.trim(),
                                          });
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setString('name', name.trim());
                                          prefs.setString(
                                              'phone', phone.toString().trim());
                                          prefs.setString('constituency',
                                              constituency.trim());
                                          Provider.of<DropDown>(context,
                                                  listen: false)
                                              .setUserInfo(
                                                  name.trim(),
                                                  phone.toString().trim(),
                                                  constituency.trim());
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                              builder: (context) => BottomNavBar()
                                          ), ModalRoute.withName("/"));
                                          setState(() {
                                            showSpinner = false;
                                          });
                                        } catch (e) {
                                          print(e);
                                          setState(() {
                                            showSpinner = false;
                                          });
                                        }
                                      }
                                    }
                                  },
                                  child: Material(
                                    color: Colors.indigo,
                                    borderRadius: BorderRadius.circular(30.0),
                                    shadowColor: Colors.indigo,
                                    elevation: 5.0,
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'DONE',
                                          style: GoogleFonts.montserrat(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    4,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom / 2,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
