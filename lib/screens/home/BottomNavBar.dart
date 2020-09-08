import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/screens/home/HomePage.dart';
import 'package:voter_grievance_redressal/screens/new_grievance/RaiseGrievance.dart';
import 'package:voter_grievance_redressal/screens/statistics/Ranking.dart';
import 'package:voter_grievance_redressal/util/SizeConfig.dart';


FirebaseUser loggedInUser;
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> children = [
    HomePage(),
    RaiseGrievance(),
    Ranking(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo,
      statusBarIconBrightness: Brightness.light,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
          body: children[_currentIndex],
          bottomNavigationBar:BottomNavigationBar(
              backgroundColor: Colors.white,

              type: BottomNavigationBarType.fixed,
              selectedFontSize: 13,
              elevation: 5,
              onTap: _onItemTapped,
              currentIndex: _currentIndex,

              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size:SizeConfig.safeBlockHorizontal * 5.1),
                  title: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Home',
                      style: GoogleFonts.montserrat(
                          fontSize: SizeConfig.safeBlockVertical * 1.6, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.error, size:SizeConfig.safeBlockHorizontal * 5.1,),
                  title: FittedBox(
                    fit: BoxFit.contain,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'New Grievance',
                        style: GoogleFonts.montserrat(
                            fontSize: SizeConfig.safeBlockVertical * 1.6, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.insert_chart, size:SizeConfig.safeBlockHorizontal * 5.1,),
                  title: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Statistics',
                      style: GoogleFonts.montserrat(
                          fontSize: SizeConfig.safeBlockVertical * 1.6, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
              selectedItemColor: Colors.indigo,
            ),

        );


  }
}