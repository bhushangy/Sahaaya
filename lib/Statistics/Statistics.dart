import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
    return Card(
      color: Colors.white,
      elevation: 4.0,
      borderOnForeground: true,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 95.0,
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              leading: Icon(Icons.looks_one,size: 28.0,),
              title: Text(
                rank.documentID,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                '',
                style: TextStyle(color: Colors.black),
              ),
              trailing: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 11.0, 1.0, 5.0),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 30.0,
                ),
              ),
//              onTap: () => Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => OnTileTap(
//                          grievance: grievance))),
            ),
          ),
        ],
      ),
    );
  }
}
