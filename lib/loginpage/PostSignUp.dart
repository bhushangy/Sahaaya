import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/home/build_home.dart';
import 'package:voter_grievance_redressal/home/home_page.dart';
import 'package:voter_grievance_redressal/models/checkBox.dart';

class PostSignUp extends StatefulWidget {
  String email;
  PostSignUp({this.email});
  @override
  _PostSignUpState createState() => _PostSignUpState();
}

class _PostSignUpState extends State<PostSignUp> {
  final databaseReference = Firestore.instance;
  String name;
  int phone;
  String address;
  bool showSpinner = false;

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
          title: new Text(a),
          content: new Text(b),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                          padding: EdgeInsets.fromLTRB(15.0, 50.0, 0, 0),
                          child: Text(
                            'Hello',
                            style: GoogleFonts.montserrat(
                                fontSize: 80.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20.0, 115.0, 0, 0),
                          child: Text(
                            'there',
                            style: GoogleFonts.montserrat(
                                fontSize: 80.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0.2, 0.0),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20.0, 115.0, 0, 0),
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
                    height: 30.0,
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          cursorColor: Colors.indigo,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                            ),
                            labelText: 'NAME',
                            labelStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                        SizedBox(
                          height: 33.0,
                        ),
                        TextField(
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            phone = int.parse(value);
                          },
                          cursorColor: Colors.indigo,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                            ),
                            labelText: 'PHONE',
                            labelStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 33.0,
                        ),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (value) {
                            address = value;
                          },
                          cursorColor: Colors.indigo,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                            ),
                            labelText: 'ADDRESS',
                            labelStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70.0,
                        ),
                        Container(
                          height: 50.0,
                          child: InkWell(
                            onTap: () async {
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
                                      .setData({
                                    'Name': name,
                                    'Email': widget.email,
                                    'Phone': phone,
                                    'Address': address,
                                  });

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => home()),
                                  );
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
                            },
                            child: Material(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(30.0),
                              shadowColor: Colors.indigo,
                              elevation: 5.0,
                              child: Center(
                                child: Text(
                                  'DONE',
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
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 0.4 * MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
