import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';

import 'BottomNavBar.dart';

final databaseReference = Firestore.instance;
class GetInfo extends StatefulWidget {
  String email;
  GetInfo({this.email});
  @override
  _GetInfoState createState() => _GetInfoState();
}

class _GetInfoState extends State<GetInfo> {


  void initState(){
    super.initState();
    //getUserInfo();

  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


