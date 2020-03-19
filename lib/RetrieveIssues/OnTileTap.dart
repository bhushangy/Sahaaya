import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/painting.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final databaseReference = Firestore.instance;
FirebaseUser loggedInUser;

class OnTileTap extends StatefulWidget {
  String category;
  final DocumentSnapshot
      grievance; // the snapshot of the document whose tile was pressed

  OnTileTap({this.category, this.grievance});

  @override
  _OnTileTapState createState() => _OnTileTapState();
}

class _OnTileTapState extends State<OnTileTap> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var snackbar = SnackBar(content: Text("Status Updated"),duration: Duration(seconds: 1),elevation: 10.0);
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  String description;
  String constituency;
  String img1, img2;
  String dat;
  var pageIndex = 0;
  bool isResolved;
  bool showSpinner = false;
  List<String> images = [];

  void initState() {
    super.initState();
    getCurrentUser();
    getData();
  }

  void getData() {
    description = widget.grievance.data["Description"];
    constituency = widget.grievance.data["Constituency"];
    img1 = widget.grievance.data["Image1"];
    img2 = widget.grievance.data["Image2"];
    img1 == "" || img1 == null ? print("") : images.add(img1);
    img2 == "" || img2 == null ? print("") : images.add(img2);
    dat = widget.grievance.data["Created"].toDate().toString().substring(0, 16);
    isResolved = widget.grievance.data["Resolved"];
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

  void updateStatus() async {
  try{
    await databaseReference
        .collection(loggedInUser.email)
        .document(widget.grievance.data["Category"]
        .toString()
        .toUpperCase())
        .collection(widget.grievance.data["Category"]
        .toString()
        .toUpperCase() +
        "Grievances")
        .document(widget.grievance.documentID).updateData({
      "Resolved":isResolved
    });
    setState(() {
      showSpinner = false;
    });

  }catch(e){
    print(e);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Your Grievance'),
      ),
      body: ModalProgressHUD(
        inAsyncCall:showSpinner ,
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            child: Column(children: [
              images.length == 0
                  ? Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: Icon(
                          Icons.image,
                          size: 40,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                    )
                  : CarouselSlider(
                      height: 250,
                      viewportFraction: 0.96,
                      autoPlay: false,
                      onPageChanged: (index) {
                        setState(() {
                          pageIndex = index;
                        });
                      },
                      items: images.map(
                        (i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 7.0),
                                child: Container(
                                  padding: EdgeInsets.all(4.0),
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.circular(3.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white70,
                                        )
                                      ]),
                                  child: FadeInImage(
                                    image: NetworkImage(i),
                                    fit: BoxFit.fill,
                                    placeholder: AssetImage(
                                      'assets/images/loading.gif',
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ).toList(),
                    ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.place),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                      title: Text('Constituency'),
                      subtitle: Text(constituency),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.format_list_bulleted),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                      title: Text(
                        'Category',
                      ),
                      subtitle: Text(widget.category),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.description),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                      title: Text(
                        'Description',
                      ),
                      subtitle: Text(
                        description,
                        style: TextStyle(height: 1.2),
                      ),
                      isThreeLine: true,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.date_range),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                      title: Text(
                        'Created',
                      ),
                      subtitle: Text(
                        dat,
                        style: TextStyle(height: 1.2),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: isResolved == false
                          ? Icon(Icons.thumb_down)
                          : Icon(Icons.thumb_up),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                      title: Text(
                        'Is This Grievance Addressed?',
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Checkbox(
                          value: isResolved,
                          onChanged: (bool value) async {
                            setState(() {
                              isResolved = value;
                              showSpinner = true;
                            });
                            await updateStatus();
                            _scaffoldKey.currentState.showSnackBar(snackbar);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
