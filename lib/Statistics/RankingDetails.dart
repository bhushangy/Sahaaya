import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

import 'ContactDetails.dart';

// ignore: must_be_immutable
class RankingDetails extends StatefulWidget {
  final DocumentSnapshot constituency;
  String position;
  RankingDetails({this.constituency, this.position});

  @override
  _RankingDetailsState createState() => _RankingDetailsState();
}

class _RankingDetailsState extends State<RankingDetails> {
  @override
  void initState() {
    super.initState();
    getConnectivityStatus();
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
  void  getConnectivityStatus()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      }
    } on SocketException catch (_) {
      _showDialog("No Internet!", "Please check your internet connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.constituency.documentID,
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: SizeConfig.safeBlockHorizontal*4.1),
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
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.29,
                child: ListView(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    StatsCard(
                        cat: 'BWSSB',
                        imgPath: 'assets/Departments/bwssb.png',
                        nr: widget.constituency.data["bwssbnr"],
                        r: widget.constituency.data["bwssbr"],
                        txtColor: Color(0xFF000000)),
                    StatsCard(
                        cat: 'BESCOM',
                        imgPath: 'assets/Departments/bescom.png',
                        nr: widget.constituency.data["bwssbr"],
                        r: widget.constituency.data["bescomr"],
                        txtColor: Color(0xFF000000)),
                    StatsCard(
                        cat: 'SANITATION',
                        imgPath: 'assets/Departments/sewer.png',
                        nr: widget.constituency.data["sanitationnr"],
                        r: widget.constituency.data["sanitationr"],
                        txtColor: Color(0xFF000000)),
                    StatsCard(
                        cat: 'ROADS',
                        imgPath: 'assets/Departments/roads.png',
                        nr: widget.constituency.data["roadsnr"],
                        r: widget.constituency.data["roadsr"],
                        txtColor: Color(0xFF000000)),
                    StatsCard(
                        cat: 'CORRUPTION',
                        imgPath: 'assets/Departments/corruption.png',
                        nr: widget.constituency.data["corruptionnr"],
                        r: widget.constituency.data["corruptionr"],
                        txtColor: Color(0xFF000000)),
                    StatsCard(
                        cat: 'OTHERS',
                        imgPath: 'assets/Departments/others.png',
                        nr: widget.constituency.data["othernr"],
                        r: widget.constituency.data["otherr"],
                        txtColor: Color(0xFF000000)),
    SizedBox(height:  SizeConfig.safeBlockVertical*4),


                  ],
                ),
              ),
              SizedBox(height:  SizeConfig.safeBlockVertical*3),

              Divider(
                height: SizeConfig.safeBlockVertical*1,
                thickness: SizeConfig.safeBlockVertical*0.15,
              ),
              Padding(
                padding: EdgeInsets.only(left:SizeConfig.safeBlockHorizontal*5,top:SizeConfig.safeBlockVertical*1 ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  width: MediaQuery.of(context).size.width,
//                  decoration: BoxDecoration(
//                    border: Border.all(
//                        color: Colors.grey, width: 0.4),
//                    borderRadius: BorderRadius.circular(15.0),
//                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width:  SizeConfig.safeBlockHorizontal*5),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.03),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.height * 0.18,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child:  FittedBox(
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              child: Text(
                                widget.position.toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.022,
                              ),
                              Text(
                                'Rank',
                                style: GoogleFonts.montserrat(
                                    fontSize: SizeConfig.safeBlockHorizontal*4.2,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),

                              Text(
                                widget.position.toString(),
                                style: GoogleFonts.montserrat(
                                    fontSize:SizeConfig.safeBlockHorizontal*4.2, color: Colors.black),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.01,
                              ),
                              Text(
                                'Score',
                                style: GoogleFonts.montserrat(
                                    fontSize: SizeConfig.safeBlockHorizontal*4.2,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                (widget.constituency.data["ratio"] * 10)
                                            .toString()
                                            .length >
                                        5
                                    ? widget.constituency.data["ratio"]
                                        .toString()
                                        .substring(0, 5)
                                    : widget.constituency.data["ratio"]
                                        .toString(),
                                style: GoogleFonts.montserrat(
                                    fontSize: SizeConfig.safeBlockHorizontal*4.2, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical*5,
              ),
            ],
          ),
          Divider(
            height: SizeConfig.safeBlockVertical*1,
            thickness: SizeConfig.safeBlockVertical*0.15,
          ),
          SizedBox(
            height: SizeConfig.safeBlockVertical*2,
          ),
          Column(
            children: <Widget>[
              ContactTabs(
                pos: 'Mla',
                rep: widget.constituency.data['Mla'][0],
                ward: widget.constituency.documentID,
                repNum1: widget.constituency.data['Mla'][1],
                repNum2: widget.constituency.data['Mla'][2],
                repOffice: widget.constituency.data['Mla'][3],
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical*0.5,
              ),
              ContactTabs(
                pos: 'Corporator',
                rep: widget.constituency.data['Corporators']['Ward-101'][0],
                ward: 'Ward-101',
                repNum1: widget.constituency.data['Corporators']['Ward-101'][1],
                repNum2: widget.constituency.data['Corporators']['Ward-101'][2],
                repOffice: widget.constituency.data['Corporators']['Ward-101']
                    [3],
              ),
              ContactTabs(
                pos: 'Corporator',
                rep: widget.constituency.data['Corporators']['Ward-101'][0],
                ward: 'Ward-101',
                repNum1: widget.constituency.data['Corporators']['Ward-101'][1],
                repNum2: widget.constituency.data['Corporators']['Ward-101'][2],
                repOffice: widget.constituency.data['Corporators']['Ward-101']
                    [3],
              ),
              ContactTabs(
                pos: 'Corporator',
                rep: widget.constituency.data['Corporators']['Ward-101'][0],
                ward: 'Ward-101',
                repNum1: widget.constituency.data['Corporators']['Ward-101'][1],
                repNum2: widget.constituency.data['Corporators']['Ward-101'][2],
                repOffice: widget.constituency.data['Corporators']['Ward-101']
                    [3],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  String cat, imgPath;
  int nr, r;
  Color txtColor;

  StatsCard({this.cat, this.imgPath, this.nr, this.r, this.txtColor});

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.only(left:SizeConfig.safeBlockHorizontal*3),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.height * 0.2,
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.grey, width: 0.4),
//          borderRadius: BorderRadius.circular(15.0),
//        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.height * 0.09,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(
                  child: Image.asset(
                    imgPath,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical*2,
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  cat,
                  style: GoogleFonts.montserrat(
                      fontSize: SizeConfig.safeBlockHorizontal*4.5, color: txtColor, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical*2,
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Pending',
                  style: GoogleFonts.montserrat(fontSize:SizeConfig.safeBlockHorizontal*4, color: txtColor),
                ),
              ),
              FittedBox(
                fit:BoxFit.contain,
                child: Text(
                  nr.toString(),
                  style: GoogleFonts.montserrat(fontSize:SizeConfig.safeBlockHorizontal*3.75, color: txtColor),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Resolved',
                  style: GoogleFonts.montserrat(fontSize: SizeConfig.safeBlockHorizontal*4, color: txtColor),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  r.toString(),
                  style: GoogleFonts.montserrat(fontSize: SizeConfig.safeBlockHorizontal*3.75, color: txtColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactTabs extends StatelessWidget {
  String pos, rep, ward, repOffice;
  int repNum1, repNum2;

  ContactTabs(
      {this.pos,
      this.rep,
      this.ward,
      this.repNum1,
      this.repNum2,
      this.repOffice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.safeBlockVertical*2),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            backgroundColor: Color(0xFF757575),
            context: context,
            builder: (context) => ContactDetails(
                Num1: repNum1, Num2: repNum2, Office: repOffice),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.height * 0.09,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Color(0xFFFFE3DF),
                    ),
                    child: Center(
                      child: Image.asset('assets/Ranking/phone.png',
                          height: SizeConfig.safeBlockVertical*7, width: SizeConfig.safeBlockVertical*7),
                    ),
                  ),
                  SizedBox(width: SizeConfig.safeBlockHorizontal*5),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.67,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FittedBox(
                          fit:BoxFit.contain,
                          child: Text(
                            rep,
                            style: GoogleFonts.montserrat(
                                fontSize: SizeConfig.safeBlockHorizontal*4.4, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Flexible(
                          child: Text(
                            pos + ' - ' + ward,
                            style: GoogleFonts.montserrat(fontSize: SizeConfig.safeBlockHorizontal*3),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
