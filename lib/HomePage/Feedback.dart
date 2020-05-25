import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voter_grievance_redressal/NewGrievance/FillForm.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

class FeedbackSubmit extends StatefulWidget {
  @override
  _FeedbackSubmitState createState() => _FeedbackSubmitState();
}

class _FeedbackSubmitState extends State<FeedbackSubmit> {
  bool showSpinner=false;
  String feedback;
  final _formKey = GlobalKey<FormState>();
  void _launchEmail()async
  {
    var url="mailto:sahaayaapp@gmail.com?subject=Feedback - Sahaaya App&body=$feedback ";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
            "Discard Form",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize:SizeConfig.safeBlockHorizontal*5),
          ),
          content: Text(
            "Do you want to discard this feedback ?",
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: feedback==null?() async => true :dontgoback,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Feedback',
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
                          'Submit Feedback',
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

                              validator: (add) {
                                if (add.isEmpty) {
                                  return 'Please enter Feedback.';
                                } else {
                                  return null;
                                }
                              },
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.normal,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: (value) {
                                feedback = value;
                              },
                              cursorColor: Colors.indigo,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigo),
                                ),
                                labelText: 'FEEDBACK',
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
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();



                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try{
                                    _launchEmail();

                                    Navigator.pop(context,true);
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  } catch (e) {
                                    print(e);
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }

                                }else{
                                  _showDialog("Form empty", "Please fill the feedback form.");
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