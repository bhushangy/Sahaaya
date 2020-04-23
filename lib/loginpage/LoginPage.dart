import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/home/home_page.dart';
import 'package:voter_grievance_redressal/models/checkBox.dart';

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

  void initState() {
    super.initState();
    setState(() {
      showPassword = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
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
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
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
                          onTap: () {},
                          child: Text(
                            'Forgot Password',
                            style: GoogleFonts.montserrat(
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
                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              if (user != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => home()),
                                );
                              }
                            } catch (e) {
                              print(e);
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
                      style: GoogleFonts.montserrat(),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text(
                        'Register',
                        style: GoogleFonts.montserrat(
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
    );
  }
}
// onPressed:  () async {
//                    showSpinner = true;
//                  try {
//                    final user = await _auth.signInWithEmailAndPassword(
//                        email: email, password: password);
//                    if (user != null) {
//                      Navigator.push(context, MaterialPageRoute(
//                        builder: (context){
//                          return home();
//                        }
//                      ));
//
//                    }
//                      showSpinner = false;
//                  } catch (e) {
//                    print(e);
//                    setState(() {
//                      showSpinner = false;
//                    });
//                    //raise alert here and clear text fields
////                    Navigator.push(context, MaterialPageRoute(
////                        builder: (context){
////                          return LoginScreen();
////                        }
////                    ));
//                  }
//                },
