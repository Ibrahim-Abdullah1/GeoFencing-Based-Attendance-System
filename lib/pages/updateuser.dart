import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class updateuser extends StatefulWidget {
  final String id;

  updateuser({Key? key, required this.id}) : super(key: key);

  @override
  State<updateuser> createState() => _updateuserState();
}

class _updateuserState extends State<updateuser> {
  final _formkey = GlobalKey<FormState>();
  CollectionReference students =
      FirebaseFirestore.instance.collection('Employee');

  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();

  updateuser(id, email, name, password) async {
    return students
        .doc(id)
        .update({'Name': name, 'Email': email, 'Password': password})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to Update"));
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
                          Icons.edit,
                          size: 125,
                          color: Color.fromARGB(255, 1, 255, 230),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        const Text(
                          "Edit Profile",
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
                              //getting Specific Users Data
                              key: _formkey,
                              child: FutureBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                future: FirebaseFirestore.instance
                                    .collection("Employee")
                                    .doc(widget.id)
                                    .get(),
                                builder: (_, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text("Something Went Wrong"),
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  var data = snapshot.data!.data();
                                  var name = data!['Name'];
                                  var email = data['Email'];
                                  var password = data['Password'];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      fieldtitle("   User Email"),

                                      customfield('Enter new Email',
                                          _emailcontroller, email),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      // const SizedBox(height: 20),
                                      fieldtitle("   Employee Name"),
                                      customfield('Enter Employee name',
                                          _namecontroller, name),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      fieldtitle("   Password"),
                                      passwordfield('Enter Password',
                                          _passwordcontroller),
                                      GestureDetector(
                                        onTap: () {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            setState(() {
                                              email = _emailcontroller.text;
                                              password = _passwordcontroller;
                                              name = _namecontroller.text;
                                            });
                                            updateuser(widget.id, email, name,
                                                password);
                                            cleartext();
                                            Navigator.pushReplacementNamed(
                                                context, "/adminhome");
                                          }
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 25),
                                          height: 50,
                                          decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 1, 255, 230),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(42))),
                                          child: const Center(
                                            child: Text(
                                              "Update",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 2.2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      register(),
                                    ],
                                  );
                                },
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

  Widget customfield(
      String hint, TextEditingController controller, String initialval) {
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
              child: hint == "Enter new Email"
                  ? Icon(Icons.email)
                  : Icon(Icons.title),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 5),
            child: TextFormField(
              // initialValue: initialval,
              controller: controller,
              validator: (value) {
                if (value == null) {
                  return "Please Fill the Field";
                } else if (controller == _emailcontroller &&
                    !value.contains("@")) {
                  if (hint == "Enter new Email") {
                    return "Please Enter Valid Email";
                  }
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
                  "Admin Main",
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
