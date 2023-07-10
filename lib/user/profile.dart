// ignore_for_file: prefer_const_constructors, camel_case_types, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final c_user = FirebaseAuth.instance.currentUser;
  final _formkey = GlobalKey<FormState>();

  var newpassword = "";
  final _newpasswordcontroller = TextEditingController();

  String U_id = FirebaseAuth.instance.currentUser!.uid;

  void UploadProfilePick() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
  }

  changePassword() async {
    try {
      await c_user!.updatePassword(newpassword).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Password has been updated',
            style: TextStyle(color: Colors.greenAccent),
          ),
          duration: Duration(seconds: 2),
        ));
      });
      FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, "/login");
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'An Error Accured in changing Password',
          style: TextStyle(color: Colors.redAccent),
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Center(
            child: Card(
              margin: EdgeInsets.only(top: 20),
              color: Colors.white30,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 35, bottom: 20),
                      child: const Text(
                        "Attendance Portal",
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        " ",
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 35, bottom: 20),
                      child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Password";
                            } else if (value.length < 6) {
                              return "Password Should be greater than 6 characters";
                            }
                            return null;
                          },
                          controller: _newpasswordcontroller,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.redAccent)),
                            label: Text("Change Password"),
                            hintText: "Enter new password",
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          )),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 15),
                        alignment: Alignment.center,
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Icon(
                          Icons.photo_camera_back,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Change Your Profile Picture",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () => {
                        if (_formkey.currentState!.validate())
                          {
                            setState(
                              () {
                                newpassword = _newpasswordcontroller.text;
                              },
                            )
                          },
                        changePassword(),
                      },
                      child: GestureDetector(
                        onTap: (() {
                          UploadProfilePick();
                        }),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.all(Radius.circular(11)),
                          ),
                          child: Center(
                            child: Text(
                              "Save Changes",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
