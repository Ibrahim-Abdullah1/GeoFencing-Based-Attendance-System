// ignore_for_file: unnecessary_new, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:geofencing_based_attendance_system/user/Utilis/Constants.dart';

class Adminpage extends StatefulWidget {
  const Adminpage({Key? key}) : super(key: key);

  @override
  State<Adminpage> createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Constants.prefs?.setBool("Loggedin", false);
          Navigator.pushReplacementNamed(context, "/admin");
        }),
        tooltip: 'Exit',
        child: const Icon(Icons.exit_to_app),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 65, bottom: 10),
              alignment: Alignment.bottomCenter,
              child: const Text(
                "Dashboard",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
            ),
            GestureDetector(
              onTap: (() {
                Navigator.pushReplacementNamed(context, "/register");
              }),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                // shadowColor: Colors.black12,
                margin: const EdgeInsets.only(
                    top: 35, bottom: 14, right: 10, left: 10),
                color: Colors.white54,
                child: Column(
                  children: <Widget>[
                    new Container(
                      width: 150.0,
                      height: 150.0,
                      child: const Icon(
                        Icons.person_add,
                        size: 95,
                        color: Colors.teal,
                      ),
                      margin: const EdgeInsets.all(16.0),
                    ),
                    Container(
                      // GestureDetector(),
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.all(Radius.circular(42))),
                      child: const Center(
                        child: Text(
                          "Register Employee",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                Navigator.pushReplacementNamed(context, "/liststudents");
              }),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                // shadowColor: Colors.black12,
                margin: const EdgeInsets.only(
                    top: 35, bottom: 20, right: 10, left: 10),
                color: Colors.white54,
                child: Column(
                  children: <Widget>[
                    new Container(
                      width: 150.0,
                      height: 150.0,
                      child: const Icon(
                        Icons.data_object,
                        size: 95,
                        color: Colors.teal,
                      ),
                      margin: const EdgeInsets.all(16.0),
                    ),
                    Container(
                      // GestureDetector(),
                      margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.all(Radius.circular(42))),
                      child: const Center(
                        child: Text(
                          "View Record",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
