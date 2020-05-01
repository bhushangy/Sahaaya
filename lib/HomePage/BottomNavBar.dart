import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/NewGrievance/RaiseGrievance.dart';
import 'package:voter_grievance_redressal/Statistics/Ranking.dart';
import 'package:voter_grievance_redressal/HomePage/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';


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
          bottomNavigationBar: SizedBox(
            height: 49,
            child: BottomNavigationBar(
              backgroundColor: Colors.white,

              type: BottomNavigationBarType.fixed,
              selectedFontSize: 13,
              elevation: 5,
              onTap: _onItemTapped,
              currentIndex: _currentIndex,

              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 20,),
                  title: Text(
                    'Home',
                    style: GoogleFonts.montserrat(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.error, size: 20,),
                  title: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'New Grievance',
                      style: GoogleFonts.montserrat(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.insert_chart, size: 20,),
                  title: Text(
                    'Statistics',
                    style: GoogleFonts.montserrat(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              selectedItemColor: Colors.indigo,
            ),
          ),
        );


  }
}