import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

final databaseReference = Firestore.instance;
FirebaseUser loggedInUser;

class GrievanceDetails extends StatefulWidget {
  final DocumentSnapshot grievance;
  String email; // the snapshot of the document whose tile was pressed

  GrievanceDetails({this.grievance, this.email});

  @override
  _GrievanceDetailsState createState() => _GrievanceDetailsState();
}

class _GrievanceDetailsState extends State<GrievanceDetails> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var snackbar = SnackBar(
    behavior:SnackBarBehavior.floating ,
      content: Text("Status Updated"),
      duration: Duration(seconds: 1),
      elevation: 10.0);
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  String description;
  String img1, img2;
  String dat;
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
  var _txtControl = TextEditingController();

  void initState() {
    super.initState();
    //getCurrentUser();
    getData();

  }
void dispose(){
    super.dispose();
    _txtControl.dispose();
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
    isResolved == true ? _txtControl.text = "Yes" : _txtControl.text = "No";
  }

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
    SizeConfig().init(context);
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
            'Your Grievance',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: Colors.white,fontSize:SizeConfig.safeBlockHorizontal*4.2),
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
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              child: Column(children: [
                SizedBox(
                  height:SizeConfig.safeBlockVertical*1,
                ),
                images.length == 0
                    ? Padding(
                  padding:EdgeInsets.all(SizeConfig.safeBlockHorizontal*1),
                  child: Container(
                    width:SizeConfig.safeBlockHorizontal*97,
                    height:SizeConfig.safeBlockHorizontal*59,
                    child: Icon(
                      Icons.image,
                        size:SizeConfig.safeBlockHorizontal*10,
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
                  height:SizeConfig.safeBlockVertical*35,
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
                            padding: EdgeInsets.only(top:SizeConfig.safeBlockHorizontal*1),
                            child: Container(
                              padding: EdgeInsets.all(3.0),
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
                  height:SizeConfig.safeBlockVertical*3,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ConstiAndCateg(
                        val: widget.grievance.data["Constituency"],
                        label: 'CONSTITUENCY',
                        icon: Icon(Icons.location_on,size:SizeConfig.safeBlockHorizontal*6),),
                    SizedBox(
                     height:SizeConfig.safeBlockVertical*4,
                    ),
                    ConstiAndCateg(
                        val: widget.grievance.data["Category"],
                        label: 'CATEGORY',
                        icon: Icon(Icons.playlist_add_check,size:SizeConfig.safeBlockHorizontal*7),),
                    SizedBox(
                      height:SizeConfig.safeBlockVertical*4,
                    ),
                    ConstiAndCateg(
                        val: dat,
                        label: 'CREATED',
                        icon: Icon(Icons.calendar_today,size:SizeConfig.safeBlockHorizontal*6),),
                    SizedBox(
                      height:SizeConfig.safeBlockVertical*4,
                    ),
                    ConstiAndCateg(
                        val: widget.grievance.data["Description"],
                        label: 'DESCRIPTION',
                        icon: Icon(Icons.description,size:SizeConfig.safeBlockHorizontal*6),),
                    SizedBox(
                      height:SizeConfig.safeBlockVertical*4,
                    ),
                    Padding(
                      padding:EdgeInsets.only(
                          left:  SizeConfig.safeBlockHorizontal * 2,
                          right:
                          SizeConfig.safeBlockHorizontal * 2),
                      child: CheckboxListTile(
                        title: Text('Is this grievance addressed?',style:TextStyle(
                             color: Colors.black,fontSize:SizeConfig.safeBlockHorizontal*4.1),),
                        value: isResolved,
                        onChanged: (bool value) async {
                          setState(() {
                            isResolved = value;
                            value == true ? _txtControl.text = "Yes" : _txtControl.text = "No";
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
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left:  SizeConfig.safeBlockHorizontal * 2,
                          right:
                          SizeConfig.safeBlockHorizontal * 2),
                      child: TextFormField(
                        controller: _txtControl,
                        enabled: false,
                        onChanged: (value) {
                          _txtControl.text = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: isResolved == true
                              ? Icon(
                            Icons.thumb_up,
                            color: Colors.green, size:SizeConfig.safeBlockHorizontal * 6)
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
                      height:SizeConfig.safeBlockVertical*5,
                    ),
                    Center(
                      child: Container(
                        width: 94 *  SizeConfig.safeBlockHorizontal,
                        height:  SizeConfig.safeBlockVertical * 35,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.75, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                    ),
                    SizedBox(
                      height:SizeConfig.safeBlockVertical*5,
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
          left:  SizeConfig.safeBlockHorizontal * 2,
          right:
          SizeConfig.safeBlockHorizontal * 2),
      child: TextFormField(
        maxLines: null,
        keyboardType: TextInputType.multiline ,
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