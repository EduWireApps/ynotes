import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:requests/requests.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:steel_crypt/steel_crypt.dart';
void testingEncryptor()
{

   /* print("Starting test ");
    var data = 1;
    print("Data : $data");
    var aes_key = md5.convert(utf8.encode("")).toString();
    print("Aes_key : $aes_key");
    var key = Key.fromBase16(aes_key);
    var aes_iv = IV.fromBase16("00000000000000000000000000000000");
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    final encrypted = encrypter.encrypt(data.toString(), iv: aes_iv).base16;
    print("Results :");
    print(encrypted) ;
   
*/
print("Starting test");
List<int> list = List();
    for (var i = 0; i < 16; i++) {
      var rng = new Random();
      list.add(rng.nextInt(255));
    }


  var aes_iv_temp = Uint8List.fromList(list);
  print(aes_iv_temp);
  var modulusBytes = "B99B77A3D72D3A29B4271FC7B7300E2F791EB8948174BE7B8024667E915446D4EEA0C2424B8D1EBF7E2DDFF94691C6E994E839225C627D140A8F1146D1B0B5F18A09BBD3D8F421CA1E3E4796B301EEBCCF80D81A32A1580121B8294433C38377083C5517D5921E8A078CDC019B15775292EFDA2C30251B1CCABE812386C893E5";
    var modulus =
        BigInt.parse(hex.encode(utf8.encode(modulusBytes)), radix: 16);
    var exponent =
        BigInt.parse(hex.encode(utf8.encode("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001")), radix: 16);
    var engine = RSAEngine()
      ..init(
        true,
        PublicKeyParameter<RSAPublicKey>(RSAPublicKey(modulus, exponent)),
      );

    //PKCS1.5 padding
    var k = modulusBytes.length;
    print(k);
    var plainBytes = aes_iv_temp;
    print(plainBytes.length);
    var paddingLength = k - 3 - plainBytes.length;
    var eb = Uint8List(paddingLength + 3 + plainBytes.length);
    var r = Random.secure();
    eb.setRange(paddingLength + 3, eb.length, plainBytes);
    eb[0] = 0;
    eb[1] = 2;
    eb[paddingLength + 2] = 0;
    for (int i = 2; i < paddingLength + 2; i++) {
      eb[i] = r.nextInt(254) + 1;
    }
 
    print(base64.encode(engine.process(eb))) ;
}