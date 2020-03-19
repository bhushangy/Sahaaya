import 'package:flutter/material.dart';
import 'package:voter_grievance_redressal/components/rounded_button.dart';
import 'package:voter_grievance_redressal/loginpage/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:voter_grievance_redressal/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final databaseReference = Firestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  List<String> docNames = ["CORRUPTION", "BWSSB", "ROADS"];

  void createCollection() async {
    try {
      await databaseReference
          .collection(email)
          .document(docNames[0])
          .collection(docNames[0] + "Grievances").document().setData({
        'Constituency':'' ,
        'Category': '',
        'Description':'' ,
        'Image1': '',
        'Image2': '',
        'Created': '',
        'Location':GeoPoint(0.0, 0.0),
        'Resolved':false
      });
      await databaseReference
          .collection(email)
          .document(docNames[1])
          .collection(docNames[1] + "Grievances").document().setData({
        'Constituency':'' ,
        'Category': '',
        'Description':'' ,
        'Image1': '',
        'Image2': '',
        'Created': '',
        'Location':GeoPoint(0.0, 0.0),
        'Resolved':false
      });
      await databaseReference
          .collection(email)
          .document(docNames[2])
          .collection(docNames[2] + "Grievances").document().setData({
        'Constituency':'' ,
        'Category': '',
        'Description':'' ,
        'Image1': '',
        'Image2': '',
        'Created': '',
        'Location':GeoPoint(0.0, 0.0),
        'Resolved':false
      });
    } catch (e) {
      print(e);
    }
  }

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
                title: 'Register',
                colour: Colors.deepOrange,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      createCollection();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return home();
                          }
                      ));

                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    print(e);
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