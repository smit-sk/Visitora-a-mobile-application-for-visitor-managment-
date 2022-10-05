import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:visitor_tracker/services/auth_state.dart';

class SplashScreenPage extends StatelessWidget {
  ImageProvider imageProvider = AssetImage("assets/images/welcome.png");

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      styleTextUnderTheLoader: TextStyle(fontSize: 10),
      loadingTextPadding: EdgeInsets.all(1),
      useLoader: true,
      seconds: 4,
      navigateAfterSeconds: Auth(),
      backgroundColor: Colors.white,
      title: Text(
        'Visitor Info',
        style: TextStyle(
          color: Color(0xff5E5E77),
          fontSize: 30,
        ),
      ),
      image: Image(image: imageProvider),
      loadingText: Text(
        "",
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
      ),
      photoSize: 100.0,
      loaderColor: Color(0xff5E5E77),
    );
  }
}
