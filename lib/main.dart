import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/models/checkBox.dart';
import 'home/LoadingScreen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => DropDown(),
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
