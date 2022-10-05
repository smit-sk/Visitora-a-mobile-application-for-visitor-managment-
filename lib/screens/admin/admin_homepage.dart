import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:visitor_tracker/screens/drawer/drawer_menu_widget.dart';

class AdminOption extends StatefulWidget {
  final VoidCallback? openDrawer;
  final bool? check;

  const AdminOption({Key? key, this.openDrawer, this.check}) : super(key: key);

  @override
  _AdminOptionState createState() => _AdminOptionState();
}

class _AdminOptionState extends State<AdminOption> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
            child: widget.check! ? Icon(Icons.disabled_by_default_outlined,color: Colors.transparent,):
             DrawerMenuWidget(
              onClicked: widget.openDrawer,
            )),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              "WELCOME ADMIN",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xff5E5E77),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: width * 0.8,
                child: Image.asset(
                  "assets/images/admin.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Container(
                    height: height * 0.07,
                    width: width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/qrcodescanner",
                            arguments: {'res': "te"});
                      },
                      child: Center(
                        child: Text(
                          "Scan QR Code",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xffC6C7C4).withOpacity(0.5),
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
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Container(
                    height: height * 0.07,
                    width: width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/uploadeddata");
                      },
                      child: Center(
                        child: Text(
                          "View uploaded details",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xffC6C7C4).withOpacity(0.5),
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
             SizedBox(
              height: 10,
            ),
              Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Container(
                    height: height * 0.07,
                    width: width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/charthomepage",
                           );
                      },
                      child: Center(
                        child: Text(
                          "Analysis",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xffC6C7C4).withOpacity(0.5),
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
            SizedBox(
              height: 12,
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
                        Navigator.of(context).pop();
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
