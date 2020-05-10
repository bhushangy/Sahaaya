import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:voter_grievance_redressal/NewGrievance/FillForm.dart';

class FeedbackSubmit extends StatefulWidget {
  @override
  _FeedbackSubmitState createState() => _FeedbackSubmitState();
}

class _FeedbackSubmitState extends State<FeedbackSubmit> {
  bool showSpinner=false;
  String feedback;
  final _formKey = GlobalKey<FormState>();

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
            "Discard Form",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18),
          ),
          content: Text(
            "Do you want to discard this feedback form ?",
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: dontgoback,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Feedback',
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
          child: SafeArea(

            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(

                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text(
                          'Submit Feedback',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,  fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Container(
                      padding:
                      EdgeInsets.only( left: 20.0, right: 20.0),
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
                              height: 70.0,
                            ),
                            FormButtons(
                              label: 'SUBMIT',
                              width: 0.93 * MediaQuery.of(context).size.width,
                              height: 50,
                              onT: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();


                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try{


                                    Navigator.pop(context,true);
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    _showDialog("Feedback Submission", "Feedback Submitted Successfully.");
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