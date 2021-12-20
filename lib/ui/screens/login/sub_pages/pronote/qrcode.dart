import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ynotes/core/logic/pronote/login/qr_code/qr_login_controller.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPronoteQrcodePage extends StatefulWidget {
  const LoginPronoteQrcodePage({Key? key}) : super(key: key);

  @override
  _LoginPronoteQrcodePageState createState() => _LoginPronoteQrcodePageState();
}

class _LoginPronoteQrcodePageState extends State<LoginPronoteQrcodePage> {
  final QrLoginController controller = QrLoginController();
  QRViewController? qrController;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    handlePermission();
  }

  Future<void> handlePermission() async {
    final String? res = await controller.handlePermission();
    if (res == null) {
      setState(() {
        loaded = true;
      });
    } else {
      await YDialogs.showInfo(
          context,
          YInfoDialog(
            title: LoginContent.pronote.qrCode.permissionDenied,
            body: Text(res, style: theme.texts.body1),
            confirmLabel: "OK",
          ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<QrLoginController>(
      controller: controller,
      builder: (context, controller, child) => YPage(
        appBar: YAppBar(title: LoginContent.pronote.qrCode.title),
        scrollable: false,
        floatingButtons: loaded
            ? (controller.status == QrStatus.initial
                ? [
                    YFloatingButton(
                        icon: MdiIcons.cameraFlip,
                        onPressed: () {
                          qrController?.flipCamera();
                        },
                        color: YColor.secondary),
                    YFloatingButton(
                        icon: MdiIcons.flashlight,
                        onPressed: () {
                          qrController?.toggleFlash();
                        },
                        color: YColor.secondary),
                  ]
                : null)
            : null,
        body: loaded && controller.status == QrStatus.initial
            ? Column(children: [
                Expanded(
                    child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QRView(
                        key: GlobalKey(debugLabel: 'QR'),
                        onQRViewCreated: (QRViewController qrController) async {
                          this.qrController = qrController;
                          qrController.scannedDataStream.listen((barCode) async {
                            if (controller.status == QrStatus.initial && controller.isQrCodeValid(barCode)) {
                              await getCode();
                            }
                          });
                        }),
                    const QrCrossHair()
                  ],
                ))
              ])
            : Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Column(
                      children: [
                        YVerticalSpacer(YScale.s16),
                        if (loaded)
                          Text(
                            LoginContent.pronote.qrCode.connecting,
                            style: theme.texts.body1,
                            textAlign: TextAlign.center,
                          ),
                        YVerticalSpacer(YScale.s6),
                        const YLinearProgressBar(),
                      ],
                    )),
              ),
      ),
    );
  }

  Future<void> getCode() async {
    final String? res = await YDialogs.getInput(
        context,
        YInputDialog(
            title: LoginContent.pronote.qrCode.code,
            input: YFormField(
              type: YFormFieldInputType.number,
              label: LoginContent.pronote.qrCode.code,
              properties: YFormFieldProperties(),
              validator: (String? value) {
                if (value == null || value.isEmpty || value.length != 4) {
                  return LoginContent.pronote.qrCode.fieldMessage;
                }
                return null;
              },
              maxLength: 4,
            )));
    if (res != null) {
      await login(res);
    } else {
      controller.reset();
    }
  }

  Future<void> login(String code) async {
    final List<String>? decryptedData = controller.decrypt(code);
    if (decryptedData == null) {
      YSnackbars.error(context,
          title: LoginContent.pronote.qrCode.error, message: LoginContent.pronote.qrCode.errorMessage);
      getCode();
      return;
    }

    //Login
    final List<dynamic>? data = await appSys.api!.login(decryptedData[0], decryptedData[1], additionnalSettings: {
      "url": controller.url + "?login=true",
      "qrCodeLogin": true,
      "mobileCasLogin": false,
    });
    if (data != null && data[0] == 1) {
      YSnackbars.success(context, title: LoginContent.pronote.qrCode.connected, message: data[1]);
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacementNamed(context, "/terms");
    } else {
      YSnackbars.error(context, title: LoginContent.pronote.qrCode.error, message: data![1]);
      controller.reset();
    }
  }
}
