import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/issues/constants.dart';
import 'package:voter_grievance_redressal/models/checkBox.dart';
import 'imageCards.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:voter_grievance_redressal/issues/drag_marker_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final databaseReference = Firestore.instance;
FirebaseUser loggedInUser;

class FillForm extends StatefulWidget {
  String category;
  String email;
  FillForm(String value, String email) {
    this.category = value;
    this.email = email;
  }

  @override
  _FillFormState createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  final _formKey = GlobalKey<FormState>();
  File _image, _image2, _image3, _image4;
  final _auth = FirebaseAuth.instance;
  String description;
  final myController = TextEditingController();
  String _uploadedFileURL1 = '';
  String _uploadedFileURL2 = '';
  bool showSpinner = false;
  DragMarkerMap obj = new DragMarkerMap();
//  String l1=DragMarkerMap().whichlat.toString();
//  String l2=DragMarkerMap().whichlong.toString();
  double l3 = DragMarkerMap().whichlat;
  double l4 = DragMarkerMap().whichlong;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  Random r = new Random();
  String Refid;
  DocumentSnapshot doc;
  var res, nres, totalc;
  int phone;

//  void initState() {
//    super.initState();
//    getCurrentUser();
//
//  }

  void dispose() {
    myController.dispose();
    super.dispose();
  }
//
//  void getCurrentUser() async {
//    try {
//      final user = await _auth.currentUser();
//      if (user != null) {
//        loggedInUser = user;
//        // print(loggedInUser.email);
//      }
//
//    } catch (e) {
//      print(e);
//    }
//  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      print('_image: $_image');
    });
  }

  Future _getImage2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image2 = image;
      print('_image2: $_image2');
    });
  }

  Future _getImage3() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image3 = image;
      print('_image3: $_image3');
    });
  }

  Future _getImage4() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image4 = image;
      print('_image4: $_image4');
    });
  }

  void statsUpdate() async {
    try {
      doc = await databaseReference
          .collection("Statistics")
          .document(Provider.of<DropDown>(context, listen: false)
              .consti
              .toUpperCase())
          .get();

      nres = doc.data[widget.category.toLowerCase() + 'nr'];
      totalc = doc.data['totalcomp'];
      nres += 1;
      totalc += 1;

      await databaseReference
          .collection("Statistics")
          .document(Provider.of<DropDown>(context, listen: false)
              .consti
              .toUpperCase())
          .updateData({
        widget.category.toLowerCase() + 'nr': nres,
        'totalcomp': totalc
      });
    } catch (e) {
      print(e);
    }
  }

  void createRecord() async {
    try {
      DragMarkerMap ob = new DragMarkerMap();
      bool flag;
      ob.whichlat == null || ob.whichlong == null ? flag = false : flag = true;
      Refid = Provider.of<DropDown>(context, listen: false)
              .consti
              .toUpperCase()
              .substring(0, 3) +
          widget.category +
          r.nextInt(10000).toString();
      await databaseReference
          .collection("Users")
          .document(widget.email) //widget.category.toUpperCase()
          .collection(widget.category.toUpperCase() + "Grievances")
          .document() // by default it goes to bbmp document...but this can be changed
          .setData({
        'Constituency':
            Provider.of<DropDown>(context, listen: false).consti.toUpperCase(),
        'Category': widget.category,
        'Description': myController.text,
        'Image1': _uploadedFileURL1,
        'Image2': _uploadedFileURL2,
        'Created': FieldValue.serverTimestamp(),
        'RefId': Refid,
        'Location': flag == true
            ? GeoPoint(DragMarkerMap().whichlat, DragMarkerMap().whichlong)
            : GeoPoint(0, 0),
        'Resolved': false
      });

      await databaseReference
          .collection("Constituencies")
          .document(Provider.of<DropDown>(context, listen: false)
              .consti
              .toUpperCase())
          .collection(widget.category.toUpperCase() + "Complaints")
          .document()
          .setData({
        'email': widget.email,
        'Constituency':
            Provider.of<DropDown>(context, listen: false).consti.toUpperCase(),
        'Category': widget.category,
        'Description': myController.text,
        'Image1': _uploadedFileURL1,
        'Image2': _uploadedFileURL2,
        'Created': FieldValue.serverTimestamp(),
        'RefId': Refid,
        'Location': flag == true
            ? GeoPoint(DragMarkerMap().whichlat, DragMarkerMap().whichlong)
            : GeoPoint(0, 0),
        'Resolved': false
      });
    } catch (e) {
      print(e);
    }
  }

  Future uploadFile(File image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL1 = fileURL;
      });
    });
  }

  Future uploadFile2(File image2) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(image2.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(image2);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL2 = fileURL;
      });
    });
    //print(_uploadedFileURL2);
  }

  void _showDialog(
    String a,
    String b,
  ) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(a),
          content: new Text(b),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      _markers.add(Marker(
        onDragEnd: ((value) {
          DragMarkerMap().whichlat = value.latitude;
          DragMarkerMap().whichlong = value.longitude;
        }),
        markerId: MarkerId(
            LatLng(DragMarkerMap().whichlat, DragMarkerMap().whichlong)
                .toString()),
        draggable: true,
        position: LatLng(DragMarkerMap().whichlat, DragMarkerMap().whichlong),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SafeArea(
        child: Scaffold(
      appBar: CupertinoNavigationBar(
        padding: EdgeInsetsDirectional.only(
          top: 20.0,
        ),
        leading: Row(
          children: <Widget>[
            SizedBox(
              width: 13.0,
            ),
            Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25.0,
            ),
          ],
        ),
        middle: Text(
          'New Grievance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.indigo,
        border: Border.all(color: Colors.indigo),
      ),
      body: Column(children: <Widget>[
        Container(
          height: 20.0,
          width: double.infinity,
          color: Colors.indigo,
        ),
        SizedBox(
          height: 100,
        ),
        Container(
          child: Expanded(
            child: ListView(
              physics: ScrollPhysics(
                parent: BouncingScrollPhysics()
              ),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  height: 300.0,
                  width: double.infinity,
                  child: TextField(
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 300.0,
                  width: double.infinity,
                  child: TextField(),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 300.0,
                  width: double.infinity,
                  child: TextField(),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 300.0,
                  width: double.infinity,
                  child: TextField(),
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        )
      ]),
    ));
  }
}
