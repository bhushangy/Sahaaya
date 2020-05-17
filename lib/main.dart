import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voter_grievance_redressal/Authentication/LoginPage.dart';
import 'package:voter_grievance_redressal/HomePage/HomePage.dart';
import 'package:voter_grievance_redressal/SplashScreen/SplashScreen1.dart';
import 'package:voter_grievance_redressal/SplashScreen/SplashScreen2.dart';
import 'package:voter_grievance_redressal/SplashScreen/SplashScreen3.dart';
import 'package:voter_grievance_redressal/Provider/ProviderClass.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var i = prefs.getInt('i');
  print(email);
  print(i);
  if (i == null)
    runApp(ChangeNotifierProvider(
      create: (context) => DropDown(),
      child: MaterialApp(
        routes: {
          '/login':(context) => LoginPage(),
          '/home' :(context) => HomePage(),
        },
        theme: ThemeData(
          accentColor: Colors.indigo,
          textSelectionHandleColor: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen1(),
      ),
    ),);
  else if (i != null && email == null)
    runApp(ChangeNotifierProvider(
      create: (context) => DropDown(),
      child: MaterialApp(
        routes: {
          '/login':(context) => LoginPage(),
          '/home' :(context) => HomePage(),
        },
        theme: ThemeData(
          accentColor: Colors.indigo,
          textSelectionHandleColor: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen2(),
      ),
    ),);
  else if (i != null && email != null)
    runApp(ChangeNotifierProvider(
      create: (context) => DropDown(),
      child: MaterialApp(
        routes: {
          '/login':(context) => LoginPage(),
          '/home' :(context) => HomePage(),
        },
        theme: ThemeData(
          accentColor: Colors.indigo,
          textSelectionHandleColor: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen3(),
      ),
    ),);
}


