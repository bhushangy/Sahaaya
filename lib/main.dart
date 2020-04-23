import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voter_grievance_redressal/loginpage/LoginPage.dart';
import 'package:voter_grievance_redressal/models/checkBox.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo,
      statusBarIconBrightness: Brightness.light,
    ));
    return ChangeNotifierProvider(
      create:(context) => DropDown(),
      child: MaterialApp(
        theme: ThemeData(
          textSelectionHandleColor: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
