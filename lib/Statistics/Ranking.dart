import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/Statistics/RankingDetails.dart';
import 'package:voter_grievance_redressal/HomePage/BottomNavBar.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Ranking extends StatefulWidget {
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  @override
  Widget build(BuildContext context) {
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
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              RankingStream(),
            ],
          )),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                physics: ScrollPhysics(
                  parent: BouncingScrollPhysics()
                ),
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
  String index;

  RankingTile({this.rank, this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
      child: Container(
        height: 100,
          width: 260.0,
//          decoration: BoxDecoration(
//            //color: Colors.grey.withOpacity(0.2),
//            color: Colors.white,
//            borderRadius: BorderRadius.circular(15.0),
//            border: Border.all(color: Colors.grey, width: 0.4),
//          ),
          child: Column(children: [
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/Ranking/$index.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Flexible(
              child: Text(
                rank.documentID,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 20),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Total Complaints',
              style: GoogleFonts.montserrat(fontSize: 16.0,),
            ),
            Text(
              rank.data["totalcomp"].toString(),
              style: GoogleFonts.montserrat(fontSize: 15.0,fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.02,
            ),
            Text(
              'Total Resolved',
              style: GoogleFonts.montserrat(fontSize: 16.0,),
            ),
            Text(
              rank.data["totalr"].toString(),
              style: GoogleFonts.montserrat(fontSize: 15.0,fontWeight: FontWeight.w600),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.05),
            InkWell(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RankingDetails(constituency: rank, position: index,path:'assets/Ranking/$index.png')),
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
                          color: Colors.black, fontSize: 17),
                    ),
                  ),
                )),
          ])),
    );
  }
}