import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart' as conv;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rive/rive.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/core/utils/nullSafeMapGetter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/screens/login/loginPage.dart';

export 'package:rive/src/generated/animation/state_machine_base.dart';

class QRCodeLoginPage extends StatefulWidget {
  const QRCodeLoginPage({Key? key}) : super(key: key);

  @override
  _QRCodeLoginPageState createState() => _QRCodeLoginPageState();
}

class _QRCodeLoginPageState extends State<QRCodeLoginPage> {
  Map? loginData;
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
                  height: screenSize.size.height / 10 * 2.5,
                  child: SvgPicture.asset("assets/images/pageItems/login/qrPin.svg")),
              SizedBox(
                height: screenSize.size.height / 10 * 0.3,
              ),
              Container(
                width: screenSize.size.width / 5 * 3.4,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  onChanged: (value) async {
                    if (int.tryParse(value) != null && value.length == 4) {
                      await decryptAndOpenLoading(value);
                    }
                  },
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

  //On pin value
  //Decrypt the pass and login and init login
  decryptAndOpenLoading(String pinValue) async {
    Encryption encrypt = Encryption();
    encrypt.aesKey = md5.convert(utf8.encode(pinValue));

    //Decrypt credentials
    try {
      String pass = encrypt.aesDecrypt(conv.hex.decode(loginData?["jeton"]));
      String login = encrypt.aesDecrypt(conv.hex.decode(loginData?["login"]));

      //Init the device UUID (important)
      //Used by pronote to fingerprint the device
      await appSys.updateSetting(appSys.settings!["system"], "uuid", Uuid().v4());

      //Open the loading dialog with credentials
      openLoadingDialog(appSys.api!.login(login, pass, additionnalSettings: {
        "url": loginData?["url"] + "?login=true",
        "qrCodeLogin": true,
        "mobileCasLogin": false,
      }));
    } catch (e) {
      print(e);
      CustomDialogs.showAnyDialog(context, "Votre code PIN est invalide");
      return;
    }
  }

  //Rive animation : loaded in the QR code scanner
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

  //The login dialog : this dialog loads the connection data and initiate login with Pronote
  openLoadingDialog(Future<List> connectionData) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoginDialog(connectionData);
        });
  }

  //We process the data read by the qrcode scanner
  //Returns true if this one is well formed
  Future<bool> processData(Barcode data) async {
    try {
      Map? raw = jsonDecode(data.code);
      if (raw != null) {
        if (mapGet(raw, ["jeton"]) != null && mapGet(raw, ["login"]) != null && mapGet(raw, ["url"]) != null) {
          stateMachineController?.inputs.first.change(true);
          await Future.delayed(const Duration(seconds: 3), () => "1");
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //Launched at QR view creation
  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (await processData(scanData)) {
        loginData = jsonDecode(scanData.code);
        //If data is well formed we change to the second page where the user is invited to enter the PIN
        pageCon.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    });
  }
}
