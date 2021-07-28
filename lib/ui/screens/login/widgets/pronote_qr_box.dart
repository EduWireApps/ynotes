import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart' as conv;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core/apis/pronote/pronote_api.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/null_safe_map_getter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/animations/fade_animation.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/screens/login/widgets/login_dialog.dart';
import 'package:ynotes_packages/theme.dart';

export 'package:rive/src/generated/animation/state_machine_base.dart';

class PronoteQrCodeBox extends StatefulWidget {
  const PronoteQrCodeBox({Key? key}) : super(key: key);

  @override
  _PronoteQrCodeBoxState createState() => _PronoteQrCodeBoxState();
}

class _PronoteQrCodeBoxState extends State<PronoteQrCodeBox> {
  Map? loginData;
  Barcode? result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  PageController pageCon = PageController(initialPage: 0);
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 1.1.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), color: theme.colors.neutral.shade300),
      child: Column(
        children: [
          Container(
            height: 40.h,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageCon,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50.w.clamp(0, 500),
                        height: 50.w.clamp(0, 500),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder<bool?>(
                                future: controller?.getFlashStatus(),
                                builder: (context, flashFuture) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: (flashFuture.data ?? false)
                                            ? theme.colors.primary.shade300
                                            : theme.colors.neutral.shade200,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      onPressed: () {
                                        controller?.toggleFlash();
                                        setState(() {});
                                      },
                                      icon: Icon(MdiIcons.flashlight,
                                          color: (flashFuture.data ?? false)
                                              ? Colors.white
                                              : theme.colors.neutral.shade500),
                                    ),
                                  );
                                }),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(color: theme.colors.neutral.shade200, shape: BoxShape.circle),
                              child: IconButton(
                                onPressed: () {
                                  controller?.flipCamera();
                                },
                                icon: Icon(
                                  MdiIcons.cameraFlip,
                                  color: theme.colors.neutral.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (loginData != null)
                        FadeAnimation(
                          0.5,
                          Text(
                            "✓ QR Code détecté",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Asap", color: Colors.green, fontWeight: FontWeight.w400, fontSize: 22),
                          ),
                        ),
                      SizedBox(height: 25),
                      if (loginData != null)
                        CustomButtons.materialButton(context, 130, 39, () {
                          pageCon.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                        }, label: "Continuer", backgroundColor: Color(0xff4ADE80), icon: Icons.arrow_forward_rounded)
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 45.w.clamp(0, 500),
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
                    Text(
                      "Entrez le code à 4 chiffres que vous avez entré au moment de la génération du QR code.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Asap",
                          color: ThemeUtils.textColor(),
                          fontWeight: FontWeight.normal,
                          fontSize: 21),
                    ),
                    SizedBox(height: 25),
                    CustomButtons.materialButton(context, null, 39, () {
                      setState(() {
                        loginData = null;
                      });
                      pageCon.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                    }, label: "Re-scanner un QR Code", backgroundColor: Colors.grey, icon: Icons.arrow_back_ios_rounded)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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

      appSys.settings.system.uuid = Uuid().v4();
      appSys.saveSettings();

      //Open the loading dialog with credentials
      openLoadingDialog(appSys.api!.login(login, pass, additionnalSettings: {
        "url": loginData?["url"] + "?login=true",
        "qrCodeLogin": true,
        "mobileCasLogin": false,
      }));
    } catch (e) {
      CustomLogger.log("LOGIN", "(QR Code) An error occured with the PIN");
      CustomLogger.error(e);
      CustomDialogs.showAnyDialog(context, "Votre code PIN est invalide");
      return;
    }
  }

  @override
  void initState() {
    super.initState();
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
        //If data is well formed add the button to navigate to the second page where the user will be invited to enter the PIN
        setState(() {
          loginData = jsonDecode(scanData.code);
        });
      }
    });
  }
}
