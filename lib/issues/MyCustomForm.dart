import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voter_grievance_redressal/issues/constants.dart';
import 'package:voter_grievance_redressal/home/build_home.dart';
import 'imageCards.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:voter_grievance_redressal/issues/drag_marker_map.dart';
import 'package:voter_grievance_redressal/issues/drag_marker_map.dart';

final databaseReference = Firestore.instance;
FirebaseUser loggedInUser;

// ignore: must_be_immutable
class MyCustomForm extends StatefulWidget {
  String category;

  MyCustomForm(String value) {
    this.category = value;
  }

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  File _image, _image2, _image3, _image4,imageu1,imageu2;
  final _auth = FirebaseAuth.instance;
  String description;
  final myController = TextEditingController();
  String _uploadedFileURL1 = '';
  String _uploadedFileURL2 = '';
  bool showSpinner = false;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

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

  void createRecord() async {
    try {
      DragMarkerMap ob = new DragMarkerMap();
      bool flag;
      ob.whichlat == null || ob.whichlong == null ? flag = false : flag = true;

      await databaseReference
          .collection(loggedInUser.email)
          .document(widget.category.toUpperCase())
          .collection(widget.category.toUpperCase() + "Grievances")
          .document() // by default it goes to bbmp document...but this can be changed
          .setData({
        'Constituency': buildhome.whichConstituency.toUpperCase(),
        'Category': widget.category,
        'Description': myController.text,
        'Image1': _uploadedFileURL1,
        'Image2': _uploadedFileURL2,
        'Created': FieldValue.serverTimestamp(),
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
    imageu1=image;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(imageu1.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(imageu1);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL1 = fileURL;
      });
    });
  }

  Future uploadFile2(File image2) async {
    imageu2=image2;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(imageu2.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(imageu2);
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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Submit A New Grievance'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black38,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 13, top: 17.0),
                      child: Text(
                        buildhome.whichConstituency
                            .toUpperCase(), // this variable coming from build_home.dart file
                        style: kConstituencyTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black38,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 13, top: 17.0),
                      child: Text(
                        widget
                            .category, // this variable coming from cards/ReusableCard.dart file
                        style: kConstituencyTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Upload Images',
                    style: kConstituencyTextStyle,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black38,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ReusableCard2(
                            value: 'IMAGE 1',
                            onPressed1: _getImage,
                            onPressed2: _getImage2,
                            image1: _image,
                            image2: _image2,
                          ),
                        ),
                        Expanded(
                          child: ReusableCard2(
                            value: 'IMAGE 2',
                            onPressed1: _getImage3,
                            onPressed2: _getImage4,
                            image1: _image3,
                            image2: _image4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Upload Image 1'),
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });

                          try {
                            if (_image != null) {
                              await uploadFile(_image);
                            }
                            if (_image2 != null) {
                              await uploadFile(_image2);
                            }

                            setState(() {
                              showSpinner = false;
                              _showDialog("Image Upload Status",
                                  "Image Uploaded Successfully");
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        color: Colors.deepOrange,
                      ),
                      SizedBox(
                        width: 75,
                      ),
                      RaisedButton(
                        child: Text('Upload Image 2'),
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });

                          try {
                            if (_image3 != null) {
                              await uploadFile2(_image3);
                            }
                            if (_image4 != null) {
                              await uploadFile2(_image4);
                            }
                            setState(() {
                              showSpinner = false;
                              _showDialog("Image Upload Status",
                                  "Image Uploaded Successfully");
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextFormField(
                      controller: myController,
                      decoration: InputDecoration(
                        hintText: 'Enter your Grievance',
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: EdgeInsets.all(15),
                        labelStyle: TextStyle(
                          fontSize: 23.0,
                        ),
                      ),
                      maxLines: 15,

                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          _showDialog("Description Empty",
                              "Description cannot be empty");
                          return 'Please enter grievance category';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Set Location',
                    textAlign: TextAlign.left,
                    style: kConstituencyTextStyle,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black38,
                        width: 1,
                      ),
                    ),
                    child: (DragMarkerMap().whichlat == null ||
                            DragMarkerMap().whichlong == null)
                        ? FlatButton(
                            child: Icon(
                              Icons.location_on,
                              size: 75,
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DragMarkerMap();
                              }));
                            })
                        : Center(
                            child: Text(
                              "Latitude : \n\nLongitude :",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                    //child: DragMarkerMap(),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                      child: Container(
                        child: Center(
                          child: Text(
                            'SUBMIT',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        color: Colors.deepOrange,
                        height: 50,
                      ),
                      onTap: () {
                        if (imageu1 == null &&
                            imageu2 == null
                            )
                          _showDialog(
                              "No Image Uploaded", "Upload atleast 1 Image ");
                        else if (DragMarkerMap().whichlat == null ||
                            DragMarkerMap().whichlong == null)
                          _showDialog("Location Not Selected",
                              "Please mark the location");
                        else if (myController.text=="")
                          _showDialog("Description Empty",
                              "Please type the description");
                        else {
                          createRecord();
                          setState(() {
                            DragMarkerMap().whichlat = null;
                            DragMarkerMap().whichlong = null;
                          });
                          Navigator.pop(context);
                          _showDialog("Grievance Status",
                              "Grievance Submitted Successfully");
                        }
                      }),
                ]),
              ),
            )),
      ),
    );
  }
}
