import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ynotes/core/utils/nullSafeMapGetter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

class QRCodeLoginPage extends StatefulWidget {
  const QRCodeLoginPage({Key? key}) : super(key: key);

  @override
  _QRCodeLoginPageState createState() => _QRCodeLoginPageState();
}

class _QRCodeLoginPageState extends State<QRCodeLoginPage> {
  Barcode? result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  PageController pageCon = PageController(initialPage: 0);
  QRViewController? controller;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return PageView(
      controller: pageCon,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenSize.size.width / 5 * 3.5,
              height: screenSize.size.height / 10 * 3.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Scannez le QR code fourni par Pronote",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold, fontSize: 35),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenSize.size.width / 5 * 3.4,
              child: PinCodeTextField(
                appContext: context,
                length: 4,
                onChanged: (value) {},
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Entrez le code à 4 chiffres",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.w600, fontSize: 35),
            ),
          ],
        ),
      ],
    );
  }

  void processData(Barcode data) {
    Map? raw = jsonDecode(data.code);
    if (raw != null) {
      print(raw);
      if (mapGet(raw, ["jeton"]) != null && mapGet(raw, ["login"]) != null && mapGet(raw, ["url"]) != null) {
        pageCon.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
      } else {
        print(raw);
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      processData(scanData);
    });
  }
}
