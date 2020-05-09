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
            child: Column(
              children: <Widget>[
//                RawMaterialButton(
//                  onPressed: () {},
//                  elevation: 2.0,
//                  fillColor: Colors.white,
//                  child: Icon(
//                    Icons.person,
//                    size: 60.0,
//                  ),
//                  padding: EdgeInsets.all(2.0),
//                  shape: CircleBorder(),
//                ),
                Container(
                  height: 70,
                  width: 70,
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
                  height: 10,
                ),
                Text(
                 Provider.of<DropDown>(context, listen: false).name ==
                          null
                      ? "Hello, "+Provider.of<DropDown>(context, listen: false).email.split('@')[0]
                      : "Hello, "+Provider.of<DropDown>(context, listen: false).name.split(' ')[0] ,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 23),
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
                fontSize: 14),),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile',style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 14),),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings',style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 14),),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback',style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 14),),
            onTap: () => {Navigator.of(context).pop()},
          ),

          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help',style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 14),),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('About',style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 14),),
            onTap: () => {Navigator.of(context).pop()},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
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
                child: Container(
                  width: MediaQuery.of(context).size.width*0.4,
                  height: MediaQuery.of(context).size.height*0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.indigo),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Logout",textAlign: TextAlign.center,style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 18),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
