import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/NewGrievance/FillForm.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool showSpinner=false;
  String name,constituency;
  int phone;
  final _formKey = GlobalKey<FormState>();
  void initState()
  {
    super.initState();
    name=Provider.of<DropDown>(context, listen: false)
        .name;
    phone=int.parse(Provider.of<DropDown>(context, listen: false)
        .phone);
    constituency=Provider.of<DropDown>(context, listen: false)
        .constituency;
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            a,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18),
          ),
          content: Text(
            b,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" OK"),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Discard Update",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18),
          ),
          content: Text(
            "Do you want to discard this updation ?",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" YES"),
              onPressed: () {
                Navigator.pop(context,true);
              },
            ),
            new FlatButton(
              child: new Text(" NO"),
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
          .document(Provider.of<DropDown>(context, listen: false)
          .email)
          .updateData({
        'Name': name,
        'Phone': phone,
        'Constituency':constituency,
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
                  fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18),
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
                          height: 20.0,
                        ),
                        Container(
                          height: 120,
                          width: 120,
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
                          height: 20,),
                        Container(
                          padding:
                          EdgeInsets.only( left: 20.0, right: 20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(

                                  enabled:true,
                                  initialValue: Provider.of<DropDown>(context, listen: false)
                                      .name==null?"":Provider.of<DropDown>(context, listen: false)
                                      .name,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
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
                                    name = value;
                                  },
                                ),
                                SizedBox(
                                  height: 33.0,
                                ),
                                TextFormField(
                                  enabled:true,
                                  initialValue: Provider.of<DropDown>(context, listen: false)
                                      .phone==null?"":Provider.of<DropDown>(context, listen: false)
                                      .phone,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  validator: (num) {
                                    if (num.isEmpty) {
                                      return 'Please enter 10 digit mobile number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    phone = int.parse(value);
                                  },
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
                                ),
                                SizedBox(
                                  height: 33.0,
                                ),
                                TextFormField(
                                  enabled:true,
                                  initialValue: Provider.of<DropDown>(context, listen: false)
                                      .constituency==null?"":Provider.of<DropDown>(context, listen: false)
                                      .constituency,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  validator: (add) {
                                    if (add.isEmpty) {
                                      return 'Please enter your constituency.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  onChanged: (value) {
                                    constituency = value;
                                  },
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
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 65.0,
                        ),
                        FormButtons(
                          label: 'SUBMIT',
                          width: 0.93 * MediaQuery.of(context).size.width,
                          height: 50,
                          onT: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              if (phone
                                  .toString()
                                  .length != 10) {
                                _showDialog("Invalid Phone Number",
                                    "Enter a valid 10 digit phone number.");
                              } else {
                                setState(() {
                                  showSpinner = true;
                                });
                                try{
                                  Provider.of<DropDown>(context, listen: false)
                                      .constituency=constituency;
                                  Provider.of<DropDown>(context, listen: false)
                                      .name=name;
                                  Provider.of<DropDown>(context, listen: false)
                                      .phone=phone.toString();
                                  await profileUpdate();
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('name',name);
                                  prefs.setString('phone',phone.toString());
                                  prefs.setString('constituency',constituency);

                                  Navigator.pop(context,true);
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  _showDialog("Profile Update", "Profile Updated Successfully.");
                                } catch (e) {
                                  print(e);
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              }
                            }else{
                              _showDialog("Fields empty", "Please fill all fields.");
                            }
                          },),
                      ],
                    )
                  ],
                )),
          ),
        ));
  }
}
class UserDetails extends StatelessWidget {
  String val, label;
  UserDetails({this.val, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 0.022 * MediaQuery.of(context).size.width,
          right: 0.022 * MediaQuery.of(context).size.width),
      child: TextFormField(

        enabled:true,
        initialValue: val,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo),
          ),
          labelText: label,
          labelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}