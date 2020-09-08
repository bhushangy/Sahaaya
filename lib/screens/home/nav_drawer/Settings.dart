import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/screens/home/nav_drawer/ChangePassword.dart';
import 'package:voter_grievance_redressal/util/SizeConfig.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: SizeConfig.safeBlockHorizontal*4.5),
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
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.safeBlockVertical*4,
                ),
                Container(
                  height: SizeConfig.safeBlockVertical*7,
                  padding: EdgeInsets.only(
                      left: SizeConfig.safeBlockHorizontal * 3,
                      right: SizeConfig.safeBlockHorizontal * 50),
                  child: InkWell(
                    onTap: (){Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return ChangePassword();
                        }));},
                    child: Material(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(30.0),
                      shadowColor: Colors.indigo,
                      elevation: 5.0,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Change Password',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize:
                              SizeConfig.safeBlockHorizontal * 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
