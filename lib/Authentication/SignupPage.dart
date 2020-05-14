import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/Authentication//PostSignUp.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool showPassword;
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final databaseReference = Firestore.instance;

  void initState() {
    super.initState();
    setState(() {
      showPassword = false;
      email = '';
      password = '';
    });
  }

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
          contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*4,
              SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*4),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: new Text(a,style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize:SizeConfig.safeBlockHorizontal*5),),
          content: new Text(b,style: GoogleFonts.montserrat(
            fontWeight: FontWeight.normal,
            fontSize:SizeConfig.safeBlockHorizontal*4,
            color: Colors.black,
          ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" OK",style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal*3.5
              ),),
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
    SizeConfig().init(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, SizeConfig.safeBlockVertical *9, SizeConfig.safeBlockHorizontal * 47, 0),
                          child: Text(
                            'Sign',
                            style: GoogleFonts.montserrat(
                              fontSize:SizeConfig.safeBlockHorizontal*20, fontWeight: FontWeight.w600,),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 17,SizeConfig.safeBlockVertical *20.2, 0, 0),
                          child: Text(
                            'Up',
                            style: GoogleFonts.montserrat(
                                fontSize:SizeConfig.safeBlockHorizontal*20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 38, SizeConfig.safeBlockVertical * 23.2 ,0, 0),
                          child: Text(
                            '.',
                            style: GoogleFonts.montserrat(
                              fontSize:SizeConfig.safeBlockHorizontal*20,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, left: SizeConfig.safeBlockHorizontal* 5, right: SizeConfig.safeBlockHorizontal * 5),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.indigo,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                            ),
                            labelText: 'EMAIL',
                            labelStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize:SizeConfig.safeBlockHorizontal*4,
                              color: Colors.grey,
                            ),
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 6,
                        ),
                        TextField(
                          obscureText: !showPassword,
                          cursorColor: Colors.indigo,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: Icon(
                                Icons.remove_red_eye,
                                color: Colors.grey,
                                size:SizeConfig.safeBlockHorizontal*6,
                              ),
                              onTap: () {
                                setState(() {
                                  showPassword == false
                                      ? showPassword = true
                                      : showPassword = false;
                                });
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                            ),
                            labelText: 'PASSWORD',
                            labelStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize:SizeConfig.safeBlockHorizontal*4,
                              color: Colors.grey,
                            ),
                          ),
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 11,
                        ),
                        Container(
                          height: SizeConfig.safeBlockVertical * 7,
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                showSpinner = true;
                              });

                              try {
                                final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email, password: password);
                                if (newUser != null) {
                                  await databaseReference
                                      .collection("UserInfo")
                                      .document(email)
                                      .setData({
                                    'Name':null,
                                    'Email':email,
                                    'Phone':null,
                                    'Constituency':null,
                                  });
                                  Provider.of<DropDown>(context,
                                      listen: false)
                                      .setEmail(email);
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('email', email);
                                  prefs.setString('name',null);
                                  prefs.setString('phone',null);
                                  prefs.setString('constituency',null);
                                  prefs.setInt('i', 1);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PostSignUp(email: email,)),
                                  );
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                print(e);
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return SignupPage();
                                    }));
                                switch(e.code)
                                {
                                  case "ERROR_EMAIL_ALREADY_IN_USE":
                                    {
                                      _showDialog("Invalid Email", "Email already exists.Please Log In.");
                                    }break;
                                  case "ERROR_INVALID_EMAIL":
                                    {
                                      _showDialog("Invalid Email", "Email is in Invalid format.Please Retry.");
                                    }break;
                                  case "ERROR_WEAK_PASSWORD":
                                    {
                                      _showDialog("Password Weak", "Password should consist of minimum 6 characters.");

                                    }break;

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
                                  'REGISTER',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize:SizeConfig.safeBlockHorizontal*4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  SizedBox(
                    //this box comes into effect only when the keyboard is up and when keyboard closes it will disappear
                    height: SizeConfig.safeBlockVertical * 3,
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
//                onPressed: () async {
//                  setState(() {
//                    showSpinner = true;
//                  });
//                  try {
//                    final newUser = await _auth.createUserWithEmailAndPassword(
//                        email: email, password: password);
//                    if (newUser != null) {
//                      //createCollection();
//                      Navigator.push(context, MaterialPageRoute(
//                          builder: (context){
//                            return home();
//                          }
//                      ));
//
//                    }
//                    setState(() {
//                      showSpinner = false;
//                    });
//                  } catch (e) {
//                    setState(() {
//                      showSpinner = false;
//                    });
//                    print(e);
//                    //raise alert here
////                    Navigator.push(context, MaterialPageRoute(
////                        builder: (context){
////                          return RegistrationScreen();
////                        }
////                    ));
//                  }
//                },