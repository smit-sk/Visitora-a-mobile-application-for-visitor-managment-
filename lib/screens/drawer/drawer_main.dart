import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:visitor_tracker/screens/admin/admin_homepage.dart';
import 'package:visitor_tracker/screens/drawer/drawer_item.dart';
import 'package:visitor_tracker/screens/drawer/drawer_items.dart';
import 'package:visitor_tracker/screens/drawer/drawerwidget.dart';
import 'package:visitor_tracker/screens/homescreen.dart';
import 'package:visitor_tracker/screens/profile_page.dart';
import 'package:visitor_tracker/screens/visitor/visitor_homepage.dart';

class DrawerMain extends StatefulWidget {
  DrawerMain({Key? key}) : super(key: key);

  @override
  _DrawerMainState createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<DocumentSnapshot<Map<String, dynamic>>>? data;

  DocumentSnapshot<Map<String, dynamic>>? docs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  late bool isDrawerOpen;
  DrawerItem item = DrawerItems.home;
  bool isDraging = false;
  @override
  void initState() {
    super.initState();

    fetchData();
    closeDrawer();
  }

  fetchData() {
    data = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        docs = value;
      });
      return value;
    });
  }

  void openDrawer() => setState(() {
        xOffset = 230;
        yOffset = 150;
        scaleFactor = 0.6;
        isDrawerOpen = true;
      });

  void closeDrawer() => setState(() {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
        isDrawerOpen = false;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(children: [buildDrawer(), buildPage()]),
    );
  }

  Widget buildDrawer() => SafeArea(
          child: Container(
        width: 230,
        child: DrawerWidget(
          onSelectedItem: (item) async {
            switch (item) {
              case DrawerItems.admin:
                return authorizeAdmin(context, item);
              case DrawerItems.logout:
                await _auth.signOut();
                _googleSignIn.signOut();
                break;
              default:
                setState(() {
                  this.item = item;
                  closeDrawer();
                });
            }
          },
        ),
      ));

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();

          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDraging = true,
        onHorizontalDragUpdate: (details) {
          if (!isDraging) return;
          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDraging = false;
        },
        child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor),
            child: AbsorbPointer(
                absorbing: isDrawerOpen,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
                  child: Container(
                      color: isDrawerOpen ? Colors.white : Colors.white,
                      child: getDrawerPage()),
                ))),
      ),
    );
  }

  Widget getDrawerPage() {
    switch (item) {
      case DrawerItems.profile:
        return EditProfile(
          openDrawer: openDrawer,
        );
      case DrawerItems.admin:
        return AdminOption(
          openDrawer: openDrawer,
          check: false,
        );
      case DrawerItems.visitor:
        return VisitorOption(
          openDrawer: openDrawer,
          check: false,
        );
      case DrawerItems.home:
      default:
        return HomeScreen(openDrawer: openDrawer);
    }
  }

  authorizeAdmin(BuildContext context, DrawerItem item) async {

   await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        docs = value;
      });
      return value;
    });
    
      print(docs!.data()!["email"] + " " + docs!.data()!['role']);
      // if (docs.docs[0].exists) {
      if (docs!.data()!['role'] == 'Admin') {
        setState(() {
          closeDrawer();
          this.item = item;
          getDrawerPage();
        });
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
}
