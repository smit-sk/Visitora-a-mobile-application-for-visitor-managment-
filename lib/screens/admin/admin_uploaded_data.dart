import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:visitor_tracker/screens/admin/pdf/pdf_api.dart';
import 'package:visitor_tracker/screens/admin/pdf/pdf_data_api.dart';
import 'package:visitor_tracker/screens/admin/vd.dart';
import 'package:visitor_tracker/screens/admin/visitor_detail.dart';

class UploadedData extends StatefulWidget {
  @override
  _UploadedDataState createState() => _UploadedDataState();
}

class _UploadedDataState extends State<UploadedData> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  List mp = [];

  @override
  void initState() {
    getUid();
    getList();
    super.initState();
  }

  getList() async {
    List item = [];
    await _db
        .collection("users")
        .doc(user!.uid)
        .collection("visitor_details")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        item.add(element.data());
      });
    });

    setState(() {
      mp = item;
    });

    print(mp);
  }

  void getUid() {
    User? u = _auth.currentUser;
    setState(() {
      user = u;
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    var format =
        new DateFormat.yMMMMd('en_US').add_jm(); // 'hh:mm' for hour & min
    return format.format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff5E5E77),
          onPressed: () async {
            final pdfFile = await PdfDataApi.generate(mp);

            PdfApi.openFile(pdfFile);
          },
          child: Icon(FontAwesomeIcons.filePdf)),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
          child: Container(
            child: StreamBuilder(
              stream: _db
                  .collection("users")
                  .doc(user!.uid)
                  .collection("visitor_details")
                  .orderBy("uploaded_time", descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return ListView(
                      children: snapshot.data!.docs.map((snap) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
                          child: Card(
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        snap["name"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 4.0, 4.0, 4.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        formatTimestamp(snap["uploaded_time"])
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    _db
                                        .collection("users")
                                        .doc(user!.uid)
                                        .collection("visitor_details")
                                        .doc(snap.id)
                                        .delete();
                                    _showDialog();
                                  },
                                ),
                              ),
                              onTap: () {
                                VD vd = new VD(
                                    snap["visitor_details"],
                                    formatTimestamp(snap["uploaded_time"])
                                        .toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VisitorDetail(
                                              userDetail: vd.userDetail,
                                              uploadedTime: vd.uploadedTime,
                                            )));
                              },
                              contentPadding: EdgeInsets.all(7.0),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Color(0xff5E5E77),
                            elevation: 10,
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "UPLOADED DATA",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff5E5E77),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Image(
                                image: AssetImage("assets/images/no_data.png"),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "No data uploaded",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff5E5E77),
                  ),
                );
              },
            ),
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
            content: Text("Visitor record deleted successfully"),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Color(0xff5E5E77),
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
