import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:voter_grievance_redressal/Authentication/LoginPage.dart';
import 'package:voter_grievance_redressal/Authentication/SignupPage.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';


class FactsScreen extends StatefulWidget {
  @override
  _FactsScreenState createState() => _FactsScreenState();
}

class _FactsScreenState extends State<FactsScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          FactPages(
              index: 0,
              img: 'angry.png',
              txt:
                  'Have issues in your neighborhood that needs an ear ?'),
          FactPages(
              index: 1,
              img: 'report.png',
              txt:
                  'Report it here using the Sahaaya app to the concerned authority.'),
          FactPages(
              index: 2,
              img: 'ranking.png',
              txt: 'See where your constituency stands.'),
        ],
      ),
    );
  }
}

class FactPages extends StatelessWidget {
  String img, txt;
  int index;
  FactPages({this.index, this.img, this.txt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical*30),
          child: Container(
            width: SizeConfig.blockSizeHorizontal*30,
            height:SizeConfig.safeBlockVertical*20 ,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/FactsScreen/$img'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          height:  SizeConfig.safeBlockVertical*8,
        ),
        Flexible(
          child: Container(
            width:SizeConfig.safeBlockHorizontal*75,
            child: Text(
              '$txt',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize:SizeConfig.safeBlockHorizontal*5, fontWeight: FontWeight.normal)
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.safeBlockVertical*9,
        ),
        index == 2
            ? Column(
                children: <Widget>[
                  Container(
                    width: SizeConfig.safeBlockHorizontal*60,
                    height:SizeConfig.safeBlockVertical*7,
                    child: InkWell(
                      onTap: () =>  Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          })),
                      child: Material(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(5.0),
                        shadowColor: Colors.black38,
                        elevation: 10.0,
                        child: Center(
                          child: FittedBox(
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            child: Text(
                              'Get Started',
                              style: GoogleFonts.montserrat(
                                fontSize:SizeConfig.safeBlockHorizontal*4 ,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
