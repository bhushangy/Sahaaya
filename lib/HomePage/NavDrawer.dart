import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/Authentication//LoginPage.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
             Provider.of<DropDown>(context, listen: false).name ==
                      null
                  ? Provider.of<DropDown>(context, listen: false).email
                  : Provider.of<DropDown>(context, listen: false).name ,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Welcome'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text('About'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(
                      "Logout",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                    content: Text(
                      "Do You want to Log Out ?",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new FlatButton(
                        child: new Text(" YES"),
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext ctx) => LoginPage()));
                        },
                      ),
                      new FlatButton(
                        child: new Text(" NO"),
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
    );
  }
}
