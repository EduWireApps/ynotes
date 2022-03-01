part of pronote_controllers;

/// The status of the controller
enum QrStatus { initial, loading, success, error }

/// A class that handles the QR code method for Pronote login
class QrLoginController extends ChangeNotifier {
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
      UIU.setSystemUIOverlayStyle();
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
    if (barCode.code == null) return false;
    try {
      Map? raw = jsonDecode(barCode.code!);
      if (raw != null) {
        if (raw["jeton"] != null && raw["login"] != null && raw["url"] != null) {
          _status = QrStatus.loading;
          _loginData = raw;
          notifyListeners();
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
    // TODO: finish pronote_client and uncomment
    return null;
    /*
    _status = QrStatus.loading;
    notifyListeners();
    final Encryption encrypt = Encryption();
    // We set the key
    encrypt.aesKey = md5.convert(utf8.encode(code));
    try {
      /// We try to decrypt the data. If it doesn't work, we throw an error
      final String login = encrypt.aesDecrypt(conv.hex.decode(_loginData?["login"]));
      final String password = encrypt.aesDecrypt(conv.hex.decode(_loginData?["jeton"]));
      SettingsService.settings.global.uuid = const Uuid().v4();
      SettingsService.update();
      _status = QrStatus.success;
      notifyListeners();
      return [login, password];
    } catch (e) {
      _status = QrStatus.error;
      notifyListeners();
      Logger.log("LOGIN", "(QR Code) An error occured with the PIN");
      Logger.error(e, stackHint:"Ng==");
    }
    */
  }

  /// Reset the controller
  void reset() {
    _status = QrStatus.initial;
    _loginData = null;
    notifyListeners();
  }
}
