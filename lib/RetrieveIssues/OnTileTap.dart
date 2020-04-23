import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/home/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final databaseReference = Firestore.instance;
FirebaseUser loggedInUser;

class OnTileTap extends StatefulWidget {
  final DocumentSnapshot grievance;
  String email; // the snapshot of the document whose tile was pressed

  OnTileTap({this.grievance, this.email});

  @override
  _OnTileTapState createState() => _OnTileTapState();
}

class _OnTileTapState extends State<OnTileTap> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var snackbar = SnackBar(
      content: Text("Status Updated"),
      duration: Duration(seconds: 1),
      elevation: 10.0);
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  String description;
  String img1, img2;
  String dat;
  String status;
  var pageIndex = 0;
  bool isResolved;
  bool showSpinner = false;
  List<String> images = [];
  double lat, long;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  DocumentSnapshot doc;
  var nres, res, totalres, ratio;

  void initState() {
    super.initState();
    //getCurrentUser();
    getData();
  }

  void getData() {
    //description = widget.grievance.data["Description"];
    img1 = widget.grievance.data["Image1"];
    img2 = widget.grievance.data["Image2"];
    img1 == "" || img1 == null ? print("") : images.add(img1);
    img2 == "" || img2 == null ? print("") : images.add(img2);
    dat = widget.grievance.data["Created"].toDate().toString().substring(0, 16);
    lat = widget.grievance.data["Location"].latitude;
    long = widget.grievance.data["Location"].longitude;
    isResolved = widget.grievance.data["Resolved"];
    isResolved == true ? status = "Yes" : status = "No";
  }

//  void getCurrentUser() async {
//    try {
//      final user = await _auth.currentUser();
//      if (user != null) {
//        loggedInUser = user;
//      }
//    } catch (e) {
//      print(e);
//    }
//  }

  void updateStatus() async {
    try {
      await databaseReference
          .collection("Users") //
          .document(widget.email)
          .collection(
              widget.grievance.data["Category"].toString().toUpperCase() +
                  "Grievances")
          .document(widget.grievance.documentID)
          .updateData({"Resolved": isResolved});
    } catch (e) {
      print(e);
    }
  }

  void statsUpdate(bool val) async {
    try {
      doc = await databaseReference
          .collection("Statistics")
          .document(widget.grievance.data["Constituency"].toUpperCase())
          .get();

      if (val == true) {
        nres = doc.data[widget.grievance.data["Category"].toLowerCase() + 'nr'];
        nres == 0 ? nres = 0 : nres -= 1;
        res = doc.data[widget.grievance.data["Category"].toLowerCase() + 'r'];
        res += 1;
        totalres = doc.data['totalr'];
        totalres += 1;
        ratio = totalres / doc.data['totalcomp'];
      } else {
        nres = doc.data[widget.grievance.data["Category"].toLowerCase() + 'nr'];
        nres += 1;
        res = doc.data[widget.grievance.data["Category"].toLowerCase() + 'r'];
        res -= 1;
        totalres = doc.data['totalr'];
        totalres -= 1;
        ratio = totalres / doc.data['totalcomp'];
      }

      await databaseReference
          .collection("Statistics")
          .document(widget.grievance.data["Constituency"].toUpperCase())
          .updateData({
        widget.grievance.data["Category"].toLowerCase() + 'nr': nres,
        widget.grievance.data["Category"].toLowerCase() + 'r': res,
        'totalr': totalres,
        'ratio': ratio
      });
    } catch (e) {
      print(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(LatLng(lat, long).toString()),
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'New Grievance',
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
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 10.0,
                ),
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
                        enableInfiniteScroll: false,
                        height: 250,
                        viewportFraction: 1.0,
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
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
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
                    ConstiAndCateg(
                        val: widget.grievance.data["Constituency"],
                        label: 'CONSTITUENCY',
                        icon: Icon(Icons.location_on)),
                    SizedBox(
                      height: 30.0,
                    ),
                    ConstiAndCateg(
                        val: widget.grievance.data["Category"],
                        label: 'CATEGORY',
                        icon: Icon(Icons.playlist_add_check)),
                    SizedBox(
                      height: 30.0,
                    ),
                    ConstiAndCateg(
                        val: dat,
                        label: 'CREATED',
                        icon: Icon(Icons.calendar_today)),
                    SizedBox(
                      height: 30.0,
                    ),
                    ConstiAndCateg(
                        val: widget.grievance.data["Description"],
                        label: 'DESCRIPTION',
                        icon: Icon(Icons.description)),
                    SizedBox(
                      height: 30.0,
                    ),
                    CheckboxListTile(
                      title: Text('Is this grievance addressed?'),
                      value: isResolved,
                      onChanged: (bool value) async {
                        setState(() {
                          isResolved = value;
                          value == true ? status = "Yes" : status = "No";
                          showSpinner = true;
                        });
                        await updateStatus();
                        await statsUpdate(value);
                        setState(() {
                          showSpinner = false;
                        });
                        _scaffoldKey.currentState.showSnackBar(snackbar);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 0.022 * MediaQuery.of(context).size.width,
                          right: 0.022 * MediaQuery.of(context).size.width),
                      child: TextFormField(
                        enabled: true,
                        onChanged: (value) {
                          status = value;
                        },
                        initialValue: status,
                        // enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: isResolved == true
                              ? Icon(
                                  Icons.thumb_up,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.thumb_down,
                                  color: Colors.red,
                                ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          labelText: "STATUS",
                          labelStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 15,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black38,
                          width: 1,
                        ),
                      ),
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lat, long),
                          zoom: 11.0,
                        ),
                        mapType: _currentMapType,
                        markers: _markers,
                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>[
                          new Factory<OneSequenceGestureRecognizer>(
                            () => new EagerGestureRecognizer(),
                          ),
                        ].toSet(),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class ConstiAndCateg extends StatelessWidget {
  String val, label;
  Icon icon;
  ConstiAndCateg({this.val, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 0.022 * MediaQuery.of(context).size.width,
          right: 0.022 * MediaQuery.of(context).size.width),
      child: TextFormField(
        enabled: false,
        initialValue: val,
        // enabled: false,
        decoration: InputDecoration(
          prefixIcon: icon,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo),
          ),
          labelText: label,
          labelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
