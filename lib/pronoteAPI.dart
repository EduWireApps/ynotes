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
Map error_messages = {
  22: '[ERROR 22] The object was from a previous session. Please read the "Long Term Usage" section in README on github.',
  10: '[ERROR 10] Session has expired and pronotepy was not able to reinitialise the connection.'
};

class Client {
  var username;
  var password;
  var pronote_url;
  _Communication communication;
  var attributes;
  var func_options;

  bool ent;

  var encryption;

  double _last_ping;

  DateTime date;

  DateTime start_day;

  var week;

  var periods;

  var periods_;

  bool _expired;

  var auth_response;
  void refresh() async {
    this.communication = _Communication(this.pronote_url, null, this);
    var future = await this.communication.initialise();
    this.attributes = future[0];
    this.func_options = future[1];
    this.encryption = _Encryption();
    this.encryption.aes_iv = this.communication.encryption.aes_iv;
    this._login();
    this.periods = Null;
    this.periods_ = this.periods_;
    this.week = this._get_week(DateTime.now());
    this._expired = true;
  }

  _get_week(DateTime date) {
    try {
      var test =
          (1 + (date.difference(this.start_day).inDays / 7).floor()).round();
    } catch (e) {
      print("WAWAWAW" + e.toString());
    }
    return (1 + (date.difference(this.start_day).inDays / 7).floor()).round();
  }

  Client(String pronote_url, {String username, String password, var cookies}) {
    print("init");
    if (cookies == null && password == null && username == null) {
      throw 'Please provide login credentials. Cookies are None, and username and password are empty.';
    }
    this.username = username;
    this.password = password;
    this.pronote_url = pronote_url;
    this.communication = _Communication(pronote_url, cookies, this);
  }
  Future init() async {
    this.attributes = await this.communication.initialise();
    this.func_options = await this.communication.initialise();

    if (this.attributes.toString().contains("e") &&
        this.attributes.toString().contains("f")) {
      this.ent = true;
    } else {
      this.ent = false;
    }
    this.encryption = _Encryption();
    this.encryption.aes_iv = this.communication.encryption.aes_iv;
    this._last_ping = DateTime.now().millisecondsSinceEpoch / 1000;
    this.date = DateTime.now();
    this.start_day = DateTime.parse(this.func_options['donneesSec']['donnees']
        ['General']['PremierLundi']['V']);
    this.week = this._get_week(DateTime.now());
    this.periods_ = this.periods;
    this._expired = false;
  }

  _login() async {
    if (this.ent == true) {
      this.username = this.attributes['e'];
      this.password = this.attributes['f'];
    }

    Map ident_json = {
      "genreConnexion": 0,
      "genreEspace": int.parse(this.attributes['a']),
      "identifiant": this.username,
      "pourENT": this.ent,
      "enConnexionAuto": false,
      "demandeConnexionAuto": false,
      "demandeConnexionAppliMobile": false,
      "demandeConnexionAppliMobileJeton": false,
      "uuidAppliMobile": "",
      "loginTokenSAV": ""
    };
    var idr =
        this.communication.post("Identification", {'donnees': ident_json});

    var challenge = idr['donneesSec']['donnees']['challenge'];
    var e = _Encryption();
    e.aes_set_iv(this.communication.encryption.aes_iv);
    var motdepasse;

    if (this.ent == true) {
      List<int> encoded = utf8.encode(this.password);
      motdepasse = sha256.convert(encoded);
      motdepasse = hex.encode(motdepasse);
      motdepasse = motdepasse.toString().toUpperCase();
      e.aes_key = md5.convert(utf8.encode(motdepasse));
    } else {
      var u = this.username;
      var p = this.password;
      if (idr['donneesSec']['donnees']['modeCompLog']) {
        u = u.toString().toLowerCase();
      }

      if (idr['donneesSec']['donnees']['modeCompMdp']) {
        p = p.toString().toLowerCase();
      }

      var alea = idr['donneesSec']['donnees']['alea'];
      List<int> encoded = utf8.encode(alea + p);
      motdepasse = sha256.convert(encoded);
      motdepasse = hex.encode(motdepasse);
      motdepasse = motdepasse.toString().toUpperCase();
    }

    var dec = e.aes_decrypt(hex.decode(challenge));
    var dec_no_alea = _enleverAlea(utf8.decode(dec));
    var ch = hex.encode(e.aes_encrypt(utf8.encode(dec_no_alea)));

    Map auth_json = {
      "connexion": 0,
      "challenge": ch,
      "espace": int.parse(this.attributes['a'])
    };
    this.auth_response = await this
        .communication
        .post("Authentification", {'donnees': auth_json});
    if (this.auth_response['donneesSec']['donnees'].contains("cle")) {
      this.communication.after_auth(
          this.communication.last_response, this.auth_response, e.aes_key);
      this.encryption.aes_key = e.aes_key;
      print("LOGGED BRO");
      return true;
    } else {
      print("LOGIN FAIL");
      return false;
    }
  }
}

