import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final _formkey = GlobalKey<FormState>();
  CollectionReference students =
      FirebaseFirestore.instance.collection('Employee');

  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();

  String _email = "";
  String _password = "";
  String _name = "";

  void Auth_Register() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Failed To register, Contact Admin',
          style: TextStyle(color: Colors.redAccent),
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
      adduser_store() {
    return students
        .add({"Name": _name, 'Email': _email, 'Password': _password})
        .then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                'Employee Registered Succesfully',
                style: TextStyle(color: Colors.redAccent),
              ),
              duration: Duration(seconds: 2),
            )))
        .catchError((error) {
          print("Error: $error");
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _namecontroller.dispose();
    super.dispose();
  }

  void cleartext() {
    _namecontroller.clear();
    _emailcontroller.clear();
    _passwordcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/laptopuser.jpg",
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.only(top: 15),
                  color: Colors.white54,
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.app_registration,
                          size: 125,
                          color: Color.fromARGB(255, 1, 255, 230),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        const Text(
                          "Register Employee",
                          style: TextStyle(
                              letterSpacing: 2.5,
                              fontSize: 35,
                              color: Color.fromARGB(255, 242, 245, 248),
                              fontFamily: "Lobster-Regular"),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Form(
                              key: _formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  fieldtitle("   Employee Email"),
                                  customfield('Enter  Email', _emailcontroller),
                                  // const SizedBox(height: 20),
                                  fieldtitle("   Employee Name"),
                                  customfield(
                                      'Enter Employee name', _namecontroller),
                                  fieldtitle("   Password"),
                                  passwordfield(
                                      'Enter Password', _passwordcontroller),
                                  custombutton("Register"),
                                  register(),
                                ],
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
        ],
      ),
    );
  }

  Widget fieldtitle(String title) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }

  Widget customfield(String hint, TextEditingController controller) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Icon(Icons.email),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 5),
            child: TextFormField(
              controller: controller,
              validator: (value) {
                if (value == null) {
                  return "Please Fill the Field";
                } else if (controller == _emailcontroller ||
                    !value.contains("@")) {
                  return "Please Enter Valid Email";
                }
                return null;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.blueGrey),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                hintText: hint,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget passwordfield(String hint, TextEditingController controller) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Icon(Icons.password),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 5),
            child: TextFormField(
              controller: _passwordcontroller,
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.blueGrey),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                hintText: hint,
              ),
              validator: (value) {
                if (value == null) {
                  return "Please Enter Password";
                } else if (value.length < 6) {
                  return "Please Enter Strong Password";
                }
                return null;
              },
            ),
          )),
        ],
      ),
    );
  }

//  Widget customnamefield(String hint, TextEditingController controller) {
//     return Container(
//       height: 50,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 20,
//             offset: Offset(2, 2),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               child: Icon(Icons.email),
//             ),
//           ),
//           Expanded(
//               child: Padding(
//             padding: const EdgeInsets.only(bottom: 3, left: 5),
//             child: TextFormField(
//               controller: _emailcontroller,
//               validator: (value) {
//                 if (value == null) {
//                   return "Please Fill the Field";
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintStyle: const TextStyle(color: Colors.blueGrey),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                 hintText: hint,
//               ),
//             ),
//           )),
//         ],
//       ),
//     );
//   }

  Widget custombutton(String text) {
    return GestureDetector(
      onTap: () {
        // if (_formkey.currentState!.validate()) {
        setState(() {
          _email = _emailcontroller.text;
          _password = _passwordcontroller.text;
          _name = _namecontroller.text;
        });
        // }
        adduser_store();
        Auth_Register();
        cleartext();
        Navigator.pushReplacementNamed(context, "/adminhome");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        height: 50,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 1, 255, 230),
            borderRadius: BorderRadius.all(Radius.circular(42))),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.2),
          ),
        ),
      ),
    );
  }

  Widget register() {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: Text("Goto Main")),
          Container(
            child: TextButton(
                onPressed: (() {
                  Navigator.pushNamed(context, "/adminhome");
                }),
                child: Text(
                  "Admin Dashboard",
                  style: TextStyle(
                      color: Colors.black54,
                      letterSpacing: 1.5,
                      fontFamily: "Lobster-Regular",
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                )),
          )
        ],
      ),
    );
  }
}
