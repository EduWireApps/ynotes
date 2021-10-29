import 'dart:convert';

import 'package:convert/convert.dart' as conv;
import 'package:crypto/crypto.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core/apis/pronote/pronote_api.dart';
import 'package:ynotes/core/utils/controller.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/utils/null_safe_map_getter.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/globals.dart';

/// The status of the controller
enum QrStatus { initial, loading, success, error }

/// A class that handles the QR code method for Pronote login
class QrLoginController extends Controller {
  /// A class that handles the QR code method for Pronote login
  QrLoginController();

  /// The controller status
  QrStatus get status => _status;
  QrStatus _status = QrStatus.initial;

  /// The loginData extracted from the QR code
  Map<dynamic, dynamic>? _loginData;

  /// The url extracted from the [_loginData]
  String get url => _loginData?["url"];

  /// Handles camera permissions
  Future<String?> handlePermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return null;
    }
    if (status.isDenied) {
      final res = await Permission.camera.request();
      UIUtils.setSystemUIOverlayStyle();
      if (res.isGranted) {
        return null;
      } else {
        return "Vous avez refusé l'accès à la caméra pour yNotes. Cette fonctionnalité repose sur la caméra, veuillez réessayer et accepter.";
      }
    }
    if (status.isPermanentlyDenied) {
      return "Vous avez bloqué l'accès à la caméra de façon permanente pour yNotes. Pour accéder à cette fonctionnalité, veuillez la modifier dans les paramètres de votre téléphone.";
    }
  }

  /// Check if the Qr code is valid for the connection.
  bool isQrCodeValid(Barcode barCode) {
    try {
      Map? raw = jsonDecode(barCode.code);
      if (raw != null) {
        if (mapGet(raw, ["jeton"]) != null && mapGet(raw, ["login"]) != null && mapGet(raw, ["url"]) != null) {
          setState(() {
            _status = QrStatus.loading;
            _loginData = raw;
          });
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

  /// Decrypts the [_loginData] with the pin code set on the Pronote website/app
  List<String>? decrypt(String code) {
    setState(() {
      _status = QrStatus.loading;
    });
    final Encryption encrypt = Encryption();
    // We set the key
    encrypt.aesKey = md5.convert(utf8.encode(code));
    try {
      /// We try to decrypt the data. If it doesn't work, we throw an error
      final String login = encrypt.aesDecrypt(conv.hex.decode(_loginData?["login"]));
      final String password = encrypt.aesDecrypt(conv.hex.decode(_loginData?["jeton"]));
      appSys.settings.system.uuid = const Uuid().v4();
      appSys.saveSettings();
      setState(() {
        _status = QrStatus.success;
      });
      return [login, password];
    } catch (e) {
      setState(() {
        _status = QrStatus.error;
      });
      CustomLogger.log("LOGIN", "(QR Code) An error occured with the PIN");
      CustomLogger.error(e);
    }
  }

  /// Reset the controller
  void reset() {
    setState(() {
      _status = QrStatus.initial;
      _loginData = null;
    });
  }
}
