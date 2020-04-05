import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.category + ' Grievances'),
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            GrievanceStream(category: widget.category, email: widget.email)
          ],
        )));
  }
}

// ignore: must_be_immutable
class GrievanceStream extends StatelessWidget {
  String category;
  String q;
  String email;

  GrievanceStream({this.category, this.email}) {
    this.q = email + "/" + category + "/" + category + "Grievances";
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
          return grievances.length == 1
              ? Padding(
                  padding: const EdgeInsets.only(top: 280.0),
                  child: Center(
                    child: Text('No Grievances Submitted....'),
                  ),
                )
              : Expanded(
                  child: ListView(
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
          .document(
          grievance.data["Constituency"].toString().toUpperCase())
          .collection(grievance.data["Category"].toString().toUpperCase()+"Complaints")
          .where("RefId", isEqualTo: grievance.data['RefId'])
          .getDocuments()).documents;

      for (var i = 0; i < lis.length; i++) {
        await databaseReference
            .collection("Constituencies")
            .document(
            grievance.data["Constituency"].toString().toUpperCase())
            .collection(grievance.data["Category"].toString().toUpperCase()+"Complaints").
            document(lis[i].documentID).delete();
      }
    }
    catch(e){
      print(e);
    }

  }

  void deleteRecord() async {
    try {
      await databaseReference
          .collection(email)
          .document(grievance.data["Category"].toString().toUpperCase())
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
    return grievance.data["Description"] == ""
        ? Container()
        : Card(
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
                    leading: Container(
                      padding: EdgeInsets.only(right: 10.0),
                      height: 50.0,
                      decoration: new BoxDecoration(
                        border: new Border(
                          right:
                              new BorderSide(width: 2.0, color: Colors.black12),
                        ),
                      ),
                      child: grievance.data["Resolved"] == true
                          ? Icon(
                              Icons.thumb_up,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.thumb_down,
                              color: Colors.red,
                            ),
                    ),
                    title: Text(
                      grievance.data["Constituency"],
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      grievance.data["Resolved"] == true
                          ? grievance.data['Category'] + '\n'+
                              '\n' +
                              grievance.data["Created"]
                                  .toDate()
                                  .toString()
                                  .substring(0, 16) + '\n'+'Resolved'
                          : grievance.data['Category'] +
                               '\n'+
                              grievance.data["Created"]
                                  .toDate()
                                  .toString()
                                  .substring(0, 16) + '\n'+'Not Resolved',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 11.0, 1.0, 5.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 30.0,
                      ),
                    ),
                    isThreeLine: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnTileTap(
                                grievance: grievance))),
                    selected: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0, left: 265.0),
                  child: OutlineButton(
                    onPressed: () {
                      deleteRecord();
                      deleteRecordFromConstituencyCollec();
                    },
                    child: Text("Delete"),
                    borderSide: BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
