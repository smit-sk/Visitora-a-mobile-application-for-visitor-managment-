import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:visitor_tracker/screens/admin/admin_homepage.dart';
import 'package:visitor_tracker/screens/drawer/drawer_menu_widget.dart';
import 'package:visitor_tracker/services/auth_state.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? openDrawer;

  const HomeScreen({Key? key, this.openDrawer}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  StreamSubscription<QuerySnapshot>? subscription;

  // List<DocumentSnapshot>? snapshot;
  Future<DocumentSnapshot<Map<String, dynamic>>>? data;

  DocumentSnapshot<Map<String, dynamic>>? docs;

  bool _progressController = true;
  ImageProvider imageProvider = const AssetImage("assets/images/option.png");

  @override
  void initState() {
    super.initState();
    data = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        docs = value;
        _progressController = false;
      });
      return value;
    });
  }

  authorizeAdmin(BuildContext context) {
    print(docs!.data()!["email"]);
    // if (docs.docs[0].exists) {
    if (docs!.data()!['role'] == 'Admin') {
      Navigator.pushNamed(
        context,
        "/adminoption",
      );
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(""),
              content: Text(
                  "Visitors are not allowed to enter in admin section. This is only for Shopkeeper."),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
            padding: EdgeInsets.only(left: 15),
            child: DrawerMenuWidget(
              onClicked: widget.openDrawer,
            )),
      ),
      body: Container(
        height: height,
        width: width,
        // color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: 25,
            // ),
            Text(
              "Welcome To Visitor Info",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xff5E5E77),
              ),
            ),
            // SizedBox(
            //   height: 5,
            // ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(image: imageProvider,fit: BoxFit.contain)
            ),
            // SizedBox(
            //   height: 20,
            // ),
            Text(
              "Select type of User",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            // SizedBox(
            //   height: 25,
            // ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      height: height * 0.15,
                      width: width * 0.35,
                      decoration: BoxDecoration(
                        color: Color(0xffC6C7C4).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(21),
                      ),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          _progressController
                              ? CircularProgressIndicator()
                              // ? showDialog(
                              //     context: context,
                              //     builder: (ctx) {
                              //       return AlertDialog(
                              //         shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(16),
                              //         ),
                              //         title: Text("Checking..."),
                              //         content: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: [
                              //             CircularProgressIndicator(),
                              //           ],
                              //         ),
                              //         // actions: <Widget>[
                              //         //   // ignore: deprecated_member_use
                              //         //   FlatButton(
                              //         //     child: Text(
                              //         //       "Ok",
                              //         //       style: TextStyle(
                              //         //         color: Colors.red,
                              //         //       ),
                              //         //     ),
                              //         //     onPressed: () {
                              //         //       Navigator.of(ctx).pop();
                              //         //     },
                              //         //   ),
                              //         // ],
                              //       );
                              //     })
                              : authorizeAdmin(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.admin_panel_settings_outlined,
                              color: Color(0xff5E5E77),
                              size: 45,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Admin",
                              style: TextStyle(
                                color: Color(0xff5E5E77),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  Flexible(
                    child: Container(
                      height: height * 0.15,
                      width: width * 0.35,
                      decoration: BoxDecoration(
                        color: Color(0xffC6C7C4).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(21),
                      ),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/visitoroption");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: Color(0xff5E5E77),
                              size: 45,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Visitor",
                              style: TextStyle(
                                color: Color(0xff5E5E77),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Container(
                    height: height * 0.08,
                    width: width * 0.8,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _auth.signOut();
                        _googleSignIn.signOut();
                      },
                      child: Center(
                        child: Text(
                          "LOGOUT",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xff5E5E77),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
