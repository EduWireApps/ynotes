part of pronote;


class _Encryption {
  late IV aesIV;
  late final IV aesIVTemp;
  late final Key aesKey;

  _Encryption() {
    aesIV = IV.fromLength(16);
    aesIVTemp = IV.fromSecureRandom(16);
    aesKey = Key.fromBase16(generateMd5(""));
  }

  Response<String> aesDecrypt(List<int> input) {
    final Encrypter aesEncrypter = Encrypter(AES(aesKey, mode: AESMode.cbc, padding: "PKCS7"));
    try {
      final String decrypted = aesEncrypter.decrypt64(base64.encode(input), iv: aesIV);
      return Response(data: decrypted);
    } catch (e) {
      return Response(error: "Error during AES decryption: $e");
    }
  }

  Response<List<int>> aesDecryptAsBytes(List<int> input) {
    final Encrypter aesEncrypter = Encrypter(AES(aesKey, mode: AESMode.cbc, padding: "PKCS7"));
    try {
      final List<int> decrypted = aesEncrypter.decryptBytes(Encrypted.from64(base64.encode(input)), iv: aesIV);
      return Response(data: decrypted);
    } catch (e) {
      return Response(error: "Error during AES decryption: $e");
    }
  }

  Response<String> aesEncrypt(List<int> input, {bool padding = true}) {
    try {
      final Encrypter encrypter = Encrypter(AES(aesKey, mode: AESMode.cbc, padding: padding ? "PKCS7" : null));
      final String encrypted = encrypter.encryptBytes(input, iv: aesIV).base16;
      return Response(data: encrypted);
    } catch (e) {
      return Response(error: "Error during AES encryption: $e");
    }
  }

  Response<String> aesEncryptFromString(String input) {
    try {
      final Encrypter encrypter = Encrypter(AES(aesKey, mode: AESMode.cbc, padding: "PKCS7"));
      final String encrypted = encrypter.encrypt(input, iv: aesIV).base16;
      return Response(data: encrypted);
    } catch (e) {
      return Response(error: "Error during AES encryption: $e");
    }
  }

  void setAesIV([IV? iv]) {
    aesIV = iv ?? IV.fromLength(16);
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Response<Uint8List> rsaEncrypt(Uint8List input, Map<String, String> rsaKeys) {
    if (rsaKeys["MR"] == null || rsaKeys["ER"] == null) {
      return const Response(error: "Missing RSA keys");
    }
    try {
      final String modulusBytes = rsaKeys['MR']!;
      final BigInt modulus = BigInt.parse(modulusBytes, radix: 16);
      final BigInt exponent = BigInt.parse(rsaKeys['ER']!, radix: 16);
      final PKCS1Encoding cipher = PKCS1Encoding(RSAEngine())
        ..init(true, PublicKeyParameter<RSAPublicKey>(RSAPublicKey(modulus, exponent)));
      final Uint8List encrypted = cipher.process(input);
      return Response(data: encrypted);
    } catch (e) {
      return Response(error: "Error during RSA encryption: $e");
    }
  }
}

