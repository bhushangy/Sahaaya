import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactDetails extends StatelessWidget {
  int Num1, Num2;
  String Office;

  ContactDetails({this.Num1,this.Num2,this.Office});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
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
                      Num1.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0,left: 10),
            child: Container(
              width: double.infinity,
              height: 50.0,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 7,
                  ),
                  Icon(Icons.phone,
                      size: 35.0, color: Colors.indigo),
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Text(
                      Num2.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0,left: 10),
            child: Container(
              width: double.infinity,
              height: 50.0,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 7,
                  ),
                  Icon(
                    Icons.location_on,
                    size: 35.0,
                    color: Colors.indigo,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Text(
                      Office,
                      style: GoogleFonts.montserrat(
                        fontSize: 13.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 45.0,
          ),
        ],
      ),
    );
  }
}
