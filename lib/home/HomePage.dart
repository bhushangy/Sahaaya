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

class HomePage extends StatefulWidget {
  static String whichConstituency = _HomePageState.constituency[0];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool expanded = false;
  static List<String> constituency = [
    'Yalahanka',
    'Malleshwaram',
    'Vidyaranyapura'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.44,
                    width: double.infinity,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.28,
                    width: double.infinity,
                    color: Colors.indigo,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                        Text(
                          'Sahaaya',
                          style: GoogleFonts.montserrat(
                              fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      ],
                    ),

                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.2,
                    left: 15.0,
                    right: 15.0,
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(7.0),
                      child: Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.135,
                    left: (MediaQuery.of(context).size.width / 2 - 50.0),
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            50.0,
                          ),
                          color: Colors.grey,
                          image: DecorationImage(
                              image: AssetImage('assets/images/vote1.png'),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.28),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Center(
                          child: Text(
                            'Lalo',
                            style: GoogleFonts.montserrat(
                                fontSize: 20.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.32),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Center(
                          child: Text(
                            'Yalahanka',
                            style: GoogleFonts.montserrat(
                                fontSize: 16.0, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 130,
              child: ListView(
                physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  menuCard(
                    context,
                    'Announcement',
                    'assets/images/vote1.png',
                  ),
                  menuCard(context, 'Announcement', 'assets/images/vote1.png'),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.035),
              child: Container(
                child: Text(
                  'How it works?',
                  style: GoogleFonts.montserrat(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 130,
              child: ListView(
                physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  menuCard(
                    context,
                    'Announcement',
                    'assets/images/vote1.png',
                  ),
                  menuCard(context, 'Announcement', 'assets/images/vote1.png'),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.035),
              child: Container(
                child: Text(
                  'Select your Constituency',
                  style: GoogleFonts.montserrat(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child:Center(
                child: DropdownButton<String>(

                  elevation: 2,
                  value:Provider.of<DropDown>(context,listen: false).consti,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  onChanged: (String newValue) async {
                    setState(() {
                      Provider.of<DropDown>(context,listen: false).changeState(newValue);
                      //  dropdownValue = newValue;
                      HomePage.whichConstituency = Provider.of<DropDown>(context,listen: false).consti;
                      //print(buildhome.whichConstituency);
                    });
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
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

Widget menuCard(BuildContext context, String announcemnet, String imgPath) {
  return Padding(
    padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.035,
        right: MediaQuery.of(context).size.width * 0.035),
    child: Material(
      borderRadius: BorderRadius.circular(7.0),
      elevation: 0.5,
      child: Container(
        height: 125.0,
        width: MediaQuery.of(context).size.width * 0.86,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0), color: Colors.white),
        child: Row(
          children: <Widget>[
            SizedBox(width: 10.0),
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imgPath), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(7.0)),
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15.0),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.07),
                  child: Container(
                    child: Center(
                      child: Text(
                        'Announcement',
                        style: GoogleFonts.montserrat(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.49,
                  child: Text(
                    announcemnet + 'vjjhvvhvhjvh hvjhvjhvvvhj jhjhg gjhvjvhj',
                    style: GoogleFonts.montserrat(
                        fontSize: 14.0, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}