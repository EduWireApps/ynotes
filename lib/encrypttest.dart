import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pointycastle/asymmetric/pkcs1.dart';
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

void testingEncryptor() {
/*    /* print("Starting test ");
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

 //print(aes_iv_temp);
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
    var plainBytes = engine..;
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
    //engine.process(eb
  */
  print("Starting test");

  //Generating a list of 16 random int
  List<int> list = List();
  for (var i = 0; i < 16; i++) {
    var rng = new Random();
    list.add(rng.nextInt(255));
  }

//Byte from this list
  var aes_iv_temp = Uint8List.fromList(list);
  //Hardcoded modulus
  var modulusBytes = "B99B77A3D72D3A29B4271FC7B7300E2F791EB8948174BE7B8024667E915446D4EEA0C2424B8D1EBF7E2DDFF94691C6E994E839225C627D140A8F1146D1B0B5F18A09BBD3D8F421CA1E3E4796B301EEBCCF80D81A32A1580121B8294433C38377083C5517D5921E8A078CDC019B15775292EFDA2C30251B1CCABE812386C893E5";
  //Converting modulus and exponent
  var modulus = BigInt.parse(modulusBytes, radix: 16);
  var exponent = BigInt.parse("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001",radix: 16);
     
      print(hex.encode(utf8.encode("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001",)));
  //Init the encoding with padding    
  var cipher = PKCS1Encoding(RSAEngine());
  cipher.init(true, PublicKeyParameter<RSAPublicKey>(RSAPublicKey(modulus, exponent)));
  Uint8List output1 = cipher.process(aes_iv_temp);
  //Printing output
  print(base64Encode(output1));

  //What I get : a string of 344 length "C4n4g1nI4rl0fCnsSkZO9yXjl/Y9XCXo5OwzRDPPCJO9qS8Q3KQ6xi0SpBdPug5iqOePbQWm76y/Kr1YOAMauKTNzfqiKzsgk7gMIAybs1zvhP9KBZmaNzDnDemeJeHPDmR5PO2Y7laoCbhK5UA2akM2zDOvsRY/GnjauLwXQN2UdavieaIj/WCzX84H+itOvhYJFb5Hf81IIUGfdF1Ebz7MbwnkQ7QgZfojQVJXAvN+mar4D475IRlBkqEwy5/o+YRVGDnXVH2C5kXg0icp0slG2I6L/erw5rVuaaomXAe759po4qRxxwBbhs8WPljkWIS1qHvhXXs6xJvDNs2SkA=="
  //What I should get : a string of 172 length
}
