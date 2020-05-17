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
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:voter_grievance_redressal/NewGrievance//Map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

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
  File image1, image2;
  final _auth = FirebaseAuth.instance;
  String description;
  final _formKey = GlobalKey<FormState>();
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
  int i = 0;

  @override
  void initState() {
    super.initState();
    DragMarkerMap().whichlong = null;
    DragMarkerMap().whichlat = null;
  }

  void dispose() {
    super.dispose();
  }

  Future statsUpdate() async {
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

  Future createRecord() async {
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
        'Description': description,
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
        'Description': description,
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

  Future getImage() async {
    FocusScope.of(context).unfocus(focusPrevious: true);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image1 = image;
      print('_image: $image1');
    });
  }

  Future getImage2() async {
    FocusScope.of(context).unfocus(focusPrevious: true);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image2 = image;
      print('_image2: $image2');
    });
  }

  Future uploadFile(File image1, File image2) async {
    StorageReference storageReference;
    StorageUploadTask uploadTask;
    setState(() {

      print(i);
    });
    try {

      if (image1 != null) {
        i++;
        storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(image1.path)}}');
        uploadTask = storageReference.putFile(image1);
        await uploadTask.onComplete;
        print('File 1 Uploaded');
        await storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            _uploadedFileURL1 = fileURL;
          });
        });
      }
    } catch (e) {
      print(e);
      _showDialog("Error", "Please try uploading images again.");
    }

    try {
      if (image2 != null) {
        i++;
        storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(image2.path)}}');
        uploadTask = storageReference.putFile(image2);
        await uploadTask.onComplete;
        print('File 2 Uploaded');
        await storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            _uploadedFileURL2 = fileURL;
          });
        });
      }
    } catch (e) {
      print(e);
      _showDialog("Error", "Please try uploading images again.");
    }
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
          contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*6.2,SizeConfig.safeBlockHorizontal*2,
              SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*2),
          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(10),
          ),
          title: new Text(a,style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize:SizeConfig.safeBlockHorizontal*5),),
          content: new Text(b,style: GoogleFonts.montserrat(
            fontWeight: FontWeight.normal,
            fontSize:SizeConfig.safeBlockHorizontal*4,
            color: Colors.black,
          ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" OK",style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal*3.5
              ),),
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
        draggable: false,
        position: LatLng(DragMarkerMap().whichlat, DragMarkerMap().whichlong),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Future<bool> dontgoback() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*6.2,SizeConfig.safeBlockHorizontal*2,
              SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*2),


          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Discard Form",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: Colors.black,
                fontSize:SizeConfig.safeBlockHorizontal*5
            ),
          ),
          content: Text(
            "Do you want to discard this grievance ?",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize:SizeConfig.safeBlockHorizontal*4

            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(" YES",style: TextStyle(
                  fontSize:SizeConfig.safeBlockHorizontal*3.5
              ),),
              onPressed: () {
                Provider.of<DropDown>(context, listen: false).map(null, null);
                Navigator.pop(context, true);
              },
            ),
            new FlatButton(
              child: new Text(" NO",style: TextStyle(
                  fontSize:SizeConfig.safeBlockHorizontal*3.5
              ),),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // Build a Form widget using the _formKey created above.
    return WillPopScope(
      onWillPop: dontgoback,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          // backgroundColor: Color(0xFFC5CAE9),
          appBar: AppBar(
            title: Text(
              'New Grievance',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: SizeConfig.safeBlockHorizontal * 4.5),
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
            color:Colors.indigo,
            inAsyncCall: showSpinner,
            child: SafeArea(
                child: ListView(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 6,
                        ),
                        ConstiAndCateg(
                            val: Provider.of<DropDown>(context, listen: false)
                                .consti
                                .toUpperCase(),
                            label: 'CONSTITUENCY',
                            icon: Icon(Icons.location_on)),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 4.5,
                        ),
                        ConstiAndCateg(
                            val: widget.category.toUpperCase(),
                            label: 'CATEGORY',
                            icon: Icon(Icons.playlist_add_check)),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 4.5,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    left:  SizeConfig.safeBlockHorizontal * 2,
                                    right:
                                    SizeConfig.safeBlockHorizontal * 2),
                                child: TextFormField(
                                  validator: (description) {
                                    if (description.isEmpty) {
                                      return 'Please provide a brief description of your grievance.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  onChanged: (value) {
                                    description = value;
                                  },
                                  cursorColor: Colors.indigo,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.description,
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.indigo),
                                    ),
                                    labelText: 'DESCRIPTION',
                                    labelStyle: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize:SizeConfig.safeBlockHorizontal*4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 6,
                        ),
                        Container(
                          child: Text(
                            'UPLOAD IMAGES',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize:SizeConfig.safeBlockHorizontal*4.1,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(width: 1.75, color: Colors.grey),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: image1 == null
                                    ? Icon(Icons.insert_photo,size:SizeConfig.safeBlockHorizontal*7,)
                                    : Image.file(
                                  image1,
                                  fit: BoxFit.fill,
                                ),
                                height:SizeConfig.safeBlockVertical * 24.5,
                                width:SizeConfig.safeBlockHorizontal * 40,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockHorizontal * 3,
                            ),
                            GestureDetector(
                              onTap: () {
                                getImage2();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(width: 1.75, color: Colors.grey),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: image2 == null
                                    ? Icon(Icons.insert_photo,size:SizeConfig.safeBlockHorizontal*7)
                                    : Image.file(
                                  image2,
                                  fit: BoxFit.fill,
                                ),
                                height:SizeConfig.safeBlockVertical * 24.5,
                                width:SizeConfig.safeBlockHorizontal * 40,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 7,
                        ),
                        FormButtons(
                          label: 'UPLOAD',
                          width: SizeConfig.safeBlockHorizontal * 36,
                          height: SizeConfig.safeBlockVertical * 5.9,
                          onT: () async {
                            if (image1 == null && image2 == null) {
                              _showDialog("No images selected",
                                  "Please select atleast one image to upload.");
                            } else {
                              setState(() {
                                showSpinner = true;
                              });
                              try {

                                await uploadFile(image1, image2);
                                _showDialog("Upload Successful",
                                    "Selected images uploaded successfully.");
                              } catch (e) {
                                print(e);
                              }

                              setState(() {

                                showSpinner = false;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 6,
                        ),
                        Container(
                          child: Text(
                            'SET LOCATION',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize:SizeConfig.safeBlockHorizontal*4.1,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 6,
                        ),
                        Container(
                          width: 92 *  SizeConfig.safeBlockHorizontal,
                          height:  SizeConfig.safeBlockVertical * 33,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.75, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: (Provider.of<DropDown>(context, listen: false)
                              .whichLong ==
                              null &&
                              Provider.of<DropDown>(context, listen: false)
                                  .whichLong ==
                                  null)
                              ? FlatButton(
                              child: Icon(
                                Icons.location_on,
                                size:SizeConfig.safeBlockHorizontal* 15,
                              ),
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return DragMarkerMap();
                                    }));
                                setState(() {
                                  showSpinner = false;
                                });
                              })
                              : GoogleMap(
                            onMapCreated: _onMapCreated,
                            myLocationEnabled: true,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(DragMarkerMap().whichlat,
                                  DragMarkerMap().whichlong),
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
                          height:SizeConfig.safeBlockVertical * 9,
                        ),
                        FormButtons(
                          label: 'SUBMIT',
                          width: SizeConfig.safeBlockHorizontal * 90,
                          height: SizeConfig.safeBlockVertical * 7,
                          onT: () async {
                            print(i);
                            if (description == '' || description == null){
                              _showDialog("Description empty!",
                                  "Please grive a brief description of your grievance.");
                            }else if(DragMarkerMap().whichlat == null ||
                                DragMarkerMap().whichlong == null){

                              _showDialog("Location Not Selected",
                                  "Please mark the location");
                            }
                            else if ((image1 != null && i == 0) ||
                                (image2 != null && i == 0)) {
                              _showDialog("Image(s) Not Uploaded",
                                  "Please upload the image(s)");

                            }
                            else if (image1 != null && image2 !=null && i<2){
                              _showDialog("Image(s) Not Uploaded",
                                  "Please upload the image(s)");

                            }
                            else {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                setState(() {
                                  showSpinner = true;
                                });
                                showSpinner = true;
                                await createRecord();
                                await statsUpdate();
                                setState(() {
                                  showSpinner = false;
                                });

                                Navigator.pop(context);
                                _showDialog("Grievance Status",
                                    "Grievance Submitted Successfully");
                                Provider.of<DropDown>(context, listen: false)
                                    .map(null, null);
                              } else {
                                print('description empty!!!');
                                _showDialog("Description Empty",
                                    "Please grive a brief description of your grievance.");
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height:SizeConfig.safeBlockVertical * 6,
                        )
                      ],
                    )
                  ],
                )),
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
        enabled: false,
        initialValue: val,
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.normal),
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
            fontSize:SizeConfig.safeBlockHorizontal*4,
          ),
        ),
      ),
    );
  }
}

class FormButtons extends StatelessWidget {
  String label;
  double width;
  double height;
  Function onT;
  FormButtons({this.label, this.width, this.height, this.onT});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: InkWell(
        onTap: onT,
        child: Material(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.indigo,
          elevation: 5.0,
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}