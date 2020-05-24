import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/Authentication//PostSignUp.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool showPassword;
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final databaseReference = Firestore.instance;
  FirebaseUser newUser;
  int i=0;


  void initState() {
    super.initState();
    setState(() {
      showPassword = false;
      email = '';
      password = '';
    });
    getConnectivityStatus();
  }

  void _showDialog(
    String a,
    String b,
  ) {
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
  Future<bool>dontgoback(){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*6.2,SizeConfig.safeBlockHorizontal*2,
              SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*2),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Terminate Signup",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize:SizeConfig.safeBlockHorizontal*5),
          ),
          content: Text(
            "Do you want to delete your account ?",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize:SizeConfig.safeBlockHorizontal*4
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" YES",style: TextStyle(
                  fontSize:SizeConfig.safeBlockHorizontal*3.5
              ),),
              onPressed: () {
                newUser.delete();
                newUser=null;
                Navigator.pop(context, true);

              },
            ),
            new FlatButton(
              child: new Text(" NO",style: TextStyle(
                  fontSize:SizeConfig.safeBlockHorizontal*3.5
              ),),
              onPressed: () {
                Navigator.pop(context,false);
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
    return WillPopScope(
      onWillPop: newUser==null?() async => true :dontgoback,
      child: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: ModalProgressHUD(
                  inAsyncCall: showSpinner,
                  child: ListView(children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: SizeConfig.safeBlockHorizontal * 93,
                                padding: EdgeInsets.fromLTRB(
                                    0,
                                    SizeConfig.safeBlockVertical * 9,
                                    SizeConfig.safeBlockHorizontal * 47,
                                    0),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'Sign',
                                    style: GoogleFonts.montserrat(
                                      fontSize: SizeConfig.safeBlockHorizontal * 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: SizeConfig.safeBlockHorizontal * 49,
                                padding: EdgeInsets.fromLTRB(
                                    SizeConfig.safeBlockHorizontal * 17,
                                    SizeConfig.safeBlockVertical * 21.5,
                                    0,
                                    0),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: 'Up',
                                        style: GoogleFonts.montserrat(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal * 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: '.',
                                        style: GoogleFonts.montserrat(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal * 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.indigo),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical * 5,
                              left: SizeConfig.safeBlockHorizontal * 5,
                              right: SizeConfig.safeBlockHorizontal * 5),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.indigo,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.indigo),
                                  ),
                                  labelText: 'EMAIL',
                                  labelStyle: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    color: Colors.grey,
                                  ),
                                ),
                                onChanged: (value) {
                                  email = value;
                                },
                              ),
                              SizedBox(
                                height: SizeConfig.safeBlockVertical * 6,
                              ),
                              TextField(
                                obscureText: !showPassword,
                                cursorColor: Colors.indigo,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.grey,
                                      size: SizeConfig.safeBlockHorizontal * 6,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        showPassword == false
                                            ? showPassword = true
                                            : showPassword = false;
                                      });
                                    },
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.indigo),
                                  ),
                                  labelText: 'PASSWORD',
                                  labelStyle: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    color: Colors.grey,
                                  ),
                                ),
                                onChanged: (value) {
                                  password = value;
                                },
                              ),
                              SizedBox(
                                height: SizeConfig.safeBlockVertical * 8,
                              ),
                              Container(
                                height: SizeConfig.safeBlockVertical * 7,
                                child: InkWell(
                                  onTap: () async {
                                    if(i!=0)
                                      _showDialog("Signup Done ", "Please click on verify email");

                                    else if (email == null || password == null) {
                                      _showDialog(
                                          "Fields empty", "Please fill all fields.");

                                    } else if (email.trim() == '' ||
                                        password.trim() == '') {
                                      _showDialog(
                                          "Fields empty", "Please fill all fields.");

                                    }

                                    else {
                                      setState(() {
                                        showSpinner = true;
                                      });

                                      try {
                                        newUser = (await _auth
                                            .createUserWithEmailAndPassword(
                                                email: email, password: password)).user;
                                        try {
                                          await newUser.sendEmailVerification();
                                          i++;

                                        } catch (e) {
                                          print("An error occured while trying to send email verification");
                                          print(e.message);
                                        }

                                        setState(() {
                                          showSpinner = false;
                                        });
                                        _showDialog("Verification Link Sent", "Please click on the link sent to your mail and click on verify email button below.");

                                      } on PlatformException catch (e) {
                                        print(e);
                                        setState(() {
                                          showSpinner = false;
                                        });
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (context) {
                                              return SignupPage();
                                            }));

                                        switch (e.code) {
                                          case "ERROR_EMAIL_ALREADY_IN_USE":
                                            {
                                              _showDialog("Invalid Email",
                                                  "Email already exists.Please Log In.");
                                            }
                                            break;
                                          case "ERROR_INVALID_EMAIL":
                                            {
                                              _showDialog("Invalid Email",
                                                  "Email is in Invalid format.Please Retry.");
                                            }
                                            break;
                                          case "ERROR_WEAK_PASSWORD":
                                            {
                                              _showDialog("Password Weak",
                                                  "Password should consist of minimum 6 characters.");
                                            }
                                            break;
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
                                          'REGISTER',
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal * 4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.safeBlockVertical * 5,
                              ),
                              Container(
                                height: SizeConfig.safeBlockVertical * 7,

                                child: InkWell(
                                  onTap: () async{
                                    if(newUser==null)
                                      _showDialog("Signup Error", "Please Register First.");
                                    else{
                                      setState(() {
                                        showSpinner=true;
                                      });
                                      newUser = (await  _auth.signInWithEmailAndPassword(email: email, password:password)).user;
                                      if(newUser.isEmailVerified){
                                        if (newUser != null) {
                                          await databaseReference
                                              .collection("UserInfo")
                                              .document(email)
                                              .setData({
                                            'Name': null,
                                            'Email': email,
                                            'Phone': null,
                                            'Constituency': null,
                                          });
                                          Provider.of<DropDown>(context,
                                              listen: false)
                                              .setEmail(email);
                                          SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                          prefs.setString('email', email);
                                          prefs.setString('name', null);
                                          prefs.setString('phone', null);
                                          prefs.setString('constituency', null);
                                          prefs.setInt('i', 1);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PostSignUp(
                                                  email: email,
                                                )),
                                          );
                                        }
                                        setState(() {
                                          showSpinner=false;
                                        });
                                      }

                                      else
                                      {
                                        setState(() {
                                          showSpinner=false;
                                        });

                                        _showDialog("Email not Verified", "Please click on the verification link sent to your email.");
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
                                        'VERIFY EMAIL',
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize:
                                          SizeConfig.safeBlockHorizontal * 4,
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
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        SizedBox(
                          //this box comes into effect only when the keyboard is up and when keyboard closes it will disappear
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
      ),
    );
  }
}
