import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:voter_grievance_redressal/home/build_home.dart';
import 'package:voter_grievance_redressal/issues/MyCustomForm.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class myissues extends StatefulWidget {
  @override
  _myissuesState createState() => _myissuesState();
}

class _myissuesState extends State<myissues> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
