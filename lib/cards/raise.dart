import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voter_grievance_redressal/home/home_page.dart';

import 'dept.dart';

class raiseIssue extends StatefulWidget {
  @override
  _raiseIssueState createState() => _raiseIssueState();
}

class _raiseIssueState extends State<raiseIssue> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 6);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
          title: Text('Raise A New Issue'),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          elevation: 10.0,
          shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),

        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),

            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('All Categories',
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0)),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,

              child: TabBarView(
                controller: tabController,
                children: <Widget>[

                  new DeptPage(),
                  new DeptPage(),
                  new DeptPage(),
                  new DeptPage(),
                  new DeptPage(),
                  new DeptPage(),
                ],
              ),
            ),
            SizedBox(height: 10.0),

          ],
        ));
  }

}