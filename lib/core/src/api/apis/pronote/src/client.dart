part of pronote;

abstract class PronoteClient {
  final String username;
  final String password;
  final String url;
  final bool isCas; // either using qrcode or mobileLogin
  late final _Communication communication;
  late _Encryption encryption;
  late Map<String, dynamic> attributes;

  PronoteClient({required this.username, required this.password, required this.url, required this.isCas}) {
    communication = _Communication(this);
  }
}