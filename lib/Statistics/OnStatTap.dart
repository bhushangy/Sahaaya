import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'BottomSheetContent.dart';

class OnStatTap extends StatefulWidget {
  final DocumentSnapshot constituency;
  String position;
  OnStatTap({this.constituency, this.position});

  @override
  _OnStatTapState createState() => _OnStatTapState();
}

class _OnStatTapState extends State<OnStatTap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.constituency.documentID,
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
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.29,
                child: ListView(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    StatsCard(
                        cat: 'BWSSB',
                        imgPath: 'assets/images/vote1.png',
                        nr: widget.constituency.data["bwssbnr"],
                        r: widget.constituency.data["bwssbr"],
                        txtColor: Color(0xFF000000)),
                    StatsCard(
                        cat: 'BESCOM',
                        imgPath: 'assets/images/vote1.png',
                        nr: widget.constituency.data["bwssbr"],
                        r: widget.constituency.data["bescomr"],
                        txtColor: Color(0xFF000000)),
                    StatsCard(
                        cat: 'SANITATION',
                        imgPath: 'assets/images/vote1.png',
                        nr: widget.constituency.data["sanitationnr"],
                        r: widget.constituency.data["sanitationr"],
                        txtColor: Color(0xFF000000)),
                    StatsCard(
                        cat: 'ROADS',
                        imgPath: 'assets/images/vote1.png',
                        nr: widget.constituency.data["roadsnr"],
                        r: widget.constituency.data["roadsr"],
                        txtColor: Color(0xFF000000)),
                    StatsCard(
                        cat: 'CORRUPTION',
                        imgPath: 'assets/images/vote1.png',
                        nr: widget.constituency.data["corruptionnr"],
                        r: widget.constituency.data["corruptionr"],
                        txtColor: Color(0xFF000000)),
                    StatsCard(
                        cat: 'OTHERS',
                        imgPath: 'assets/images/vote1.png',
                        nr: widget.constituency.data["othernr"],
                        r: widget.constituency.data["otherr"],
                        txtColor: Color(0xFF000000)),
                    SizedBox(
                      width: 15.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(

                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 0.4),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.18,
                          width: MediaQuery.of(context).size.height * 0.18,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Image.asset('assets/images/vote1.png',
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.height * 0.06),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height * 0.035,
                            ),
                            Text(
                              'Rank',
                              style: GoogleFonts.montserrat(
                                  fontSize: 19.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.position.toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              'Score',
                              style: GoogleFonts.montserrat(
                                  fontSize: 19.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              (widget.constituency.data["ratio"] * 10)
                                  .toString().length>5?widget.constituency.data["ratio"].toString().substring(0,5):widget.constituency.data["ratio"].toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
            ],
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
                height: 10.0,
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

  StatsCard(
      {this.cat, this.imgPath, this.nr, this.r,this.txtColor});

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey,width: 0.4),
          borderRadius: BorderRadius.circular(15.0),),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.height * 0.09,
                decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(
                    child: Image.asset(imgPath,
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.height * 0.06))),
            SizedBox(height: 18.0),
            Text(
              cat,
              style: GoogleFonts.montserrat(
                  fontSize: 19.0, color: txtColor, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15.0),
            Text(
              'Pending',
              style: GoogleFonts.montserrat(fontSize: 16.0, color: txtColor),
            ),
            Text(
              nr.toString(),
              style: GoogleFonts.montserrat(fontSize: 15.0, color: txtColor),
            ),
            Text(
              'Resolved',
              style: GoogleFonts.montserrat(fontSize: 16.0, color: txtColor),
            ),
            Text(
              r.toString(),
              style: GoogleFonts.montserrat(fontSize: 15.0, color: txtColor),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactTabs extends StatelessWidget {
  String pos, rep, ward, repOffice;
  int repNum1, repNum2;

  ContactTabs({this.pos,
    this.rep,
    this.ward,
    this.repNum1,
    this.repNum2,
    this.repOffice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            backgroundColor: Color(0xFF757575),
            context: context,
            builder: (context) =>
                BottomSheetContent(
                    Num1: repNum1, Num2: repNum2, Office: repOffice),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              child: Row(
                children: [
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.09,
                    width: MediaQuery
                        .of(context)
                        .size
                        .height * 0.09,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Color(0xFFFFE3DF),
                    ),
                    child: Center(
                      child: Image.asset('assets/images/vote1.png',
                          height: 50.0, width: 50.0),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        rep,
                        style: GoogleFonts.montserrat(
                            fontSize: 19.0, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        pos + ' - ' + ward,
                        style: GoogleFonts.montserrat(fontSize: 12.0),
                      ),
                    ],
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