import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:voter_grievance_redressal/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignupPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;

  void initState() {
    super.initState();
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: new Text(a,style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18),),
          content: new Text(b,style: GoogleFonts.montserrat(
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<bool>dontgoback(){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Exit",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18),
          ),
          content: Text(
            "Do you want to exit the app ?",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" YES"),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
            new FlatButton(
              child: new Text(" NO"),
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
    return SafeArea(
      child: WillPopScope(
        onWillPop: dontgoback,
        child: Scaffold(
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
                            padding: EdgeInsets.fromLTRB(15.0, 50.0, 0, 0),
                            child: Text(
                              'Log',
                              style: GoogleFonts.montserrat(
                                  fontSize: 80.0, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Align(
                            alignment: Alignment(-0.5, 0.0),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0.0, 115.0, 0, 0),
                              child: Text(
                                'In',
                                style: GoogleFonts.montserrat(
                                    fontSize: 80.0, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(-0.22, 0.0),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15.0, 115.0, 0, 0),
                              child: Text(
                                '.',
                                style: GoogleFonts.montserrat(
                                  fontSize: 80.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
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
                                color: Colors.grey,
                              ),
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                          SizedBox(
                            height: 33.0,
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
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Container(
                            alignment: Alignment(1.0, 0.0),
                            padding: EdgeInsets.only(top: 15.0, left: 25.0),
                            child: InkWell(

                              onTap: () {
                                if(email=="" || email==null)
                                  _showDialog("Email Invalid", "Email cannot be empty. Enter your email.");

                                else{
                                try{

                                  _auth.sendPasswordResetEmail(email: email);
                                  _showDialog("Password Reset", "Password reset link sent to your email.");

                                    }on PlatformException

                                catch(e){

                                        _showDialog("Invalid Email", "Enter valid Email or Sign Up.");

                                }


                              }},
                              child: Text(
                                'Forgot Password',
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.indigo,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 37.0,
                          ),
                          Container(
                            height: 50.0,
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  final user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  if (user != null) {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('email', email);
                                    prefs.setInt('i', 1);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return home();
                                    }));
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } catch (e) {
                                  print(e);
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  //raise alert here and clear text fields
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginPage();
                                  }));
                                  switch(e.code)
                                  {
                                    case "ERROR_USER_NOT_FOUND":
                                    {
                                      _showDialog("Invalid User", "Email does not exist. Please Sign Up.");
                                    }break;
                                    case "ERROR_INVALID_EMAIL":
                                      {
                                        _showDialog("Invalid Email", "Email is in Invalid format. Please Retry.");
                                      }break;
                                    case "ERROR_WRONG_PASSWORD":
                                      {
                                        _showDialog("Invalid Password", "Please enter the correct password. Use forgot password option if necessary.");

                                      }break;

                                  }
                                }
                              },
                              child: Material(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(30.0),
                                shadowColor: Colors.indigo,
                                elevation: 5.0,
                                child: Center(
                                  child: Text(
                                    'LOGIN',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 27.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'New to Sahaaya?',
                          style: GoogleFonts.montserrat(
                            fontSize: 20
                          ),

                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()),
                            );
                          },
                          child: Text(
                            'Register',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                                decoration: TextDecoration.underline),
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
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
