// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geofencing_based_attendance_system/pages/admindashboard.dart';
import 'package:geofencing_based_attendance_system/pages/adminlogin.dart';
import 'package:geofencing_based_attendance_system/pages/login.dart';
import 'package:geofencing_based_attendance_system/pages/register.dart';
import 'package:geofencing_based_attendance_system/pages/splash.dart';
import 'package:geofencing_based_attendance_system/pages/user_main.dart';
import 'package:geofencing_based_attendance_system/user/Liststudents.dart';
import 'package:geofencing_based_attendance_system/user/Utilis/Constants.dart';
import 'package:geofencing_based_attendance_system/user/View_attendance.dart';
import 'package:geofencing_based_attendance_system/user/mark_attendance.dart';
import 'package:geofencing_based_attendance_system/user/monthlyreport.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Constants.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> initialized = Firebase.initializeApp();
    return FutureBuilder(
      future: initialized,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: Text("Soemthing Wents wrong"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          return CircularProgressIndicator();
        } else {
          return MaterialApp(
            title: "Attendance Managment System",
            home: Constants.prefs?.getBool("Loggedin") == true
                ? usermain()
                : SplashScreen(),
            routes: {
              '/login': ((context) => login()),
              '/register': (context) => register(),
              '/usermain': (context) => usermain(),
              '/liststudents': (context) => liststudents(),
              '/adminhome': (context) => Adminpage(),
              '/monthlyreport': (context) => monthlyreport(),
              '/markattendance': (context) => attendance(),
              '/adminlogin': (context) => adminlogin(),
              '/viewattendance': (context) => viewattendance(),
            },
            localizationsDelegates: const [
              MonthYearPickerLocalizations.delegate,
            ],
          );
        }
      },
    );
  }
}
