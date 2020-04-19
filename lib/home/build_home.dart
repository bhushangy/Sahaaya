import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/models/checkBox.dart';
import 'navdrawer.dart';

final databaseReference = Firestore.instance;
FirebaseUser loggedInUser;


class buildhome extends StatefulWidget {

  static String whichConstituency = _buildhomeState.constituency[0];

  @override
  _buildhomeState createState() => _buildhomeState();
}

class _buildhomeState extends State<buildhome> {
  double rating;
  String mlaname = "S.R. Vishwanath";
  String mpname = "D.V. Sadananda Gowda";
  String mparea = "Bengaluru North";
  String user_name = "Kobe Bryant";
  static List<String> constituency = ['Yalahanka','Malleshwaram','Vidyaranyapura'];
  DocumentSnapshot doc;
  bool showSpinner = false;
  //String dropdownValue;


  void getRating() async {
    try{

      doc = await databaseReference
          .collection("Statistics").document(Provider.of<DropDown>(context,listen: false).consti.toUpperCase()).get();
      rating = double.parse((doc.data['ratio'] * 10).toStringAsFixed(2));


    }catch(e){
      print(e);

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar:  AppBar(
          title: Text(' Grievances'),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          elevation: 10.0,
          shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),

        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Text('Select Constituency',
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: DropdownButton<String>(
                      value:Provider.of<DropDown>(context,listen: false).consti,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      onChanged: (String newValue) async {
                        showSpinner = true;
                        setState(() {
                          Provider.of<DropDown>(context,listen: false).changeState(newValue);
                        //  dropdownValue = newValue;
                          buildhome.whichConstituency = Provider.of<DropDown>(context,listen: false).consti;
                          //print(buildhome.whichConstituency);
                        });
                        await getRating();
                        setState(() {
                          rating;
                        });
                        showSpinner = false;
                      },
                      items: constituency.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Center(
                  child: Text('Constituency Score',
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,

                  child: Center(
                    child: Text("$rating",
                        style: TextStyle(
                          fontSize: 150,
                          color: Colors.deepOrange,
                        )),
                  ),

                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(children: <Widget>[
                        Text1('Member Of Legislative Assembly(MLA)'),
                        Text2(mlaname),
                        Text1('Member Of Parliament(MP)'),
                        Text2(mpname),
                        Text1('MP Constituency'),
                        Text2(mparea),
                      ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class Text2 extends StatelessWidget {
  String value;
  Text2(String value){
    this.value=value;

  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$value\n',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange),
    );
  }
}

class Text1 extends StatelessWidget {
  String value;
  Text1(String value){
    this.value=value;

  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$value',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}