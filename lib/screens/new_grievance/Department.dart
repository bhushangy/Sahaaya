import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/screens/new_grievance/FillForm.dart';
import 'package:voter_grievance_redressal/screens/old_grievance/RetrieveGrievances.dart';
import 'package:voter_grievance_redressal/util/SizeConfig.dart';



FirebaseUser loggedInUser;

// ignore: must_be_immutable
class DeptPage extends StatefulWidget {
  @override
  _DeptPageState createState() => _DeptPageState();
}

class _DeptPageState extends State<DeptPage> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        _buildDeptCard('assets/Departments/bwssb.png', 'BWSSB'),
        _buildDeptCard('assets/Departments/bescom.png', 'BESCOM'),
        _buildDeptCard('assets/Departments/sewer.png', 'SANITATION'),
        _buildDeptCard('assets/Departments/roads.png', 'ROADS'),
        _buildDeptCard('assets/Departments/corruption.png','CORRUPTION'),
        _buildDeptCard('assets/Departments/others.png','OTHERS'),
      ],
    );
  }

  Widget _buildDeptCard(String img, String category) {
    return ListView(
      shrinkWrap: true,
      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left:SizeConfig.safeBlockHorizontal*5,top:SizeConfig.safeBlockVertical*4.2 ),
          child: Container(
              height: SizeConfig.safeBlockVertical*50,
              width: SizeConfig.safeBlockHorizontal*62,
              decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(children: [
                SizedBox(height: SizeConfig.safeBlockVertical*2.5,),
                Image.asset(img, fit: BoxFit.cover, height: SizeConfig.safeBlockVertical*15),
                SizedBox(height: SizeConfig.safeBlockVertical*3,),
                Padding(
                  padding:EdgeInsets.only(left:SizeConfig.safeBlockHorizontal*5, right: SizeConfig.safeBlockHorizontal*4,),
                  child: Container(
                    height: SizeConfig.safeBlockVertical*6,
                    width: SizeConfig.safeBlockHorizontal*55,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(category,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: SizeConfig.safeBlockHorizontal*1),),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.safeBlockHorizontal*7.5,),
                InkWell(
                    onTap: () async {
                      try {
                        final user = await _auth.currentUser();
                        if (user != null) {
                          loggedInUser = user;
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FillForm(category, loggedInUser.email);
                        }));
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      height: SizeConfig.safeBlockVertical*6,
                      width: SizeConfig.safeBlockHorizontal*43,
                      decoration: BoxDecoration(
                          color: Color(0xffe0e0e0).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Raise Issue',
                            style: GoogleFonts.montserrat(

                                color: Colors.black,
                                fontSize:SizeConfig.safeBlockHorizontal*4.1),
                          ),
                        ),
                      ),
                    )),
                SizedBox(height:  SizeConfig.safeBlockVertical*3),
                InkWell(
                    onTap: () async {
                      try {
                        final user = await _auth.currentUser();
                        if (user != null) {
                          loggedInUser = user;
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RetrieveGrievances(category, loggedInUser.email);
                        }));
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      height: SizeConfig.safeBlockVertical*6,
                      width: SizeConfig.safeBlockHorizontal*43,
                      decoration: BoxDecoration(
                          color: Color(0xffe0e0e0).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Previous Issues',
                            style: GoogleFonts.montserrat(

                                color: Colors.black,
                                fontSize:SizeConfig.safeBlockHorizontal*4.1),
                          ),
                        ),
                      ),
                    )),
              ])),
        )
      ],
    );
  }
}