_enleverAlea(String text) {
  List sansalea = List();

  text.runes.forEach((int rune) {
    var character = new String.fromCharCode(rune);
    if (rune % 2 == 0) {
      sansalea.add(character);
    }
  });

  return sansalea.join("");
}

class _Communication {
  var cookies;
  var client;
  var html_page;
  var root_site;
  var encryption;
  Map attributes;
  int request_number;
  List authorized_onglets;
  bool compress_requests;
  double last_ping;
  bool encrypt_requests;
  var last_response;
  var session;
  var requests;

  _Communication(String site, var cookies, var client) {
    print(site);
    this.root_site = this.get_root_address(site)[0];
    this.html_page = this.get_root_address(site)[1];
    this.session = Requests;
    this.encryption = _Encryption();
    this.attributes = {};
    this.request_number = 1;
    this.cookies = cookies;
    this.last_ping = 0;
    this.authorized_onglets = [];
    this.client = client;
    this.compress_requests = false;
    this.encrypt_requests = false;
    this.last_response = null;
  }

  Future<List<Object>> initialise() async {
    var headers = {
      'connection': 'keep-alive',
      'User-Agent':
          'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0'
    };

    print(this.root_site + "/" + this.html_page);
    var get_response = await Requests.get(this.root_site + "/" + this.html_page,
        headers: headers,
        persistCookies: this.cookies != null ? this.cookies : false);
    this.attributes = this._parse_html(get_response.content());
    this.encryption.rsa_keys = {
      'MR': this.attributes['MR'],
      'ER': this.attributes['ER']
    };

    var uuid = base64
        .encode(await this.encryption.rsa_encrypt(this.encryption.aes_iv_temp));
    var json_post = {'Uuid': uuid};
    this.encrypt_requests =
        (this.attributes["sCra"] != null ? !this.attributes["sCra"] : false);
    this.compress_requests =
        (this.attributes["sCra"] != null ? !this.attributes["sCoA"] : false);
    var initial_response = await this.post('FonctionParametres', {
      'donnees': json_post
    }, decryption_change: {
      'iv': md5.convert(this.encryption.aes_iv_temp).toString()
    });

    return [this.attributes, initial_response];
  }

  _parse_html(String html) {
    var parsed = parse(html);
    var onload = parsed.getElementById("id_body");

    String onload_c;
    if (onload != null) {
      onload_c = onload.attributes["onload"]
          .substring(14, onload.attributes["onload"].length - 37);
    } else {
      if (html.contains("IP")) {
        throw ('Your IP address is suspended.');
      }
    }
    Map attributes = {};

    onload_c.split(',').forEach((attr) {
      var key = attr.split(':')[0];
      var value = attr.split(':')[1];
      attributes[key] = value.toString().replaceAll("'", "");
    });

    return attributes;
  }

  post(String function_name, var data,
      {bool recursive = false, var decryption_change = null}) async {
    print(1);
    if (data["_Signature_"] != null &&
        !this.authorized_onglets.contains(data['_Signature_']['onglet'])) {
      throw ('Action not permitted. (onglet is not normally accessible)');
    }
    print(2);
    if (this.compress_requests) {
      data = utf8.encode(jsonEncode(data.toString()));
      data = hex.encode(data);
      var zlibInstance = ZLibCodec(level: 6);
      data = zlibInstance.encode(data).sublist(2, data.length - 4);
    }
    print(data);
    if (this.encrypt_requests) {
      if (data.runtimeType == Map) {
        data = utf8.encode(data.toString());
      }
      data = hex.encode(encryption.aes_encrypt(data)).toUpperCase();
    }
    print("Request number:"+this.request_number.toString());
   
     print(hex.encode(encryption.aes_encrypt(utf8.encode(this.request_number.toString()))) );
    var r_number = hex.encode(
        encryption.aes_encrypt(utf8.encode(this.request_number.toString())));
     
    var json = {
      'session': int.parse(this.attributes['h']),
      'numeroOrdre': r_number,
      'nom': function_name,
      'donneesSec': data
    };
    print("Json: " + json.toString());
    print(5);
    String p_site = this.root_site +
        '/appelfonction/' +
        this.attributes['a'] +
        '/' +
        this.attributes['h'] +
        '/' +
        r_number;
    print("p_site: " + p_site);
    this.request_number += 2;
    /*var response =
        await Requests.post(p_site, json: json, persistCookies: false);

    this.last_ping = (DateTime.now().millisecondsSinceEpoch / 1000);
    this.last_response = response;
    print(response.content());
    if (response.hasError) {
      throw "Status code: ${response.statusCode}";
    }
    if (response.content().contains("Erreur")) {
      print("Error occured");
      var r_json = response.json();
      if (r_json["Erreur"]['G'] == 22) {
        throw error_messages["22"];
      }
      if (recursive) {
        throw "Unknown error from pronote: ${r_json["Erreur"]["G"]} | ${r_json["Erreur"]["Titre"]}";
      }
      //await this.client.refresh();
      //return await this.client.communication.post(function_name, data, true);
    }

    if (decryption_change != null) {
      print("decryption change");
      if (decryption_change.toString().contains("iv"))
        print(decryption_change['iv']);
      this.encryption.aes_iv = IV.fromBase16(decryption_change['iv']);
      if (decryption_change.toString().contains("key"))
        print(decryption_change['key']);
      this.encryption.aes_key = decryption_change['key'];
    }

    Map response_data = response.json();

    if (this.encrypt_requests) {
      response_data['donneesSec'] =
          this.encryption.aes_decrypt(hex.decode(response_data['donneesSec']));
      print("décrypté données sec");
    }
    var zlibInstanceDecode = ZLibCodec(windowBits: 15);
    if (this.compress_requests) {
      response_data['donneesSec'] =
          zlibInstanceDecode.decode(response_data['donneesSec']);
    }
    if (response_data['donneesSec'].runtimeType == String) {
      try {
        response_data['donneesSec'] = jsonDecode(response_data['donneesSec']);
      } catch (e) {
        throw "JSONDecodeError";
      }

      return response_data;
    }*/
  }

