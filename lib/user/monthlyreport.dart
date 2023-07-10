import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geofencing_based_attendance_system/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class monthlyreport extends StatefulWidget {
  const monthlyreport({Key? key}) : super(key: key);

  @override
  State<monthlyreport> createState() => _monthlyreportState();
}

class _monthlyreportState extends State<monthlyreport> {
  String _month = DateFormat('MMMM').format(DateTime.now());
  String? usermail = FirebaseAuth.instance.currentUser!.email;
  String Turnin = "";
  double screenHeight = 0;
  String location = "Mountain View, United States";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 35, bottom: 13),
            child: const Text(
              "Attendance Portal",
              style: TextStyle(color: Colors.black54, fontSize: 18),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.center,
            child: const Text(
              "My Attendance",
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
          ),
          Stack(children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                _month,
                style: const TextStyle(
                    color: Color.fromARGB(255, 245, 4, 4), fontSize: 22),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  final month = await showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2085),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                  primary: Colors.redAccent,
                                  secondary: Colors.redAccent,
                                  onSecondary: Colors.white),
                              textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                      primary: Colors.redAccent))),
                          child: child!,
                        );
                      });

                  if (month != null) {
                    setState(() {
                      _month = DateFormat('MMMM').format(month);
                    });
                  }
                },
                child: const Text(
                  "Choose Month",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
            ),
          ]),
          Container(
            margin: EdgeInsets.only(),
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Employee")
                  .doc(user.id)
                  .collection("Record")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final snap = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return DateFormat('MMMM')
                                  .format(snap[index]['Date'].toDate()) ==
                              _month
                          ? Container(
                              height: 125,
                              margin: const EdgeInsets.only(
                                  top: 17, right: 8, left: 8, bottom: 6),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(95, 24, 21, 21),
                                      blurRadius: 10,
                                      offset: Offset(2, 2),
                                    )
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.only(),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        color: Colors.redAccent,
                                      ),
                                      child: Center(
                                        child: Text(
                                          DateFormat('dd\nEE').format(
                                              snap[index]['Date'].toDate()),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Turn in time",
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 18),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              snap[index]['TurnIn'],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "Location",
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 18),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5.0),
                                            child: Text(
                                              "Islamabad",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          : const SizedBox();
                    },
                  );
                } else {
                  return const SizedBox(
                    child: Text("Error Recieving Data"),
                  );
                }
              },
            ),
          )
        ]),
      ),
    );
  }
}
