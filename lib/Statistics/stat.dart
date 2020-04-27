import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/Statistics/OnStatTap.dart';
import 'package:voter_grievance_redressal/home/home_page.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return home();
            }));
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Ranking'),
            centerTitle: true,
            backgroundColor: Colors.indigo,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
          ),
          body: Container(
              //height: MediaQuery.of(context).size.height - 270.0,
              height: MediaQuery.of(context).size.height * 0.65,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text('Ranking Of Constituencies',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0)),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RankingStream(),
                ],
              ))),
    );
  }
}

class RankingStream extends StatelessWidget {
  int count = 0;

  @override
  Widget build(BuildContext context) {
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final ranks = snapshot.data.documents;
          List<RankingTile> rankingTiles = [];
          //HashMap hm = new HashMap<int, DocumentSnapshot>();
          for (var rank in ranks) {
            count++;
            final rankingTile = RankingTile(
              rank: rank,
              index: count.toString(),
            );
            rankingTiles.add(rankingTile);
          }
          return Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: rankingTiles,
            ),
          );
        });
  }
}

class RankingTile extends StatelessWidget {
  final DocumentSnapshot rank;
  String index;

  RankingTile({this.rank, this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Container(
          height: 100.0,
          width: 250.0,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(15.0)),
          child: Column(children: [
            SizedBox(height: 15.0),
            Text(
              index.toString(),
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600, color: Colors.red, fontSize: 70),
            ),
            SizedBox(height: 20.0),
            Text(
              rank.documentID,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 24),
            ),
            SizedBox(height: 20.0),
            SizedBox(height: 10.0),
            SizedBox(height: 15.0),
            InkWell(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OnStatTap(constituency: rank,position:index)),
                    ),
                child: Container(
                  height: 45.0,
                  width: 180.0,
                  decoration: BoxDecoration(
                      color: Color(0xffe0e0e0),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Center(
                    child: Text(
                      'View Details',
                      style: GoogleFonts.montserrat(

                          color: Colors.black,
                          fontSize: 17),
                    ),
                  ),
                )),
          ])),
    );
  }
}