  after_auth(var auth_response, var data, var auth_key) {
    this.encryption.aes_key = auth_key;
    if (!this.cookies) {

      this.cookies = auth_response.cookies;
    }
    this.authorized_onglets =
        _prepare_onglets(data['donneesSec']['donnees']['listeOnglets']);
    var work = this
        .encryption
        .aes_decrypt(hex.decode(data['donneesSec']['donnees']['cle']));

    var key = md5.convert(_enBytes(utf8.decode(work)));
    this.encryption.aes_key = key;
  }

  get_root_address(addr) {
    return [
      (addr.split('/').sublist(0, addr.split('/').length - 1).join("/")),
      (addr
          .split('/')
          .sublist(addr.split('/').length - 1, addr.split('/').length)
          .join("/"))
    ];
  }

  _enBytes(String string) {
    List list_string = string.split(',');
    return Uint8List.fromList(list_string);
  }
}

_prepare_onglets(var list_of_onglets) {
  List output = List();
  if (list_of_onglets.runtimeType != List) {
    return [list_of_onglets];
  }
  list_of_onglets.forEach((item) {
    if (item.runtimeType == Map) {
      item = item.values();
    }
    output.add(item);
  });
  return output;
}

class _Encryption {
  var aes_iv;

  var aes_iv_temp;

  var aes_key;

  Map rsa_keys;

  _Encryption() {
    List<int> list = List();
    for (var i = 0; i < 16; i++) {
      var rng = new Random();
      list.add(rng.nextInt(255));
    }
    this.aes_iv = Int16List(16);

    this.aes_iv_temp = Uint8List.fromList(list);
    this.aes_key = generateMd5("");

    this.rsa_keys = {};
  }
  String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
  aes_encrypt(List<int> data) {
    this.aes_key = generateMd5("");
print(base64.encode(this.aes_iv));
  var aesEncrypter =  AesCrypt(key: this.aes_key,padding: PaddingAES.pkcs7, mode: ModeAES.cbc ); //generate AES CBC block encrypter with key and PKCS7 padding
String encrypted = aesEncrypter.encrypt(data.toString(),iv: base64.encode(this.aes_iv));
 // print(base64.decode(encrypted));
    return base64.decode(encrypted);
  }

  aes_decrypt(var data) {
     var aesEncrypter =  AesCrypt(key: this.aes_key, mode: ModeAES.cbc ); //generate AES CBC block encrypter with key and PKCS7 padding

    try {
      return aesEncrypter.decrypt(data, iv: this.aes_iv);
    } catch (e) {
      print("Error during decryption : $e");
    }
  }

  aes_set_iv(var iv) {
    if (iv == null) {
      this.aes_iv = IV.fromLength(16);
    } else {
      this.aes_iv = iv;
    }
  }

  rsa_encrypt(var data) async {
    //print(this.rsa_keys['MR']);
    //print(this.rsa_keys['ER']);

    var modulusBytes = this.rsa_keys['MR'];
    var modulus =
        BigInt.parse(hex.encode(utf8.encode(modulusBytes)), radix: 16);
    var exponent =
        BigInt.parse(hex.encode(utf8.encode(this.rsa_keys['ER'])), radix: 16);
    var engine = RSAEngine()
      ..init(
        true,
        PublicKeyParameter<RSAPublicKey>(RSAPublicKey(modulus, exponent)),
      );

    //PKCS1.5 padding
    var k = modulusBytes.length;
    var plainBytes = data;
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

    return engine.process(eb);
  }

  _prepare_onglets(list_of_onglets) {
    var output = [];

    if (list_of_onglets.runtimeType != List) {
      return list_of_onglets;
    }

    for (var item in list_of_onglets) {
      if (item.runtimeType == Map) {
        item = item.values();

        return _prepare_onglets(item);
      }
    }
  }
}

Uint8List int32BigEndianBytes(int value) =>
    Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);
