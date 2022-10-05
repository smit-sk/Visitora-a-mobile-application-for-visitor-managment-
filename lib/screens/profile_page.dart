import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visitor_tracker/screens/drawer/drawer_menu_widget.dart';

class EditProfile extends StatefulWidget {
  final VoidCallback? openDrawer;

  const EditProfile({Key? key, this.openDrawer}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String user = 'user';
  String userEmail = 'Email';
  String? _selectedText;
  String? _controller;
  String? id;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot<Map<String, dynamic>>? docs;
  bool isfetch = false;
  bool check = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        docs = value;
        isfetch = true;
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: CustomAppBar(),
        appBar: AppBar(
          backgroundColor: Colors.grey.withOpacity(0.1),
          elevation: 0,
          leading: Padding(
              padding: EdgeInsets.only(left: 15),
              child: DrawerMenuWidget(
                onClicked: widget.openDrawer,
              )),
        ),
        backgroundColor: Colors.grey.withOpacity(0.1),
        body: isfetch
            ? Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            color: Colors.grey.withOpacity(0.1),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5.0,
                                ),
                                CircleAvatar(
                                  radius: 60.0,
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                  child: isfetch
                                      ? Text(
                                          docs!
                                              .data()!['name'][0]
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 80,
                                              color: Color(0xff5E5E77)))
                                      : CircularProgressIndicator(),
                                ),
                                // SizedBox(
                                //   height: 10.0,
                                // ),
                                // Text(doc['Name'],
                                //     style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 20.0,
                                //     )),
                                // SizedBox(
                                //   height: 10.0,
                                // ),
                                // Text(
                                //   doc['City'],
                                //   style: TextStyle(
                                //     color: Colors.black,
                                //     fontSize: 15.0,
                                //   ),
                                // )
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 8,
                        child: Container(
                          color: Colors.grey.withOpacity(0.1),
                          child: Center(
                            child: Card(
                              elevation: 8,
                              margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                              child: Container(
                                  width: 310.0,
                                  height: 150,
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Information",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey[300],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.user,
                                                color: Colors.purple,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              isfetch
                                                  ? Text(docs!.data()!['name'],
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                      ))
                                                  : CircularProgressIndicator()
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.mail,
                                                color: Colors.redAccent,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              isfetch
                                                  ? Text(docs!.data()!['email'],
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                      ))
                                                  : CircularProgressIndicator()
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.25,
                    left: 20.0,
                    right: 20.0,
                    child: Card(
                      elevation: 7,
                      child: Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Role - ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20.0)),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  isfetch
                                      ? Text(docs!.data()!['role'],
                                          style: TextStyle(fontSize: 19.0))
                                      : CircularProgressIndicator(),
                                  SizedBox(width: 15),
                                  IconButton(
                                      onPressed: () {
                                        showRoleDialog(context);
                                      },
                                      icon: Icon(Icons.edit))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Color(0xff5E5E77),
                ),
              ));
  }

  showRoleDialog(BuildContext context) {
    String? _selectedText;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text("Select Your Role"),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    hint: Text(
                      "Please choose a role",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    value: _selectedText,
                    items: ['Admin', 'Visitor'].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? val) {
                      setState(() {
                        _selectedText = val!;
                        _controller = _selectedText!;
                      });
                    },
                  ),
                );
              },
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Color(0xff6C63FF),
                  ),
                ),
                onPressed: () {
                  check = true;
                  check ? showProgress(context) : Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  showProgress(BuildContext context) {
    print(_controller);
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'role': _controller}).then((value) {
      setState(() {
        check = false;
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        fetchData();
      });
    });
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const CircularProgressIndicator(
                  color: Color(0xff6C63FF),
                ),
              ],
            ),
          );
        });
  }
}
