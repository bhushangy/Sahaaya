import 'package:flutter/material.dart';
import 'package:voter_grievance_redressal/issues/my_issues.dart';
import 'package:voter_grievance_redressal/cards/raise_issues.dart';
import 'package:voter_grievance_redressal/home/build_home.dart';


class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  int _currentIndex=0;

  final List<Widget> _children=
  [
    buildhome(),
    raise(),
    myissues(),

  ];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex= index;
    });
  }





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(

          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(

            onTap: _onItemTapped,
            currentIndex: _currentIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),

              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_alert),

                title: Text('Raise Issue'),

              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.timelapse),
                title: Text('My Issues'),
              ),

            ],
            selectedItemColor: Colors.deepOrange,
          ),
        ));

  }

}