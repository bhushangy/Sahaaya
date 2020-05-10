import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voter_grievance_redressal/HomePage/EditProfile.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetails extends StatelessWidget {
  int num;
  String mail;

  ContactDetails({this.num,this.mail});
  void _launchCaller()async
  {
    var url="tel:${num.toString()}";
    if (await canLaunch(url)) {
  await launch(url);
  } else {
  throw 'Could not launch $url';
  }
  }
  void _launchEmail()async
  {
    var url="mailto:$mail?subject=From Sahaaya App ";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(150, 20, 150, 20),
            child: Container(
              height: MediaQuery.of(context).size.height*0.01,
              width: MediaQuery.of(context).size.width*0.2,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(const Radius.circular(8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0,left: 10),
            child: Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Text('Contact',
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          textStyle: TextStyle(fontWeight: FontWeight.normal),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0,left: 10),
            child: GestureDetector(
              onTap: _launchCaller,
              child: Container(
                width: double.infinity,
                height: 50.0,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 7,
                    ),
                    Icon(Icons.phone, size: 35.0, color: Colors.indigo),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Text(
                        num.toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0,left: 10),
            child: GestureDetector(
              onTap: _launchEmail,
              child: Container(
                width: double.infinity,
                height: 50.0,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 7,
                    ),
                    Icon(Icons.email,
                        size: 35.0, color: Colors.indigo),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Text(
                        mail,
                        style: GoogleFonts.montserrat(
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
