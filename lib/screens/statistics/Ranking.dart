import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/screens/home/BottomNavBar.dart';
import 'package:voter_grievance_redressal/screens/statistics/RankingDetails.dart';
import 'package:voter_grievance_redressal/util/SizeConfig.dart';


final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Ranking extends StatefulWidget {
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  int cnt = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return BottomNavBar();
        }));
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Ranking',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600, color: Colors.white,fontSize:SizeConfig.safeBlockHorizontal*4.5),
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
          body: Column(
            children: <Widget>[
              SizedBox(
                height: SizeConfig.safeBlockVertical * 4.2,
              ),
              RankingStream(count: cnt),
            ],
          )),
    );
  }
}

class RankingStream extends StatelessWidget {
  int count;
  RankingStream({this.count});

  void _showDialog(
      String a,
      String b,
      BuildContext context,
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

  @override
  Widget build(BuildContext context) {

    void _showDialog(
        String a,
        String b,
        BuildContext context,
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

    Future<bool>  getConnectivityStatus()async{
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        }
      } on SocketException catch (_) {
        _showDialog("No Internet!", "Please check your internet connection.",context);
        return false;
      }
    }

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("Statistics")
            .orderBy("ratio", descending: true)
            .snapshots(),
        //the above function returns a stream of snapshots..each snapshot contains documents at different periods of time..the one snapshot with the mosr recent change
        //is returned to the stream builder
        // ignore: missing_return
        builder: (context, snapshot) {
          // snapshot is a list of documents present in the collection
          //TODO: Handle snapshot.hasError conditions also here....
          if (snapshot.connectionState == ConnectionState.waiting || getConnectivityStatus() == false) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.indigo,
              ),
            );
          }
          if(snapshot.hasError){
            _showDialog("No internet!","Please check your internet connectivity.",context);
          }
          final ranks = snapshot.data.documents;
          List<RankingTile> rankingTiles = [];
          //HashMap hm = new HashMap<int, DocumentSnapshot>();
          for (int i = 0; i < ranks.length; i++) {
            count++;
            final rankingTile = RankingTile(
              rank: ranks[i],
              index: i + 1,
            );
            rankingTiles.add(rankingTile);
          }
          return Expanded(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.8),
              child: ListView(
                physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: rankingTiles,
              ),
            ),
          );
        });
  }
}

class RankingTile extends StatelessWidget {
  final DocumentSnapshot rank;
  int index;

  RankingTile({this.rank, this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,left: MediaQuery.of(context).size.width*0.02),
      child: Container(
          height: SizeConfig.safeBlockVertical * 50,
          width: SizeConfig.safeBlockHorizontal * 62,
//          decoration: BoxDecoration(
//            //color: Colors.grey.withOpacity(0.2),
//            color: Colors.white,
//            borderRadius: BorderRadius.circular(15.0),
//            border: Border.all(color: Colors.grey, width: 0.4),
//          ),
          child: Column(children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2.5,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.contain,
                child: Text(
                  index.toString(),
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                     ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 4.5,
            ),
            Container(
             height: SizeConfig.safeBlockVertical*3.5,
              width: SizeConfig.safeBlockHorizontal * 61,
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.contain,
                child: Text(
                  rank.documentID,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: SizeConfig.safeBlockHorizontal * 5),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            Text(
              'Total Complaints',
              style: GoogleFonts.montserrat(
                fontSize: SizeConfig.safeBlockHorizontal * 4,
              ),
            ),
            Text(
              rank.data["totalcomp"].toString(),
              style: GoogleFonts.montserrat(
                  fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              'Total Resolved',
              style: GoogleFonts.montserrat(
                  fontSize: SizeConfig.safeBlockHorizontal * 4),
            ),
            Text(
              rank.data["totalr"].toString(),
              style: GoogleFonts.montserrat(
                  fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            InkWell(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RankingDetails(
                              constituency: rank,
                              position: index.toString(),
                            )),
                    ),
                child: Container(
                  height: SizeConfig.safeBlockVertical * 6,
                  width: SizeConfig.safeBlockHorizontal * 43,
                  decoration: BoxDecoration(
                      color: Color(0xffe0e0e0),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'View Details',
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: SizeConfig.safeBlockHorizontal * 4.1),
                      ),
                    ),
                  ),
                )),
          ])),
    );
  }
}
