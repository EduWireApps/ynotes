import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rive/rive.dart';
import 'package:ynotes/core/utils/nullSafeMapGetter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

export 'package:rive/src/generated/animation/state_machine_base.dart';

class QRCodeLoginPage extends StatefulWidget {
  const QRCodeLoginPage({Key? key}) : super(key: key);

  @override
  _QRCodeLoginPageState createState() => _QRCodeLoginPageState();
}

class _QRCodeLoginPageState extends State<QRCodeLoginPage> {
  Barcode? result;
  StateMachineController? stateMachineController;

  Artboard? _riveArtboard;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  PageController pageCon = PageController(initialPage: 0);
  late QRViewController controller;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageCon,
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenSize.size.width / 5 * 3.5,
                height: screenSize.size.height / 10 * 3.5,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
                    ),
                    _riveArtboard != null
                        ? Container(
                            height: screenSize.size.height / 10 * 4.5,
                            child: Rive(
                              artboard: _riveArtboard!,
                            ),
                          )
                        : SizedBox(),
                  ],
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
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
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
                    fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.w500, fontSize: 35),
              ),
              Text(
                "C'est le code que vous avez entré au moment de la génération du QR code.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.normal, fontSize: 21),
              ),
            ],
          ),
        ),
      ],
    );
  }

  initRive() async {
    await rootBundle.load('assets/animations/qr_animation.riv').then(
      (data) async {
        final file = RiveFile.import(data);

        // Load the RiveFile from the binary data.

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        stateMachineController = StateMachineController.fromArtboard(artboard, "StateMachine");
        artboard.addController(stateMachineController!);
        stateMachineController?.inputs.first.change(false);

        setState(() {
          _riveArtboard = artboard;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initRive();
  }

  Future<bool> processData(Barcode data) async {
    Map? raw = jsonDecode(data.code);
    if (raw != null) {
      if (mapGet(raw, ["jeton"]) != null && mapGet(raw, ["login"]) != null && mapGet(raw, ["url"]) != null) {
        stateMachineController?.inputs.first.change(true);
        await Future.delayed(const Duration(seconds: 3), () => "1");
        return true;
      } else {
        print(raw);
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      await processData(scanData);
      pageCon.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }
}
