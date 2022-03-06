part of pronote;

class PronoteClient {
  final Map parameters;
  String username;
  String password;
  late String url;
  late PronoteLoginWay loginWay;
  late bool isCas; // either using qrcode or mobileLogin

  late final _Communication communication;
  late _Encryption encryption;

  late Map<String, dynamic> attributes;

  PronoteClient({required this.username, required this.password, required this.parameters}) {
    communication = _Communication(this);
    url = parameters["url"];

    PronoteLoginWay _loginWay() {
      switch (parameters["loginWay"]) {
        case "qr":
          return PronoteLoginWay.qrCodeLogin;
        case "cas":
          return PronoteLoginWay.casLogin;
        default:
          return PronoteLoginWay.standardLogin;
      }
    }

    loginWay = _loginWay();
    isCas = loginWay != PronoteLoginWay.standardLogin;
  }
}
