import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:voter_grievance_redressal/RetrieveIssues/RetrieveIssues.dart';
import 'package:voter_grievance_redressal/home/build_home.dart';
import 'package:voter_grievance_redressal/issues/FillForm.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:  AppBar(
          title: Text('Ranking'),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          elevation: 10.0,
          shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),

        ),
        body: SafeArea(
            child: Column(
              children: <Widget>[RankingStream()],
            )));
  }
}

class RankingStream extends StatelessWidget {

  int count = 0 ;

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
          HashMap hm = new HashMap<int, DocumentSnapshot>();
          for (var rank in ranks) {
            count++;
            final rankingTile = RankingTile(
              rank: rank,
              index:count,
            );
            rankingTiles.add(rankingTile);
          }
          return Expanded(
            child: ListView(
              //scrollDirection: Axis.horizontal,
              children: rankingTiles,
            ),
          );
        });
  }
}

class RankingTile extends StatelessWidget {
  final DocumentSnapshot rank;
  int index;

  RankingTile({this.rank,this.index});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Container(
              height: 100.0,
              width: 250.0,
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(children: [
                SizedBox(height: 15.0),
                //Image.asset(img, fit: BoxFit.cover, height: 130.0),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Text("category",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SizedBox(height: 30.0),
                InkWell(
                  onTap: () {},
//                    onTap: () async {
//                      try {
//                        final user = await _auth.currentUser();
//                        if (user != null) {
//                          loggedInUser = user;
//                        }
//                        Navigator.push(context,
//                            MaterialPageRoute(builder: (context) {
//                              return FillForm(category, loggedInUser.email);
//                            }));
//                      } catch (e) {
//                        print(e);
//                      }
//                    },
                    child: Container(
                      height: 45.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: Text(
                          'Raise Issue',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                    )),
                SizedBox(height: 15.0),
                InkWell(
                  onTap: () {},
//                    onTap: () async {
//                      try {
//                        final user = await _auth.currentUser();
//                        if (user != null) {
//                          loggedInUser = user;
//                        }
//                        Navigator.push(context,
//                            MaterialPageRoute(builder: (context) {
//                              return RetrieveIssues(category, loggedInUser.email);
//                            }));
//                      } catch (e) {
//                        print(e);
//                      }
////});
//                    },
                    child: Container(
                      height: 45.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: Text(
                          'Previous Issues',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                    )),
              ])),
        )
      ],
    );
  }
}
