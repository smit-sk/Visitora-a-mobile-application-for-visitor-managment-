import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UploadData extends StatefulWidget {
  final String? text;
  const UploadData({Key? key, this.text}) : super(key: key);

  @override
  _UploadDataState createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? name;
  String? vaccinated;
  String? number;
  String? address;

  @override
  void initState() {
    getUid();
    print(widget.text!);
    var body = jsonDecode('''{${widget.text!}}''');
    setState(() {
      name = body["name"];
      vaccinated = body["vaccinated"];
      number = body["number"];
      address = body["address"];
    });
    print("name" + name!);
    super.initState();
  }

  void getUid() {
    User? u = _auth.currentUser;
    setState(() {
      user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "UPLOAD DATA",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff6C63FF),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  "${widget.text}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Upon pressing UPLOAD button, the above data would be uploaded.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red[600],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: height * 0.07,
                width: width * 0.8,
                child: ElevatedButton(
                  child: Text("UPLOAD"),
                  onPressed: () async {
                    var now = DateTime.now();
                    var formatter = DateFormat('yyyy-MM-dd');
                    String formattedDate = formatter.format(now);
                    print(formattedDate);
                    bool vc = false;
                    if (vaccinated!.toLowerCase() == "yes") {
                      vc = true;
                    }

                    _db
                        .collection("users")
                        .doc(user!.uid)
                        .collection("visitor_details")
                        .add({
                      "name": name,
                      "vaccinated": vaccinated,
                      "number": number,
                      "address": address,
                      "uploaded_time": DateTime.now()
                    });
                    _db.collection('shop').doc(user!.uid)
                        .collection("time")
                        .doc(formattedDate)
                        .get()
                        .then((value) {
                      if (value.exists) {
                        if (vc) {
                          _db.collection('shop').doc(user!.uid).collection("time").doc(formattedDate).update({
                            "count": FieldValue.increment(1),
                            "vaccinated_count": FieldValue.increment(1),
                          });
                        } else{
                          _db
                              .collection('shop')
                              .doc(user!.uid)
                              .collection("time").doc(formattedDate).update({
                            "count": FieldValue.increment(1),
                            "not_vaccinated_count": FieldValue.increment(1),
                          });
                        }
                      } else {
                        if (vc) {
                          _db
                              .collection('shop')
                              .doc(user!.uid)
                              .collection("time")
                              .doc(formattedDate)
                              .set({
                                "date": formattedDate,
                                "count": FieldValue.increment(1),
                              "vaccinated_count": FieldValue.increment(1),
                              "not_vaccinated_count": 0,
                              });
                        }else{
                          _db
                              .collection('shop')
                              .doc(user!.uid)
                              .collection("time").doc(formattedDate).set({
                            "date": formattedDate,
                            "count": FieldValue.increment(1),
                            "vaccinated_count": 0,
                            "not_vaccinated_count": FieldValue.increment(1),
                          });
                        }
                      }
                    });

                    _showDialog();
                  },
                  style: TextButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: Color(0xff6C63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(21),
                    ),
                    textStyle: TextStyle(
                      fontSize: 20,
                    ),
                    padding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text("Success"),
            content: Text("Visitor record uploaded successfully"),
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
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          );
        });
  }
}
