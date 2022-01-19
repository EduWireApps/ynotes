part of pronote_client;

class Encryption {
  IV? aesIV;

  late IV aesIVTemp;

  dynamic aesKey;

  late Map rsaKeys;

  Encryption() {
    aesIV = IV.fromLength(16);
    aesIVTemp = IV.fromSecureRandom(16);
    aesKey = generateMd5("");

    rsaKeys = {};
  }
  aesDecrypt(var data) {
    var key = Key.fromBase16(aesKey.toString());
    final aesEncrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    //generate AES CBC block encrypter with key and PKCS7 padding

    Logger.log("PRONOTE", aesIV?.base16.toString() ?? "");

    try {
      return aesEncrypter.decrypt64(conv.base64.encode(data), iv: aesIV);
    } catch (e) {
      throw ("Error during decryption : $e");
    }
  }

  aesDecryptAsBytes(List<int> data) {
    var key = Key.fromBase16(aesKey.toString());
    final aesEncrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    //generate AES CBC block encrypter with key and PKCS7 padding

    Logger.log("PRONOTE", aesIV.toString());

    try {
      return aesEncrypter.decryptBytes(Encrypted.from64(conv.base64.encode(data)), iv: aesIV);
    } catch (e) {
      throw ("Error during decryption : $e");
    }
  }

  aesEncrypt(List<int> data, {padding = true, disableIV = false}) {
    try {
      dynamic iv;
      var key = Key.fromBase16(aesKey.toString());
      Logger.log("PRONOTE", "KEY :" + aesKey.toString());
      iv = aesIV;
      Logger.log("PRONOTE", iv.base16);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: padding ? "PKCS7" : null));
      final encrypted = encrypter.encryptBytes(data, iv: iv).base16;

      return (encrypted);
    } catch (e) {
      throw "Error during aes encryption " + e.toString();
    }
  }

  aesEncryptFromString(String data) {
    var key = Key.fromBase16(aesKey.toString());
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    final encrypted = encrypter.encrypt(data, iv: aesIV).base16;

    return (encrypted);
  }

  aesSetIV(var iv) {
    if (iv == null) {
      aesIV = IV.fromLength(16);
    } else {
      aesIV = iv;
    }
  }

  String generateMd5(String input) {
    return md5.convert(conv.utf8.encode(input)).toString();
  }

  rsaEncrypt(Uint8List data) async {
    try {
      Logger.log("PRONOTE", rsaKeys.toString());
      String? modulusBytes = rsaKeys['MR'];

      var modulus = BigInt.parse(modulusBytes!, radix: 16);

      var exponent = BigInt.parse(rsaKeys['ER']!, radix: 16);

      var cipher = PKCS1Encoding(RSAEngine());
      cipher.init(true, PublicKeyParameter<RSAPublicKey>(RSAPublicKey(modulus, exponent)));
      Uint8List output1 = cipher.process(data);

      return output1;
    } catch (e) {
      throw ("Error while RSA encrypting " + e.toString());
    }
  }
}
