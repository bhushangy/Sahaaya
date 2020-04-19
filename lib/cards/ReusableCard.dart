import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voter_grievance_redressal/RetrieveIssues/RetrieveIssues.dart';
import 'package:voter_grievance_redressal/issues/FillForm.dart';
import 'package:voter_grievance_redressal/issues/imageCards.dart';

FirebaseUser loggedInUser;
class ReusableCard extends StatelessWidget {
  String value;

  ReusableCard(String value) {
    this.value = value;
  }
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: 200.0,
      width: 170.0,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '\n$value\n',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RoundIconButton(
                    icon: FontAwesomeIcons.plus,
                    onPressed: () async {
                      try {
                        final user = await _auth.currentUser();
                        if (user != null) {
                          loggedInUser = user;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return FillForm(value,loggedInUser.email);
                        }));
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  RoundIconButton(
                    icon: FontAwesomeIcons.history,
                    onPressed: ()  async {
                      /*
                      The await operator is used to wait for a Promise. It can be used inside an Async block only.
                      The keyword Await makes JavaScript wait until the future returns a result. It has to be noted that it only makes the
                      async function block wait i.e statements after the await statement inside the function body and not the whole program execution.
                      Since here there is no program left to execute or any widget
                      that is to be built the program itself will halt.But if the same is put in an init state then while the function awaits for the
                      future the build method executes and if the value of the future is refernced in the build method, then app crashes saying 'null value
                      returned by getter'
                       */
                      //Future.delayed(const Duration(milliseconds: 100), () async {
                        try {
                          final user = await _auth.currentUser();
                          if (user != null) {
                            loggedInUser = user;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return RetrieveIssues(value,loggedInUser.email);
                          }));
                        } catch (e) {
                          print(e);
                        }
                      //});


                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('\nRAISE'),
                  SizedBox(
                    width: 40.0,
                  ),
                  Text('\nSTATS'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
