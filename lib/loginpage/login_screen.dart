import 'package:flutter/material.dart';
import 'package:voter_grievance_redressal/components/rounded_button.dart';
import 'package:voter_grievance_redressal/loginpage/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:voter_grievance_redressal/home/home_page.dart';
import 'package:voter_grievance_redressal/loginpage/otp_verification.dart';

import '../home/home_page.dart';


class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
//  PersistentBottomSheetController _sheetController;
//  bool _loading = false;
//  String errorMsg = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/images/voting.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Colors.deepOrange,
                onPressed:  () async {
                    showSpinner = true;
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context){
                          return home();
                        }
                      ));

                    }
                      showSpinner = false;
                  } catch (e) {
                    print(e);
                    setState(() {
                      showSpinner = false;
                    });
                    //raise alert here and clear text fields
//                    Navigator.push(context, MaterialPageRoute(
//                        builder: (context){
//                          return LoginScreen();
//                        }
//                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
