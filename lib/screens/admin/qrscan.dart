import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  bool qr = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5E5E77),
      // appBar: AppBar(
      //   title: Text(
      //     "Scan",
      //     style: Theme.of(context).textTheme.bodyText1,
      //   ),
      //   elevation: 0,

      // ),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              child: SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Scan QR Code",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.013,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Scan Your Code which you genrated from visitor panel",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.45,
                        color: Color(0xff001C1F),
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                          overlay: QrScannerOverlayShape(
                              borderColor: Colors.white,
                              borderRadius: 10,
                              borderLength: 30,
                              borderWidth: 10,
                              cutOutSize: 180),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      print(scanData.code);
      setState(() {
        controller.pauseCamera();
        Navigator.pop(context);
        Navigator.pop(context);
        
        Navigator.pushNamed(context, '/qrcodescanner',
            arguments: {'res': scanData.code});

        // if (scanData.code == "" || scanData.code.length < 128) {
        //   return showSheetForQr(controller);
        // } else {
        // String s =
        //     getEncryptionKey(widget.device.id.toString(), scanData.code);

        // print(s);
        // final data = json.decode(s);
        // print(data['password']);

        // return checkPassword(data['password'], controller);
        // }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // showSheetForQr(QRViewController controller) {
  //   showModalBottomSheet(
  //       backgroundColor: Theme.of(context).primaryColor,
  //       context: context,
  //       builder: (context) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 30),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               SizedBox(height: MediaQuery.of(context).size.height * 0.08),
  //               Icon(
  //                 MdiIcons.alertOutline,
  //                 color: Theme.of(context).errorColor,
  //                 size: 78,
  //               ),
  //               SizedBox(height: MediaQuery.of(context).size.height * 0.06),
  //               Text(
  //                 "Wrong Password",
  //                 style: Theme.of(context).textTheme.headline5,
  //               ),
  //               SizedBox(height: MediaQuery.of(context).size.height * 0.015),
  //               Text(
  //                 "Please enter correct password provided behind the Device",
  //                 style: Theme.of(context).textTheme.subtitle1,
  //                 textAlign: TextAlign.center,
  //               ),
  //               SizedBox(height: MediaQuery.of(context).size.height * 0.005),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                       child: ElevatedButton(
  //                           style: TextButton.styleFrom(
  //                               backgroundColor: Color(0xff003C42)),
  //                           onPressed: () {
  //                             widget.device.disconnect().then((value) =>
  //                                 Navigator.of(context).push(MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         BluetoothListScreen())));
  //                             Navigator.of(context).pop();
  //                           },
  //                           child: Text(
  //                             "Cancle",
  //                             style: TextStyle(color: Colors.white),
  //                           ))),
  //                   SizedBox(
  //                     width: 20,
  //                   ),
  //                   Expanded(
  //                       child: ElevatedButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               controller.resumeCamera();
  //                             });
  //                             Navigator.of(context).pop();
  //                           },
  //                           child: Text(
  //                             "Retry",
  //                             style: TextStyle(
  //                                 color: Theme.of(context).primaryColor),
  //                           ))),
  //                 ],
  //               ),
  //               SizedBox(height: MediaQuery.of(context).size.height * 0.02),
  //             ],
  //           ),
  //         );
  //       });
  // }

  // showSheet() {
  //   showModalBottomSheet(
  //       backgroundColor: Theme.of(context).primaryColor,
  //       context: context,
  //       builder: (context) {
  //         return WillPopScope(
  //           onWillPop: () async {
  //             Navigator.of(context).pop();
  //             return false;
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 30),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 SizedBox(height: MediaQuery.of(context).size.height * 0.08),
  //                 Icon(
  //                   MdiIcons.alertOutline,
  //                   color: Theme.of(context).errorColor,
  //                   size: 78,
  //                 ),
  //                 SizedBox(height: MediaQuery.of(context).size.height * 0.06),
  //                 Text(
  //                   "Wrong Password",
  //                   style: Theme.of(context).textTheme.headline5,
  //                 ),
  //                 SizedBox(height: MediaQuery.of(context).size.height * 0.015),
  //                 Text(
  //                   "Please enter correct password provided behind the Device",
  //                   style: Theme.of(context).textTheme.subtitle1,
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(height: MediaQuery.of(context).size.height * 0.005),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                         child: ElevatedButton(
  //                             style: TextButton.styleFrom(
  //                                 backgroundColor: Color(0xff003C42)),
  //                             onPressed: () {
  //                               Navigator.of(context).pop();
  //                             },
  //                             child: Text(
  //                               "Cancle",
  //                               style: TextStyle(color: Colors.white),
  //                             ))),
  //                     SizedBox(
  //                       width: 20,
  //                     ),
  //                     Expanded(
  //                         child: ElevatedButton(
  //                             onPressed: () {
  //                               Navigator.of(context).pop();
  //                             },
  //                             child: Text(
  //                               "Retry",
  //                               style: TextStyle(
  //                                   color: Theme.of(context).primaryColor),
  //                             ))),
  //                   ],
  //                 ),
  //                 SizedBox(height: MediaQuery.of(context).size.height * 0.02),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
}
