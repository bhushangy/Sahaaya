import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/HomePage/BottomNavBar.dart';
import 'package:voter_grievance_redressal/HomePage/HomePage.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

import 'SignupPage.dart';

final databaseReference = Firestore.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email='';
  String password='';
  bool showSpinner = false;
  DocumentSnapshot doc;

  void initState() {
    super.initState();
    //print(MediaQuery.of(context).size);
    setState(() {
      showPassword = false;
    });
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
          contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*6.2,SizeConfig.safeBlockHorizontal*2,
              SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*2),
          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(10),
          ),
          title: new Text(a,style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize:SizeConfig.safeBlockHorizontal*5),),
          content: new Text(b,style: GoogleFonts.montserrat(
            fontWeight: FontWeight.normal,
            fontSize:SizeConfig.safeBlockHorizontal*4,
            color: Colors.black,
          ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" OK",style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal*3.5
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<bool> dontgoback() {
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
            "Exit",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: Colors.black,fontSize:SizeConfig.safeBlockHorizontal*5),
          ),
          content: Text(
            "Do you want to exit the app ?",
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
                SystemNavigator.pop();
              },
            ),
            new FlatButton(
              child: new Text(" NO",style: TextStyle(
                  fontSize:SizeConfig.safeBlockHorizontal*3.5
              ),),
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
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
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
                              width: SizeConfig.safeBlockHorizontal*93,
                              padding: EdgeInsets.fromLTRB(0, SizeConfig.safeBlockVertical * 7, SizeConfig.safeBlockHorizontal * 55, 0),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  'Log',
                                  style: GoogleFonts.montserrat(
                                      fontSize:SizeConfig.safeBlockHorizontal*20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Container(
                              width: SizeConfig.safeBlockHorizontal*40,
                              padding:
                              EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 16,SizeConfig.safeBlockVertical * 18.5,0, 0),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text:'In', style: GoogleFonts.montserrat(
                                          fontSize:SizeConfig.safeBlockHorizontal*20,
                                          fontWeight: FontWeight.w600,color: Colors.black),),
                                      TextSpan(text:'.',style: GoogleFonts.montserrat(
                                          fontSize:SizeConfig.safeBlockHorizontal*20,
                                          fontWeight: FontWeight.w600,color: Colors.indigo),),
                                    ]
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 1,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical * 8,
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
                              onChanged: (value) {
                                password = value;
                              },
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
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical * 2,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical * 3,
                                  left: SizeConfig.safeBlockHorizontal * 56),
                              child: InkWell(
                                onTap: () async {



                                    setState(() {
                                      showSpinner = true;
                                    });
                                    try {
                                      await _auth.sendPasswordResetEmail(
                                          email: email);
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      _showDialog("Password Reset",
                                          "Password reset link sent to your email.");
                                    } on PlatformException catch (e) {
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      switch (e.code) {
                                        case ("ERROR_USER_NOT_FOUND"):
                                          {
                                            _showDialog("Invalid Email",
                                                "Enter valid Email or Sign Up.");
                                          }
                                          break;
                                        case "ERROR_INVALID_EMAIL":
                                          {
                                            _showDialog("Invalid Email",
                                                "Email is in Invalid format. Please Retry.");
                                          }
                                          break;
                                        case "":
                                          {
                                            _showDialog("Fields empty", "Please fill all fields.");

                                          }
                                          break;


                                        default:
                                          {
                                            _showDialog("Fields empty", "Please fill all fields.");

                                          }
                                      }
                                    }


                                },
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'Forgot Password',
                                    style: GoogleFonts.montserrat(
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.8,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.indigo,
                                        decoration: TextDecoration.underline),
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
                                onTap: () async {
                                  if (email == null || password == null ||
                                      email == '' || password == '')
                                    _showDialog("Fields empty",
                                        "Please fill all fields.");
                                  else {
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    try {
                                      final user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                      if (user != null) {
                                        SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                        prefs.setString('email', email);
                                        prefs.setInt('i', 1);
                                        doc = await databaseReference
                                            .collection("UserInfo")
                                            .document(email)
                                            .get();
                                        prefs.setString(
                                            'name', doc.data["Name"]);
                                        prefs.setString('phone',
                                            doc.data["Phone"].toString());
                                        prefs.setString('constituency',
                                            doc.data["Constituency"]);
                                        Provider.of<DropDown>(context,
                                            listen: false)
                                            .setEmail(email);
                                        Provider.of<DropDown>(context,
                                            listen: false)
                                            .setUserInfo(
                                            doc.data["Name"],
                                            doc.data["Phone"].toString(),
                                            doc.data["Constituency"]);
                                        PackageInfo packageInfo =
                                        await PackageInfo.fromPlatform();
                                        Provider.of<DropDown>(context,
                                            listen: false)
                                            .setAppInfo(
                                            packageInfo.appName,
                                            packageInfo.packageName,
                                            packageInfo.version,
                                            packageInfo.buildNumber);

                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return BottomNavBar();
                                                }));
                                      }
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    } on PlatformException catch (e) {
                                      print(e);
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      //raise alert here and clear text fields
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return LoginPage();
                                          }));
                                      switch (e.code) {
                                        case "ERROR_USER_NOT_FOUND":
                                          {
                                            _showDialog("Invalid User",
                                                "Email does not exist. Please Sign Up.");
                                          }
                                          break;
                                        case "ERROR_INVALID_EMAIL":
                                          {
                                            _showDialog("Invalid Email",
                                                "Email is in Invalid format. Please Retry.");
                                          }
                                          break;
                                        case "ERROR_WRONG_PASSWORD":
                                          {
                                            _showDialog("Invalid Password",
                                                "Please enter the correct password. Use forgot password option if necessary.");
                                          }break;
                                        default:  _showDialog("Fields empty",
                                            "Please fill all fields.");


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
                                        'LOGIN',
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  4,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical * 2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'New to Sahaaya?',
                            style: GoogleFonts.montserrat(
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 2,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()),
                              );
                            },
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Register',
                                style: GoogleFonts.montserrat(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 4,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
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
