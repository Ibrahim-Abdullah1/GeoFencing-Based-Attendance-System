import 'dart:async';
import 'dart:io';
import 'package:action_slider/action_slider.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;

class attendance extends StatefulWidget {
  const attendance({Key? key}) : super(key: key);

  @override
  State<attendance> createState() => _attendanceState();
}

class _attendanceState extends State<attendance> {
  final _controller = ActionSliderController();
  String? usermail = FirebaseAuth.instance.currentUser!.email;
  String? userid = FirebaseAuth.instance.currentUser!.uid;
  final double specificLat = 33.60047175307645;
  final double specificLng = 73.35067966797212;

  String TurnIn = "--:--";
  String TurnOut = "--:--";
  String location = " ";

  @override
  void initState() {
    // TODO: implement initState
    _getRecord();
    _getPermission();
    super.initState();
  }

  Future<bool> _isWithin100m() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final double distanceInMeters = Geolocator.distanceBetween(
      specificLat,
      specificLng,
      position.latitude,
      position.longitude,
    );

    return distanceInMeters <= 100;
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where("Email", isEqualTo: usermail)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM YYYY').format(DateTime.now()))
          .get();

      setState(() {
        TurnIn = snap2['TurnIn'];
        TurnOut = snap2['TurnOut'];
      });
    } on FirebaseException catch (e) {
      print("Exception Occurs");
    }
    print(TurnIn);
    print(TurnOut);
  }

  void _getPermission() async {
    PermissionStatus permission = await Permission.location.status;

    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus newPermission = await Permission.location.request();

      if (newPermission == PermissionStatus.granted) {
        // Permission granted
      } else if (newPermission == PermissionStatus.denied) {
      } else if (newPermission == PermissionStatus.permanentlyDenied) {}
    }
  }

  Future<void> markAttendance(String timeKey, String timeValue) async {
    // Geo-Fencing
    // Check if the user is within 100 meters of the location
    if (!(await _isWithin100m())) {
      throw Exception('You are not within the allowed location!');
    }

    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Employee")
        .where("Email", isEqualTo: usermail)
        .get();

    DocumentSnapshot snap2 = await FirebaseFirestore.instance
        .collection("Employee")
        .doc(snap.docs[0].id)
        .collection("Record")
        .doc(DateFormat('dd MMMM YYYY').format(DateTime.now()))
        .get();

    // Check if the document exists and the date is today
    if (snap2.exists &&
        (snap2.data()! as Map<String, dynamic>)['Date'].toDate().day ==
            DateTime.now().day) {
      throw Exception('Attendance already marked for today!');
    }

    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Reverse geocode the coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Get the first placemark from the list (if it exists)
    Placemark placemark = placemarks.first;

    location = '${placemark.locality}, ${placemark.country}';



    // Initialize the camera
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    final cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await cameraController.initialize();

    // Take the picture
    final image = await cameraController.takePicture();
    await cameraController.dispose();

    // Get the image file
    final imageFile = File(image.path);

    // Load the asset image
    final assetByteData = await rootBundle.load('assets/images/$usermail.jpg');
    final assetUint8List = assetByteData.buffer.asUint8List();

    // Load the camera image
    final cameraImage = img.decodeImage(await imageFile.readAsBytes());
    final cameraUint8List = img.encodeJpg(cameraImage!);

    // Compare the images
    if (!ListEquality().equals(assetUint8List, cameraUint8List)) {
      throw Exception('Face not recognized!');
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
        'location': location,
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
        'location': location,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 35),
              child: const Text(
                "Attendance Portal",
                style: TextStyle(color: Colors.black54, fontSize: 18),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                usermail!,
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  margin: EdgeInsets.only(top: 18, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    // DateFormat("hh:mm:ss s").format(DateTime.now()),
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(color: Colors.black54, fontSize: 19),
                  ),
                );
              },
            ),
            Container(
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                child: RichText(
                  // ignore: prefer_const_constructors, duplicate_ignore
                  text: TextSpan(
                    text: DateFormat('dd ').format(DateTime.now()),
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20,
                    ),
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      TextSpan(
                          text: DateFormat('MMMM yyyy').format(DateTime.now()),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          )),
                    ],
                  ),
                )),
            TurnIn == '--:--'
                ? buildActionSlider('TurnIn', TurnIn, 'Slide to Mark TurnIn')
                : TurnOut == '--:--'
                    ? buildActionSlider(
                        'TurnOut', TurnOut, 'Slide to Mark TurnOut')
                    : Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 35),
                        child: const Text(
                          "Attendance Marked",
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 35),
              child: Text(
                "Today's Status",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            ),
            TurnIn != '--:--'
                ? buildStatusCard("Turn in time", TurnIn, location)
                : Container(),
            TurnOut != '--:--'
                ? buildStatusCard("Turn out time", TurnOut, location)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildActionSlider(String key, String time, String sliderText) {
    return Container(
      padding: EdgeInsets.only(top: 24),
      child: Builder(builder: (context) {
        return ActionSlider.standard(
          width: 300.0,
          actionThresholdType: ThresholdType.release,
          child: Text(sliderText),
          action: (controller) async {
            try {
              await markAttendance(
                  key, DateFormat('hh:mm').format(DateTime.now()));
              setState(() {
                if (key == 'TurnIn') {
                  TurnIn = DateFormat('hh:mm').format(DateTime.now());
                } else if (key == 'TurnOut') {
                  TurnOut = DateFormat('hh:mm').format(DateTime.now());
                }
              });
              controller.loading();
              await Future.delayed(const Duration(seconds: 3));
              controller.success();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e.toString()),
              ));
              controller.failure();
            } finally {
              await Future.delayed(const Duration(seconds: 1));
              controller.reset();
            }
          },
        );
      }),
    );
  }

  Widget buildStatusCard(String title, String time, String location) {
    // Convert the time to a DateTime object
    final format = DateFormat("hh:mm a");
    DateTime timeAsDate = format.parse(time);

    // Check if the time is later than 8 AM
    final isLate = timeAsDate.isAfter(format.parse("8:00 AM"));

    return Container(
        height: 140,
        margin: EdgeInsets.only(top: 17),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: isLate ? Colors.red : Colors.transparent,
            ),
            boxShadow: const [
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.redAccent, fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        time,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Location",
                      style: TextStyle(color: Colors.redAccent, fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: location != " "
                          ? Text(
                              "$location",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              location,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
