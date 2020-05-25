import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/Authentication/LoginPage.dart';
import 'package:voter_grievance_redressal/HomePage/About.dart';
import 'package:voter_grievance_redressal/HomePage/Settings.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/HomePage/Feedback.dart';
import 'package:voter_grievance_redressal/HomePage/EditProfile.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  var snackbar = SnackBar(
      behavior:SnackBarBehavior.floating ,
      content: Text("Feature to be added soon.",style: GoogleFonts.montserrat(
          color: Colors.white),
      ),
      duration: Duration(seconds: 1),
      elevation: 10.0);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  Container(
                    height: SizeConfig.safeBlockVertical*10,
                    width: SizeConfig.safeBlockVertical*10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          50.0,
                        ),
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage('assets/HomePage/user.png'),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical*1.5,
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                        (Provider.of<DropDown>(context, listen: false).name ==
                          null || Provider.of<DropDown>(context, listen: false).name ==
                            '')
                          ? "Hello, "+Provider.of<DropDown>(context, listen: false).email.split('@')[0]
                          : "Hello, "+Provider.of<DropDown>(context, listen: false).name.split(' ')[0] ,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: SizeConfig.blockSizeHorizontal*5.5),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home',style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.safeBlockHorizontal*3.5),),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Profile',style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.safeBlockHorizontal*3.5),),
              onTap: () {Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return EditProfile();
                  }));},
            ),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings',style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.safeBlockHorizontal*3.5),),
                onTap: ()  {Navigator.push(context,
            MaterialPageRoute(builder: (context) {
            return Settings();
            }));},
            ),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('Feedback',style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.safeBlockHorizontal*3.5),),
              onTap: () {Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return FeedbackSubmit();
                  }));},
            ),

//            ListTile(
//              leading: Icon(Icons.help),
//              title: Text('Help',style: GoogleFonts.montserrat(
//                  fontWeight: FontWeight.w500,
//                  fontSize: SizeConfig.safeBlockHorizontal*3.5),),
//              onTap: () {Navigator.of(context).pop();
//              Scaffold.of(context).showSnackBar(snackbar);},
//            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('About',style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.safeBlockHorizontal*3.5),),
              onTap: (){Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return About();
                  }));},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout',style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.safeBlockHorizontal*3.5),),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*6.2,SizeConfig.safeBlockHorizontal*2,
                          SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*2),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        "Logout",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize:SizeConfig.safeBlockHorizontal*5
                        ),
                      ),
                      content: Text(
                        "Do You want to Log Out ?",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize:SizeConfig.safeBlockHorizontal*4

                        ),
                      ),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text(" YES",style: TextStyle(
                              fontSize:SizeConfig.safeBlockHorizontal*3.5
                          ),),
                          onPressed: () async {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.remove('email');
                            prefs.remove('name');
                            prefs.remove('phone');
                            prefs.remove('constituency');
                            Provider.of<DropDown>(context, listen: false)
                                .setEmail(' ');
                            Provider.of<DropDown>(context, listen: false)
                                .setUserInfo(' ', ' ', ' ');
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context) => LoginPage()
                            ), ModalRoute.withName("/home"));
                          },
                        ),
                        new FlatButton(
                          child: new Text(" NO",style: TextStyle(
                              fontSize:SizeConfig.safeBlockHorizontal*3.5
                          ),),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}