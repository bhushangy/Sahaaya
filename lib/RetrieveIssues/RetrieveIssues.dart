import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voter_grievance_redressal/RetrieveIssues/OnTileTap.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class RetrieveIssues extends StatefulWidget {
  String category;
  RetrieveIssues(String value) {
    this.category = value;
  }

  @override
  _RetrieveIssuesState createState() => _RetrieveIssuesState();
}

class _RetrieveIssuesState extends State<RetrieveIssues> {
  final _auth = FirebaseAuth.instance;
  Future doc;
  var len;
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//  final snackBar = SnackBar(
//    content: Text(
//      'No Grievanvces submitted',
//      style: TextStyle(color: Colors.black),
//    ),
//    duration: Duration(seconds: 3),
//    backgroundColor: Colors.black38,
//    elevation: 5.0,
//  );

//  void showSnackBar() {
//    _scaffoldKey.currentState.showSnackBar(snackBar);
//  }

  void initState() {
    super.initState();
    getCurrentUser();
    doc = getIssues();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future getIssues() async {
    String q = loggedInUser.email +
        "/" +
        widget.category +
        "/" +
        widget.category +
        "Grievances";
    QuerySnapshot qn = await _firestore
        .collection(q)
        .getDocuments(); // qn is a list of document snapshots
    len = qn.documents.length;
    return qn.documents;
  }

  void OnTileCallBack(DocumentSnapshot snap) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OnTileTap(category: widget.category, grievance: snap)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.category + ' Grievances'),
      ),
      body: Container(
        child: FutureBuilder(
          future: doc,
          builder: (_, snapshot) {
            // snapshot is a list of documents that is nothing but documents that was returned as a Future
            if (snapshot.connectionState == ConnectionState.waiting ||
                len == null) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            } else if (snapshot.data.length == 1) {
              return Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: Text(
                    'No Grievences Submitted....',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: len,
                  itemBuilder: (_, index) {
                    return snapshot.data[index].data["Constituency"] == ''
                        ? Container()
                        : Card(
                            color: Colors.white,
                            elevation: 4.0,
                            borderOnForeground: true,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 12.0),
                            child: Container(
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 15.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 10.0),
                                  height: 50.0,
                                  decoration: new BoxDecoration(
                                    border: new Border(
                                      right: new BorderSide(
                                          width: 2.0, color: Colors.black12),
                                    ),
                                  ),
                                  child:
                                      snapshot.data[index].data["Resolved"] ==
                                              true
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
                                  snapshot.data[index].data["Constituency"],
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  snapshot.data[index].data["Category"] +
                                      '\n' +
                                      snapshot.data[index].data["Created"]
                                          .toDate()
                                          .toString()
                                          .substring(0, 16),
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 11.0, 1.0, 5.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 30.0,
                                  ),
                                ),
                                isThreeLine: true,
                                onTap: () =>
                                    OnTileCallBack(snapshot.data[index]),
                                selected: true,
                              ),
                            ),
                          );
                  });
            }
          },
        ),
      ),
    );
  }
}
