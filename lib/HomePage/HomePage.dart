import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';
import 'NavDrawer.dart';


FirebaseUser loggedInUser;

class HomePage extends StatefulWidget {
  static String whichConstituency = _HomePageState.constituency[0];
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  String name,consti;
  bool expanded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  final _db = Firestore.instance;

  static List<String> constituency = [
    'Yalahanka',
    'Malleshwaram',
    'Vidyaranyapura',
    'Jayanagara',
    'Yeshvanthapura'
  ];


  final snackbar = SnackBar(
      behavior:SnackBarBehavior.floating ,
      content: Text("Scores Updated.",style: GoogleFonts.montserrat(
          color: Colors.white),
      ),
      duration: Duration(seconds: 1),
      elevation: 10.0);

  void initState(){
    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print(data);
        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Scaffold.of(context).showSnackBar(snackbar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Scaffold.of(context).showSnackBar(snackbar);

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Scaffold.of(context).showSnackBar(snackbar);

      },
    );
  }

  @override
  void dispose() {
    if (iosSubscription != null) iosSubscription.cancel();
    super.dispose();
  }

  _saveDeviceToken() async {
    // Get the current user
    String uid = Provider.of<DropDown>(context,listen: false).email;
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('UserInfo')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
      });
    }
  }

  /// Subscribe the user to a topic
  _subscribeToTopic() async {
    // Subscribe the user to a topic
    _fcm.subscribeToTopic('puppies');
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async{
        if(_scaffoldKey.currentState.isDrawerOpen){
          Navigator.of(context).pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.42,
                      width: double.infinity,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.28,
                      width: double.infinity,
                      color: Colors.indigo,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.filter_list,size: SizeConfig.safeBlockHorizontal*6.5),
                              onPressed:  (){_scaffoldKey.currentState.openDrawer();},
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Sahaaya',
                                style: GoogleFonts.montserrat(
                                    fontSize: SizeConfig.safeBlockHorizontal*5.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: (){},
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.indigo,

                              )),

                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.19,
                      left:MediaQuery.of(context).size.width * 0.04,
                      right:MediaQuery.of(context).size.width * 0.04,
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(7.0),
                        child: Container(
                          height:MediaQuery.of(context).size.height * 0.185,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.135,
                      left: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.width*0.13),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.13,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              50.0,
                            ),
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage('assets/HomePage/user.png'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.265),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                  (Provider.of<DropDown>(context,listen: false).name == null || Provider.of<DropDown>(context,listen: false).name == '')?Provider.of<DropDown>(context,listen: false).email: Provider.of<DropDown>(context,listen: false).name,
                                style: GoogleFonts.montserrat(
                                    fontSize: SizeConfig.safeBlockHorizontal*5, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.31),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                  (Provider.of<DropDown>(context,listen: false).constituency == null ||Provider.of<DropDown>(context,listen: false).constituency == '')? "Bengaluru": Provider.of<DropDown>(context,listen: false).constituency,
                                style: GoogleFonts.montserrat(
                                    fontSize: SizeConfig.safeBlockHorizontal*3.9,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              CarouselSlider(
                items: <Widget>[
                  menuCard(
                      context,
                      'Announcement',
                      'assets/HomePage/announcement.png',
                      'BWSSB to lay out new pipelines in North Bengaluru.'
                  ),
                  menuCard(
                      context, 'Announcement', 'assets/HomePage/announcement.png','New version of the Sahaaya App is now available in play store.'),

                ],
                height: MediaQuery.of(context).size.height*0.17,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
                autoPlayAnimationDuration: Duration(milliseconds: 1200),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              SizedBox(
                height:MediaQuery.of(context).size.height*0.03,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04),
                child: Material(
                  borderRadius: BorderRadius.circular(7.0),
                  elevation: 0.0,
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.17,
                    width: MediaQuery.of(context).size.width * 0.92,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Colors.white),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                        Container(
                          height:MediaQuery.of(context).size.height*0.14,
                          width:MediaQuery.of(context).size.width*0.25,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/HomePage/dropdown2.png'),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(7.0)),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.06),
                        Column(
                          children: <Widget>[
                            SizedBox(height: MediaQuery.of(context).size.height*0.035),
                            Container(
                              child: DropdownButton<String>(
                                elevation: 2,
                                value: Provider.of<DropDown>(context,
                                    listen: false)
                                    .consti,
                                icon: Icon(Icons.arrow_drop_down_circle),
                                iconSize: SizeConfig.safeBlockHorizontal*6,
                                onChanged: (String newValue) async {
                                  setState(() {
                                    Provider.of<DropDown>(context,
                                        listen: false)
                                        .changeState(newValue);
                                    //  dropdownValue = newValue;
                                    HomePage.whichConstituency =
                                        Provider.of<DropDown>(context,
                                            listen: false)
                                            .consti;
                                    //print(buildhome.whichConstituency);
                                  });
                                },
                                items: constituency
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontSize:SizeConfig.safeBlockHorizontal*4.2,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height:MediaQuery.of(context).size.height*0.033,
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.18,
                child: ListView(
                  physics: ScrollPhysics(parent: PageScrollPhysics()),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    menuCard(
                        context,
                        'How it works ?',
                        'assets/HomePage/howitworks.png',
                        'Swipe left to find out how to submit your grievance.'
                    ),
                    menuCard(
                        context, 'How it works ?', 'assets/HomePage/dropdown2.png','Select the constituency from the dropdown above.'),
                    menuCard(
                        context, 'How it works ?', 'assets/HomePage/tap.png','Tap on New Grievance button below and select Raise Issue.'),
                    menuCard(
                        context, 'How it works ?', 'assets/HomePage/form.png','Fill the form with proper details and tap on Submit.'),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Widget menuCard(BuildContext context, String announcemnet, String imgPath,String txt) {
  return Padding(
    padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.04),
    child: Material(
      borderRadius: BorderRadius.circular(7.0),
      elevation: 0.0,
      child: Container(
        height: MediaQuery.of(context).size.height*0.15,
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0), color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: MediaQuery.of(context).size.width*0.03,),
            Container(
              height:MediaQuery.of(context).size.height*0.14,
              width:MediaQuery.of(context).size.width*0.25,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imgPath), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(7.0)),
            ),
            SizedBox(width:MediaQuery.of(context).size.width*0.06,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height*0.02),
                Container(
                  width: SizeConfig.safeBlockHorizontal*32,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        announcemnet,
                        style: GoogleFonts.montserrat(
                            fontSize: SizeConfig.safeBlockHorizontal*4.2, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01),
                Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.2,
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(
                      txt,
                      style: GoogleFonts.montserrat(
                          fontSize: SizeConfig.safeBlockHorizontal*3.6, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}