import 'package:flutter/material.dart';
import 'package:voter_grievance_redressal/home/home_page.dart';
import 'navdrawer.dart';

class buildhome extends StatefulWidget {

  static String whichConstituency = _buildhomeState.constituency[0];
  @override
  _buildhomeState createState() => _buildhomeState();
}

class _buildhomeState extends State<buildhome> {
  double rating = 5.0;
  String mlaname = "S.R. Vishwanath";
  String mpname = "D.V. Sadananda Gowda";
  String mparea = "Bengaluru North";
  String user_name = "Kobe Bryant";
  static List<String> constituency = ['Yalahanka','Malleshwaram','Vidyaranyapura'];
  String dropdownValue = constituency[0];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          leading: null,
          actions: <Widget>[

          ],
          centerTitle: true,
          title: Text("Welcome $user_name !!"),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Text('Select Constituency',
                    style:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        buildhome.whichConstituency = dropdownValue;
                        //print(buildhome.whichConstituency);
                      });
                    },
                    items: constituency.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Center(
                child: Text('Constituency Score',
                    style:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,

                child: Center(
                  child: Text("$rating",
                      style: TextStyle(
                        fontSize: 150,
                        color: Colors.deepOrange,
                      )),
                ),

              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(children: <Widget>[
                      Text1('Member Of Legislative Assembly(MLA)'),
                      Text2(mlaname),
                      Text1('Member Of Parliament(MP)'),
                      Text2(mpname),
                      Text1('MP Constituency'),
                      Text2(mparea),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class Text2 extends StatelessWidget {
  String value;
  Text2(String value){
    this.value=value;

  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$value\n',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange),
    );
  }
}

class Text1 extends StatelessWidget {
  String value;
  Text1(String value){
    this.value=value;

  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$value',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}