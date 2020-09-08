import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/screens/home/BottomNavBar.dart';
import 'package:voter_grievance_redressal/screens/new_grievance/Department.dart';
import 'package:voter_grievance_redressal/util/SizeConfig.dart';



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
    SizeConfig().init(context);
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
            title: Text(
              'Select Category',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: SizeConfig.safeBlockHorizontal * 4.2),
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
          body: ListView(
            children: <Widget>[
              SizedBox(
                height: SizeConfig.safeBlockVertical*4.2,
              ),
              Padding(
                padding: EdgeInsets.only(top:SizeConfig.safeBlockVertical*8),
                child: Container(
                  height: SizeConfig.safeBlockVertical * 60,
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
              SizedBox(height: SizeConfig.safeBlockVertical*5),
            ],
          )),
    );

  }

}