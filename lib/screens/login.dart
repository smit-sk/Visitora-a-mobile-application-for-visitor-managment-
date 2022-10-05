import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _controller = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5E5E77),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: width * 0.8,
                  child: Image.asset(
                    "assets/images/login.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: Container(
                        height: height * 0.07,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: Color(0xffC6C7C4).withOpacity(0.5),
                        ),
                        child: Center(
                          child: TextFormField(
                            controller: _emailController,
                            cursorColor: Color(0xff6C63FF),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Email",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: Container(
                        height: height * 0.07,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: Color(0xffC6C7C4).withOpacity(0.5),
                        ),
                        child: Center(
                          child: TextFormField(
                            controller: _passwordController,
                            cursorColor: Color(0xff6C63FF),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Password",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: height * 0.08,
                      width: width * 0.8,
                      child: ElevatedButton(
                        child: Text("LOGIN"),
                        onPressed: () {
                          _signIn();
                        },
                        style: TextButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: Color(0xff5E5E77),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21),
                          ),
                          textStyle: TextStyle(
                            fontSize: 24,
                          ),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ),
                    ),

                    TextButton(
                      child: Text(
                        "New here? Sign Up using Email",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff5E5E77),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text("OR"),
                    // Row(children: <Widget>[
                    // Expanded(
                    //   child: new Container(
                    //       margin:
                    //           const EdgeInsets.only(left: 40.0, right: 10.0),
                    //       child: Divider(
                    //         color: Colors.black,
                    //         height: 26,
                    //       )),
                    // ),
                    // Text("OR"),
                    // Expanded(
                    //   child: new Container(
                    //       margin:
                    //           const EdgeInsets.only(left: 10.0, right: 40.0),
                    //       child: Divider(
                    //         color: Colors.black,
                    //         height: 26,
                    //       )),
                    // ),
                    // ]),

                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.red,
                            size: 22,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          TextButton(
                            child: Text(
                              'Login using Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                              ),
                            ),
                            onPressed: () {
                              showRoleDialog(context);
                            },
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        _db.collection("users").doc(user.user!.uid).update({
          "last_seen": DateTime.now(),
        });
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text("Success"),
                content: Text("Sign In Success"),
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
      }).catchError((e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text("Error"),
                content: Text("${e.message}"),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Text(
                      "Cancel",
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
      });
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Error"),
              content: Text("Please provide Email and Password!"),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Color(0xff6C63FF),
                    ),
                  ),
                  onPressed: () {
                    _emailController.text = "";
                    _passwordController.text = "";
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
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
              // child: DropdownButton<String>(
              //   value: _selectedText,
              //   items: <String>['Admin', 'User'].map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   onChanged: (String? val) {
              //     setState(() {
              //       _selectedText = val!;
              //       _controller = _selectedText;
              //     });
              //   },
              // ),
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
                  Navigator.of(ctx).pop();
                  _signInUsingGoogle();
                },
              ),
            ],
          );
        });
  }

  void _signInUsingGoogle() async {
    print(_controller);
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final User? user = (await _auth.signInWithCredential(credential)).user;
      print("Signed In " + user!.displayName.toString());

      if (user != null) {
        //Successful signup
        _db.collection("users").doc(user.uid).set({
          "displayName": user.displayName,
          "email": user.email,
          "role": _controller,
          "last_seen": DateTime.now(),
          "signup_method": user.providerData[0].providerId
        });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Error"),
              content: Text("${e}"),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text(
                    "Cancel",
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
  }
}
