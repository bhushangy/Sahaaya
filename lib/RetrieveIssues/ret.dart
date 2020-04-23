import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/RetrieveIssues/OnTileTap.dart';

final _firestore = Firestore.instance;

class RetrieveIssues extends StatefulWidget {
  String category, email;
  RetrieveIssues(String value, String mail) {
    this.category = value;
    this.email = mail;
  }

  @override
  _RetrieveIssuesState createState() => _RetrieveIssuesState();
}

class _RetrieveIssuesState extends State<RetrieveIssues> {
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text(
          widget.category,
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 18
          ),

        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 10.0,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),

      ),
      body:

      Container(
        height: MediaQuery.of(context).size.height - 220.0,

        child: Column(

          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),

            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('Previous Grievances',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0)),
            ),
            SizedBox(
              height: 10.0,
            ),
            GrievanceStream(category: widget.category, email: widget.email),
          ],
        ),
      ),



    );
  }
}

// ignore: must_be_immutable
class GrievanceStream extends StatelessWidget {
  String category;
  String q;
  String email;
  TabController tabController;

  GrievanceStream({this.category, this.email}) {
    this.q = "Users" + "/" + email + "/" + category + "Grievances";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection(q)
            .orderBy("Created", descending: true)
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
          final grievances = snapshot.data.documents;
          List<GrievanceTiles> grievanceTiles = [];
          for (var grievance in grievances) {
            final grievanceTile = GrievanceTiles(
              grievance: grievance,
              email: email,
            );
            grievanceTiles.add(grievanceTile);
          }
          return grievances.length == 0
              ? Padding(
            padding: const EdgeInsets.only(top: 280.0),
            child: Center(
              child: Text('No Grievances Submitted....',
              style: TextStyle(
                fontSize: 24
              ),),
            ),
          )
              :Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: grievanceTiles,
            ),
          );






        });
  }
}

class GrievanceTiles extends StatelessWidget {
  final DocumentSnapshot grievance;
  String email;

  GrievanceTiles({this.grievance, this.email});
  List<DocumentSnapshot> lis = [];

  void deleteRecordFromConstituencyCollec() async {
    try {
      lis = (await databaseReference
          .collection("Constituencies")
          .document(grievance.data["Constituency"].toString().toUpperCase())
          .collection(grievance.data["Category"].toString().toUpperCase() +
          "Complaints")
          .where("RefId", isEqualTo: grievance.data['RefId'])
          .getDocuments())
          .documents;

      for (var i = 0; i < lis.length; i++) {
        await databaseReference
            .collection("Constituencies")
            .document(grievance.data["Constituency"].toString().toUpperCase())
            .collection(grievance.data["Category"].toString().toUpperCase() +
            "Complaints")
            .document(lis[i].documentID)
            .delete();
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteRecord() async {
    try {
      await databaseReference
          .collection("Users")
          .document(email)
          .collection(grievance.data["Category"].toString().toUpperCase() +
          "Grievances")
          .document(grievance.documentID)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
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
                grievance.data["Resolved"] == true
                    ? Icon(
                  Icons.thumb_up,
                  size: 60,
                  color: Colors.green,
                )
                    : Icon(
                  Icons.thumb_down,
                  size: 60,
                  color: Colors.red,
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Text(grievance.data["Constituency"],

                      style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 24
                  ),),

                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Text(
                      grievance.data["Resolved"] == true
                          ? '\n'+grievance.data['Category'] +
                          '\n' +

                          grievance.data["Created"]
                              .toDate()
                              .toString()
                              .substring(0, 16) +
                          '\n' +
                          'Resolved'
                          : '\n'+grievance.data['Category'] +
                          '\n' +
                          grievance.data["Created"]
                              .toDate()
                              .toString()
                              .substring(0, 16) +
                          '\n' +
                          'Not Resolved',

                    style: GoogleFonts.montserrat(
                        //fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 22
                    ),),

                ),


                SizedBox(height: 30.0),
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnTileTap(grievance: grievance,email:email
                            ))),
                    child: Container(
                      height: 45.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: Text(
                          'View Details',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                    )),
                SizedBox(height: 15.0),
                InkWell(
                    onTap:() {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: new Text("Delete this Previous Record"),
                            content: new Text("Are you sure you want to delete it ?"),
                            actions: <Widget>[
                              // usually buttons at the bottom of the dialog
                              new FlatButton(
                                child: new Text(" YES"),
                                onPressed: () {
                                  deleteRecord();
                                  deleteRecordFromConstituencyCollec();
                                  Navigator.of(context).pop();
                                },
                              ),
                              new FlatButton(
                                child: new Text(" NO"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 45.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                    )),
              ])),
        );

  }
}
