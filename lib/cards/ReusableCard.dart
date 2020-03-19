import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voter_grievance_redressal/RetrieveIssues/RetrieveIssues.dart';
import 'package:voter_grievance_redressal/issues/MyCustomForm.dart';
import 'package:voter_grievance_redressal/issues/create_issue.dart';
import 'package:voter_grievance_redressal/issues/imageCards.dart';

class ReusableCard extends StatelessWidget {
  String value;

  ReusableCard(String value) {
    this.value = value;

  }


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
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return MyCustomForm(value);
                      }));
                    },
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  RoundIconButton(
                    icon: FontAwesomeIcons.history,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return RetrieveIssues(value);
                      }));
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
