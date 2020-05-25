import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voter_grievance_redressal/HomePage/ContactDetails.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';
import 'package:voter_grievance_redressal/SizeConfig/SizeConfig.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

  bool showSpinner=false;
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sahaaya",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: Colors.white, fontSize: SizeConfig.safeBlockHorizontal*5),
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
            Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text(
                      'Developers',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,  fontSize: SizeConfig.safeBlockHorizontal*5),
                    ),
                  ],
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView(
                      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        StatsCard(
                            cat: 'Bhushan G Y',
                            imgPath: 'assets/images/bhu.jpeg',
                            url1: "https://github.com/bhushangy",
                            url2: "https://www.linkedin.com/in/bhushangy/",
                            number: 7349693582,
                            email: "bhushangy44@gmail.com",
                            txtColor: Color(0xFF000000)),
                        StatsCard(
                            cat: 'Bansuri J S',
                            imgPath: 'assets/images/ban.jpeg',
                            url1: "https://github.com/bansuri0100",
                            url2: "https://www.linkedin.com/in/bansuri-j-sanganal-b25a67169/",
                            number: 8792373687,
                            email: "bansuri0100@gmail.com",
                            txtColor: Color(0xFF000000)),
                      ]
                  ),
                ),

                Row(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text(
                      'About the App',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,  fontSize: SizeConfig.safeBlockHorizontal*5),
                    ),
                  ],
                ),
                ListBody(
                  children: <Widget>[
                    new Container(
                      height: SizeConfig.safeBlockVertical*1,
                    ),
                    new ListTile(
                      leading: new Icon(Icons.info),
                      title: Text('App Name',style: GoogleFonts.montserrat(fontSize: SizeConfig.safeBlockHorizontal*3.75),),
                      subtitle: new Text(Provider.of<DropDown>(context, listen: false).a,style: GoogleFonts.montserrat(
                          fontSize:SizeConfig.safeBlockHorizontal*3.4
                      ),),
                    ),

                    new Divider(
                      height: SizeConfig.safeBlockVertical*0.1,
                    ),
                    new ListTile(
                      leading: new Icon(Icons.info),
                      title:  Text('Version Number',style: GoogleFonts.montserrat(fontSize:SizeConfig.safeBlockHorizontal*3.75),),
                      subtitle: new Text(Provider.of<DropDown>(context, listen: false).c,style: GoogleFonts.montserrat(fontSize:SizeConfig.safeBlockHorizontal*3.4),),
                    ),

                    new Divider(
                      height: SizeConfig.safeBlockVertical*0.1,
                    ),
                    new ListTile(
                      leading: new Icon(Icons.info),
                      title:  Text('Latest Update',style: GoogleFonts.montserrat(fontSize:SizeConfig.safeBlockHorizontal*3.75),),
                      subtitle: new Text("24-05-2020",style: GoogleFonts.montserrat(fontSize:SizeConfig.safeBlockHorizontal*3.4),),
                    ),
                    new Divider(
                      height: SizeConfig.safeBlockVertical*0.1,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.018,
                    ),

                    Container(
                      height: SizeConfig.safeBlockVertical*6,
                      padding: EdgeInsets.only(
                          left: SizeConfig.safeBlockHorizontal * 20,
                          right: SizeConfig.safeBlockHorizontal * 20),
                      child: InkWell(
                        onTap: ()async{
                          _launchURL("https://play.google.com/store/apps/details?id=com.miniproject.voter_grievance_redressal");
                        },
                        child: Material(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.indigo,
                        elevation: 5.0,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Check For Updates',
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
          ],
        ),
      ),
    );
  }
}
class StatsCard extends StatelessWidget {
  String cat, imgPath,url1,url2,email;
  int number;
  Color txtColor;
  StatsCard({this.cat, this.imgPath,this.txtColor,this.url1
    ,this.url2,this.number,this.email});
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.5,
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.grey, width: 0.4),
//          borderRadius: BorderRadius.circular(15.0),
//        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.09,
            width: MediaQuery.of(context).size.height * 0.09,
            decoration:
            BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: Image.asset(
                imgPath,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical*2.75,),
          Text(
            cat,
            style: GoogleFonts.montserrat(
                fontSize: SizeConfig.safeBlockHorizontal*4.5, color: txtColor, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical*2.5,),
          InkWell(
              onTap: () async{
                _launchURL(url1);
              },
              child: Container(
                height: SizeConfig.safeBlockVertical*4,
                width: SizeConfig.safeBlockHorizontal*30,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Center(
                  child: Text(
                    'Github',
                    style: GoogleFonts.montserrat(

                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockHorizontal*4.5),
                  ),
                ),
              )),
          SizedBox(height: SizeConfig.safeBlockVertical*2.2),
          InkWell(
              onTap: () async{
                _launchURL(url2);
              },
              child: Container(
                height: SizeConfig.safeBlockVertical*4,
                width: SizeConfig.safeBlockHorizontal*30,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Center(
                  child: Text(
                    'LinkedIn',
                    style: GoogleFonts.montserrat(

                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockHorizontal*4.5),
                  ),
                ),
              )),
          SizedBox(height: SizeConfig.safeBlockVertical*2.2),
          InkWell(
              onTap: () async{
                showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  backgroundColor: Color(0xFF757575),
                  context: context,
                  builder: (context) => ContactDetails(
                      num:number,mail:email),
                );
              },
              child: Container(
                height: SizeConfig.safeBlockVertical*4,
                width: SizeConfig.safeBlockHorizontal*30,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Center(
                  child: Text(
                    'Contact',
                    style: GoogleFonts.montserrat(

                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockHorizontal*4.5),
                  ),
                ),
              )),
          SizedBox(height: SizeConfig.safeBlockVertical*2.2),

        ],
      ),
    );

  }
}