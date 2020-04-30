import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voter_grievance_redressal/HomePage/BottomNavBar.dart';
import 'Department.dart';

class RaiseGrievance extends StatefulWidget {
  @override
  _RaiseGrievanceState createState() => _RaiseGrievanceState();
}

class _RaiseGrievanceState extends State<RaiseGrievance> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 6);
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return BottomNavBar();
            }));

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
          appBar:  AppBar(
            title: Text('Raise A New Issue'),
            centerTitle: true,
            backgroundColor: Colors.indigo,
            elevation: 10.0,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),

          ),
          body: ListView(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),

//              Padding(
//                padding: EdgeInsets.only(left: 10.0),
//                child: Text('All Categories',
//                    style: TextStyle(
//                        fontFamily: 'Quicksand',
//                        fontWeight: FontWeight.bold,
//                        fontSize: 25.0)),
//              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.075),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: TabBarView(
                    controller: tabController,
                    children: <Widget>[

                      new DeptPage(),
                      new DeptPage(),
                      new DeptPage(),
                      new DeptPage(),
                      new DeptPage(),
                      new DeptPage(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),

            ],
          )),
    );

  }

}