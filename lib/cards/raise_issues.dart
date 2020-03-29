import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voter_grievance_redressal/cards/ReusableCard.dart';
import 'package:voter_grievance_redressal/home/home_page.dart';

class raise extends StatefulWidget {
  @override
  _raiseState createState() => _raiseState();
}

class _raiseState extends State<raise> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
//          leading: FlatButton(child: Icon(Icons.arrow_back),onPressed: (){
//            Navigator.pop(context);
//          },),
          centerTitle: true,
          title: Text("Raise A New Issue"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard('BWSSB'),
                  ),
                  Expanded(
                    child: ReusableCard('BESCOM'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard('HEALTH'),
                  ),
                  Expanded(
                    child: ReusableCard('ROADS'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard('SANITATION'),
                  ),
                  Expanded(
                    child: ReusableCard('CORRUPTION'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
