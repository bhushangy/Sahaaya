import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voter_grievance_redressal/RetrieveIssues/RetrieveIssues.dart';
import 'package:voter_grievance_redressal/issues/FillForm.dart';

FirebaseUser loggedInUser;

// ignore: must_be_immutable
class DeptPage extends StatefulWidget {

  @override
  _DeptPageState createState() => _DeptPageState();
}

class _DeptPageState extends State<DeptPage> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        _buildDeptCard('assets/images/vote0.png',  'BWSSB'),
        _buildDeptCard('assets/images/vote0.png',  'BESCOM'),
        _buildDeptCard('assets/images/vote0.png',  'SANITATION'),
        _buildDeptCard('assets/images/vote0.png',  'ROADS'),
        _buildDeptCard('assets/images/vote0.png',  'CORRUPTION'),
        _buildDeptCard('assets/images/vote0.png',  'OTHERS'),

      ],
    );
  }
  Widget _buildDeptCard(String img,String category) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Container(
              height: 100.0,
              width: 250.0,
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(children: [
                SizedBox(height: 15.0),
                Image.asset(img, fit: BoxFit.cover, height: 130.0),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Text(category,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SizedBox(height: 30.0),
                InkWell(
                    onTap: () async {
                      try {
                        final user = await _auth.currentUser();
                        if (user != null) {
                          loggedInUser = user;
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return FillForm(category, loggedInUser.email);
                            }));
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      height: 45.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: Text(
                          'Raise Issue',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                    )),
                SizedBox(height: 15.0),
                InkWell(
                    onTap: () async {
                      try {
                        final user = await _auth.currentUser();
                        if (user != null) {
                          loggedInUser = user;
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return RetrieveIssues(category, loggedInUser.email);
                            }));
                      } catch (e) {
                        print(e);
                      }
//});
                    },
                    child: Container(
                      height: 45.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: Text(
                          'Previous Issues',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                    )),
              ])),
        )
      ],
    );
  }
}
