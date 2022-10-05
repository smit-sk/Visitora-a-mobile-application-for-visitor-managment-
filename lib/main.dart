import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:visitor_tracker/screens/admin/admin_homepage.dart';
import 'package:visitor_tracker/screens/admin/admin_qrscan.dart';
import 'package:visitor_tracker/screens/admin/admin_uploaded_data.dart';
import 'package:visitor_tracker/screens/admin/chart/show_data.dart';
import 'package:visitor_tracker/screens/admin/chart/time_chart.dart';
import 'package:visitor_tracker/screens/admin/chart/time_zoom_chart.dart';
import 'package:visitor_tracker/screens/admin/chart_homepage.dart';
import 'package:visitor_tracker/screens/admin/qr_upload.dart';
import 'package:visitor_tracker/screens/admin/qrscan.dart';
import 'package:visitor_tracker/screens/admin/show_chart.dart';
import 'package:visitor_tracker/screens/admin/show_grouped_chart.dart';
import 'package:visitor_tracker/screens/homescreen.dart';
import 'package:visitor_tracker/screens/login.dart';
import 'package:visitor_tracker/screens/signup.dart';
import 'package:visitor_tracker/screens/visitor/qr_code_page.dart';
import 'package:visitor_tracker/screens/visitor/visitor_detailpage.dart';
import 'package:visitor_tracker/screens/visitor/visitor_homepage.dart';
import 'package:visitor_tracker/services/auth_state.dart';
import 'package:visitor_tracker/utils/splash_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'screens/visitor/model/visitor_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(VisitorAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  Widget buildError(BuildContext context, FlutterErrorDetails error) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/Error.png",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/welcome.png"), context);
    precacheImage(const AssetImage("assets/images/option.png"), context);

    return MaterialApp(
      title: 'Visitor-Tracker',
      theme: ThemeData(
        fontFamily: GoogleFonts.rubik().fontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Color(0xff5E5E77),
      ),
      builder: (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return buildError(context, errorDetails);
        };
        return widget!;
      },
      home: SplashScreenPage(),
      routes: {
        "/home": (context) => HomeScreen(),
        "/login": (context) => LoginScreen(),
        "/signup": (context) => SignUpScreen(),
        "/auth": (context) => Auth(),
        "/visitoroption": (context) => VisitorOption(check: true),
        "/visitordetails": (context) => FutureBuilder(
              future: Hive.openBox(
                'visitor',
                compactionStrategy: (int total, int deleted) {
                  return deleted > 35;
                },
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError)
                    return Text(snapshot.error.toString());
                  else {
                    return VisitorDetailEntry();
                  }
                } else
                  return Scaffold();
              },
            ),
        "/qrcodegenerator": (context) => FutureBuilder(
              future: Hive.openBox(
                'visitor',
                compactionStrategy: (int total, int deleted) {
                  return deleted > 35;
                },
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError)
                    return Text(snapshot.error.toString());
                  else
                    return QRCodeGenerator();
                } else
                  return Scaffold();
              },
            ),
        "/adminoption": (context) {
          return AdminOption(check: true);
        },
        "/qrcodescanner": (context) => QRCodeScanner(),
        "/uploaddata": (context) => UploadData(),
        "/uploadeddata": (context) => UploadedData(),
        "/qrScan": (context) => QRScanScreen(),
        "/charthomepage": (context) => ChartHomePage(),
        "/barchart": (context) => ShowChart(),
        "/groupedchart": (context) => ShowGroupedChart(),
        "/stackedlinechart": (context) => ShowLineChart(),
        "/showdata": (context) => TimeZoomChart(),
      },
    );
  }
}
