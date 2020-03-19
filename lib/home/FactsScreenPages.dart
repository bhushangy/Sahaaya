import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:voter_grievance_redressal/loginpage/login_screen.dart';
import 'package:voter_grievance_redressal/loginpage/registration_page.dart';


class FactsScreenPages extends StatelessWidget {
  final int index;
  final List<String> appFeatures = [];
  FactsScreenPages({this.index});

  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      color: Colors.white,
      elevation: 15.0,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/vote$index.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
              width: 70,
            ),
            Expanded(
              child: Text(
                'VOTE',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 90.0),
              child: index == 2
                  ? Column(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 300,
                    height: 45.0,
                    child: RaisedButton(
                      onPressed: () {
                        //REGISTER PAGE
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context){
                              return RegistrationScreen();
                            }
                        ));

                      },
                      child: Text('Get Started'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Colors.black45,
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                    width: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Already have an account?',
                        style: TextStyle(

                          fontSize: 20,
                        ),),
                      SizedBox(
                        height: 8.0,
                        width: 8.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return LoginScreen();
                              }
                          ));
                        },

                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
                  : SizedBox(
                height: 0.0,
                width: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}