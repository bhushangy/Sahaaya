import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/Statistics/stat.dart';
import 'package:voter_grievance_redressal/cards/raise.dart';
import 'package:voter_grievance_redressal/home/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';


class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int _currentIndex = 0;

  final List<Widget> children = [
    HomePage(),
    raiseIssue(),
    Statistics(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 13,
            elevation: 15,
            onTap: _onItemTapped,
            currentIndex: _currentIndex,

            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 22,),
                title: Text(
                  'Home',
                  style: GoogleFonts.montserrat(
                      fontSize: 13.0, fontWeight: FontWeight.w600),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.error_outline, size: 22,),
                title: Text(
                  'New Grievance',
                  style: GoogleFonts.montserrat(
                      fontSize: 13.0, fontWeight: FontWeight.w600),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart, size: 22,),
                title: Text(
                  'Statistics',
                  style: GoogleFonts.montserrat(
                      fontSize: 13.0, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            selectedItemColor: Colors.indigo,
          ),
        );


  }
}