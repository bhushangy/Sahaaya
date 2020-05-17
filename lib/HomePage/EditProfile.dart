import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/NewGrievance/FillForm.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool showSpinner = false;
//  String name,constituency;
//  int phone;
  final _formKey = GlobalKey<FormState>();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  void initState() {
    super.initState();
    if (Provider.of<DropDown>(context, listen: false).name == null)
      myController1.text == " ";
    else
      myController1.text = Provider.of<DropDown>(context, listen: false).name;
    if (Provider.of<DropDown>(context, listen: false).phone == null)
      myController2.text == " ";
    else
      myController2.text = Provider.of<DropDown>(context, listen: false).phone;
    if (Provider.of<DropDown>(context, listen: false).constituency == null)
      myController2.text == " ";
    else
      myController3.text =
          Provider.of<DropDown>(context, listen: false).constituency;
  }

  void dispose() {
    super.dispose();
    myController1.dispose();
    myController2.dispose();

    myController3.dispose();
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
            contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*6.2,SizeConfig.safeBlockHorizontal*2,
                SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*2),
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
            "Do you want to discard this updation ?",
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

  Future profileUpdate() async {
    try {
      await databaseReference
          .collection("UserInfo")
          .document(Provider.of<DropDown>(context, listen: false).email)
          .updateData({
        'Name': Provider.of<DropDown>(context, listen: false).name,
        'Phone': int.parse(Provider.of<DropDown>(context, listen: false).phone),
        'Constituency':
            Provider.of<DropDown>(context, listen: false).constituency,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: dontgoback,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Update Profile',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: SizeConfig.safeBlockHorizontal * 4.5),
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
            color: Colors.indigo,
            child: SafeArea(
                child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 4,
                    ),
                    Container(
                      height: SizeConfig.safeBlockVertical * 16,
                      width: SizeConfig.safeBlockVertical * 16,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            50.0,
                          ),
                          color: Colors.white,
                          image: DecorationImage(
                              image: AssetImage('assets/HomePage/user.png'),
                              fit: BoxFit.fill)),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 4,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.safeBlockHorizontal * 5,
                          right: SizeConfig.safeBlockHorizontal * 5),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              initialValue: myController1.text,
                              enabled: true,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.normal,
                                fontSize: SizeConfig.safeBlockHorizontal*4,
                              ),
                              validator: (nam) {
                                if (nam.isEmpty) {
                                  return 'Please enter your name.';
                                } else {
                                  return null;
                                }
                              },
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
                                myController1.text = value;
                              },
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical*4,
                            ),
                            TextFormField(
                              initialValue: myController2.text,
                              enabled: true,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.normal,
                                fontSize: SizeConfig.safeBlockHorizontal*4,
                              ),
                              validator: (nam) {
                                if (nam.isEmpty) {
                                  return 'Please enter 10 digit mobile number';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.phone,
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
                              onChanged: (value) {
                                myController2.text = value;
                              },
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical*4,
                            ),
                            TextFormField(
                              initialValue: myController3.text,
                              enabled: true,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.normal,
                                fontSize: SizeConfig.safeBlockHorizontal*4,
                              ),
                              validator: (nam) {
                                if (nam.isEmpty) {
                                  return 'Please enter your constituency.';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.multiline,
                              cursorColor: Colors.indigo,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigo),
                                ),
                                labelText: 'CONSTITUENCY',
                                labelStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              onChanged: (value) {
                                myController3.text = value;
                              },
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical*9,
                    ),
                    FormButtons(
                      label: 'SUBMIT',
                      width: 0.93 * MediaQuery.of(context).size.width,
                      height: SizeConfig.safeBlockVertical*7,
                      onT: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          if (myController2.text.length != 10) {
                            _showDialog("Invalid Phone Number",
                                "Enter a valid 10 digit phone number.");
                          } else {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              Provider.of<DropDown>(context, listen: false)
                                  .constituency = myController3.text.trim();
                              Provider.of<DropDown>(context, listen: false)
                                  .name = myController1.text.trim();
                              Provider.of<DropDown>(context, listen: false)
                                  .phone = myController2.text.trim();
                              await profileUpdate();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('name', myController1.text.trim());
                              prefs.setString('phone', myController2.text.trim());
                              prefs.setString(
                                  'constituency', myController3.text.trim());

                              Navigator.pop(context, true);
                              setState(() {
                                showSpinner = false;
                              });
                              _showDialog("Profile Update",
                                  "Profile Updated Successfully.");
                            } catch (e) {
                              print(e);
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }
                        } else {
                          _showDialog(
                              "Fields empty", "Please fill all fields.");
                        }
                      },
                    ),
                  ],
                )
              ],
            )),
          ),
        ));
  }
}

