import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/NewGrievance/FillForm.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool showSpinner=false;
  final _formKey = GlobalKey<FormState>();
  String oldP,newP,newP2;
  FirebaseUser user;
  final _auth = FirebaseAuth.instance;

  bool showPassword=false,showPassword2=false,showPassword3=false;

  Future<bool>dontgoback(){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*6.2,SizeConfig.safeBlockHorizontal*2,
              SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*2),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Discard Update",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize:SizeConfig.safeBlockHorizontal*5),
          ),
          content: Text(
            "Do you want to discard this password updation ?",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize:SizeConfig.safeBlockHorizontal*4
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" YES",style: TextStyle(
                  fontSize:SizeConfig.safeBlockHorizontal*3.5
              ),),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            new FlatButton(
              child: new Text(" NO",style: TextStyle(
                  fontSize:SizeConfig.safeBlockHorizontal*3.5
              ),),
              onPressed: () {
                Navigator.pop(context,false);
              },
            ),
          ],
        );
      },
    );
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
          contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*6.2,SizeConfig.safeBlockVertical*2,
              SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockVertical*2),
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
    return WillPopScope(
      onWillPop: newP==null?() async => true :dontgoback,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Change Password',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: Colors.white, fontSize: SizeConfig.safeBlockHorizontal*4.5),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.safeBlockVertical*4,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: SizeConfig.safeBlockHorizontal*3,),
                        Text(
                          'Update your Password',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,  fontSize: SizeConfig.safeBlockHorizontal*5),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.safeBlockVertical*4,),
                    Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.safeBlockHorizontal * 5,
                          right: SizeConfig.safeBlockHorizontal * 5),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              obscureText: !showPassword,
                              validator: (op) {
                                if (op.isEmpty) {
                                  return 'Please enter your old password.';
                                } else {
                                  return null;
                                }
                              },
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.normal,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              onChanged: (value) {
                                oldP = value;
                              },
                              cursorColor: Colors.indigo,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.grey,
                                    size: SizeConfig.safeBlockHorizontal * 6,
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
                                labelText: 'Old Password',
                                labelStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical*4,
                            ),
                            TextFormField(

                              obscureText: !showPassword2,
                              validator: (np) {
                                if (np.isEmpty) {
                                  return 'Please enter your new password.';
                                } else {
                                  return null;
                                }
                              },
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.normal,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              onChanged: (value) {
                                newP = value;
                              },
                              cursorColor: Colors.indigo,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.grey,
                                    size: SizeConfig.safeBlockHorizontal * 6,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showPassword2 == false
                                          ? showPassword2 = true
                                          : showPassword2 = false;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigo),
                                ),
                                labelText: 'New Password',
                                labelStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical*4,
                            ),
                            TextFormField(
                              obscureText: !showPassword3,
                              validator: (np2) {
                                if (np2.isEmpty) {
                                  return 'Please confirm your new password.';
                                } else {
                                  return null;
                                }
                              },
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.normal,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              onChanged: (value) {
                                newP2 = value;
                              },
                              cursorColor: Colors.indigo,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.grey,
                                    size: SizeConfig.safeBlockHorizontal * 6,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showPassword3 == false
                                          ? showPassword3 = true
                                          : showPassword3 = false;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigo),
                                ),
                                labelText: 'Confirm New Password',
                                labelStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: SizeConfig.safeBlockVertical*8,
                            ),
                            FormButtons(
                              label: 'SUBMIT',
                              width: 0.93 * MediaQuery.of(context).size.width,
                              height: SizeConfig.safeBlockVertical*7,
                              onT: () async {
                                if(oldP==null||newP==null||newP2==null)
                                  _showDialog(
                                      "Fields empty", "Please fill all fields.");
                                else if(oldP.trim()==''||newP.trim()==''||newP2.trim()=='')
                                  _showDialog(
                                      "Fields empty", "Please fill all fields.");
                                else if(newP!=newP2)
                                  _showDialog("Passwords Unmatch", "The new password and confirmed new password do not match.");
                                else if(newP.length<6)
                                  _showDialog("Invalid New Password", "Password length should be minimum 6 characters.");

                                else if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  var email = prefs.getString('email');
                                  try {
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    user =
                                        (await _auth.signInWithEmailAndPassword(
                                            email: email, password: oldP)).user;
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }catch(e)
                                {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  _showDialog("Wrong Password", "Wrong Old Password. Please try again.");
                                }


                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try{
                                    user.updatePassword(newP);

                                    Navigator.pop(context,true);
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    _showDialog("Password Updated", "Password changed successfully.");
                                  } catch (e) {
                                    print(e);
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }

                                }else{
                                  _showDialog("Empty Fields", "Please fill all the fields.");
                                }
                              },),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
