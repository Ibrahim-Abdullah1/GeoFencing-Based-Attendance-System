import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrcodeAttendance extends StatefulWidget {
  const QrcodeAttendance({super.key});

  @override
  State<QrcodeAttendance> createState() => _QrcodeAttendanceState();
}

class _QrcodeAttendanceState extends State<QrcodeAttendance> {
  String? usermail = FirebaseAuth.instance.currentUser!.email;
  String? userid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;

  Future<void> markAttendanceWithoutGeofencing(
      String timeKey, String timeValue) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Employee")
        .where("Email", isEqualTo: usermail)
        .get();

    DocumentSnapshot snap2 = await FirebaseFirestore.instance
        .collection("Employee")
        .doc(snap.docs[0].id)
        .collection("Record")
        .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
        .get();
    // Check if the document exists and the date is today
    if (snap2.exists &&
        (snap2.data()! as Map<String, dynamic>)['Date'].toDate().day ==
            DateTime.now().day) {
      throw Exception('Attendance already marked for today!');
    }

    try {
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .update({
        'Date': Timestamp.now(),
        timeKey: timeValue,
        'location': 'Location via QR Code',
      });
    } catch (e) {
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .set({
        'Date': Timestamp.now(),
        timeKey: timeValue,
        'location': 'Location via QR Code',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) async {
      setState(() async {
        result = scanData;
        if (result!.code == "MARK_ATTENDANCE") {
          try {
            // Call your markAttendanceWithoutGeofencing function here
            await markAttendanceWithoutGeofencing(
                'TurnIn', DateFormat('hh:mm').format(DateTime.now()));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Attendance marked successfully!'),
            ));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error marking attendance: ${e.toString()}'),
            ));
          }
        }
      });
    });
  }
}
