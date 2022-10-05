import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:visitor_tracker/screens/admin/qr.dart';
import 'dart:async';

import 'package:visitor_tracker/screens/admin/qr_upload.dart';

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String qrCodeResult = "Visitor details not yet Scanned";
  int correctQRDecoded = 0;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String res = "";

  // _scanQR() async {
  //   try {
  //     return Container(
  //       width: MediaQuery.of(context).size.width * 0.7,
  //       height: MediaQuery.of(context).size.height * 0.45,
  //       color: Color(0xff001C1F),
  //       child: QRView(
  //         key: qrKey,
  //         onQRViewCreated: _onQRViewCreated,
  //         overlay: QrScannerOverlayShape(
  //             borderColor: Colors.white,
  //             borderRadius: 10,
  //             borderLength: 30,
  //             borderWidth: 10,
  //             cutOutSize: 180),
  //       ),
  //     );
  //   } on PlatformException catch (ex) {
  //     if (ex.code == BarcodeScanner.CameraAccessDenied) {
  //       setState(() {
  //         qrCodeResult = "Camera permission was denied";
  //       });
  //     } else {
  //       setState(() {
  //         qrCodeResult = "Unknown Error $ex";
  //       });
  //     }
  //   } on FormatException {
  //     setState(() {
  //       qrCodeResult = "You pressed the back button before scanning anything";
  //     });
  //   } catch (ex) {
  //     setState(() {
  //       qrCodeResult = "Unknown Error $ex";
  //     });
  //   }
  // }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });

  //   controller.scannedDataStream.listen((scanData) {
  //     print(scanData.code);
  //     setState(() {
  //       controller.pauseCamera();
  //       qrCodeResult = scanData.code;
  //       correctQRDecoded = 1;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    print("Arg = " + arg['res']);
    if (arg['res'] != "te") {
      qrCodeResult = arg['res'];
      correctQRDecoded = 1;
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    _navigateScannedQR(BuildContext context) async {
      QR qr = new QR(qrCodeResult);
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadData(
                    text: qr.text,
                  )));
      print(result);
    }

    Widget uploadButton = new Container(
      height: height * 0.07,
      width: width * 0.8,
      child: ElevatedButton(
        child: Text("UPLOAD SCANNED DETAILS"),
        onPressed: () async {
          _navigateScannedQR(context);
        },
        style: TextButton.styleFrom(
          elevation: 0.0,
          backgroundColor: Color(0xffF50057),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21),
          ),
          textStyle: TextStyle(
            fontSize: 20,
          ),
          padding: EdgeInsets.all(8.0),
        ),
      ),
    );

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
                "QR CODE SCANNER",
                style: TextStyle(
                    color: Color(0xff5E5E77),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 70.0,
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  qrCodeResult,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 70.0,
              ),
              Container(
                height: height * 0.07,
                width: width * 0.8,
                child: ElevatedButton(
                  child: Text("OPEN SCANNER"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/qrScan');
                  },
                  style: TextButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: Color(0xff5E5E77),
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
              SizedBox(
                height: 30,
              ),
              correctQRDecoded == 0 ? Container() : uploadButton
            ],
          ),
        ),
      ),
    );
  }
}
