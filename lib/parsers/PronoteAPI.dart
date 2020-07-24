import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
import 'package:ynotes/apiManager.dart' as localapi;
import 'package:ynotes/parsers/PronoteCas.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:http/http.dart';
import '../apiManager.dart';
import '../apiManager.dart';
import 'EcoleDirecte.dart';

Map error_messages = {22: '[ERROR 22] The object was from a previous session. Please read the "Long Term Usage" section in README on github.', 10: '[ERROR 10] Session has expired and pronotepy was not able to reinitialise the connection.'};
bool isOldAPIUsed = false;

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

  var periods_;

  bool _expired;

  var auth_response;

  bool logged_in;

  var auth_cookie;
  refresh() async {
    print("Reinitialisation");

    this.communication = _Communication(this.pronote_url, null, this);
    var future = await this.communication.initialise();
    this.attributes = future[0];
    this.func_options = future[1];
    this.encryption = _Encryption();
    this.encryption.aes_iv = this.communication.encryption.aes_iv;
    await this._login();
    this.periods_ = null;
    this.periods_ = this.periods();
    this.week = this._get_week(DateTime.now());
    this._expired = true;
  }

  _get_week(DateTime date) {
    try {
      var test = (1 + (date.difference(this.start_day).inDays / 7).floor()).round();
    } catch (e) {
      print(e.toString());
    }
    return (1 + (date.difference(this.start_day).inDays / 7).floor()).round();
  }

  Client(String pronote_url, {String username, String password, var cookies}) {
    if (cookies == null && password == null && username == null) {
      throw 'Please provide login credentials. Cookies are None, and username and password are empty.';
    }
    this.username = username;
    this.password = password;
    this.pronote_url = pronote_url;
    print("Initiate communication");

    this.communication = _Communication(pronote_url, cookies, this);
  }
  Future init() async {
    var attributesandfunctions = await this.communication.initialise();

    this.attributes = attributesandfunctions[0];
    this.func_options = attributesandfunctions[1];

    if (this.attributes["e"]!=null && this.attributes["f"]!=null) {
      print("LOGIN AS ENT");
      this.ent = true;
    } else {
      print("LOGIN AS REGULAR USER");
      this.ent = false;
    }
    //set up encryption
    this.encryption = _Encryption();
    this.encryption.aes_iv = this.communication.encryption.aes_iv;

    //some other attribute creation
    this._last_ping = DateTime.now().millisecondsSinceEpoch / 1000;
    this.auth_response = null;
    this.auth_cookie = null;
    this.date = DateTime.now();
    var inputFormat = DateFormat("dd/MM/yyyy");
    this.start_day = inputFormat.parse(this.func_options['donneesSec']['donnees']['General']['PremierLundi']['V']);
    this.week = this._get_week(DateTime.now());

    this.periods_ = this.periods;
    this.logged_in = await this._login();
    this._expired = false;
  }

  _login() async {
    if (this.ent != null && this.ent) {
      this.username = this.attributes['e'];
      this.password = this.attributes['f'];
    }
    try {
      final storage = new FlutterSecureStorage();
      await storage.write(key: "username", value: this.username);
      await storage.write(key: "password", value: this.password);
      await storage.write(key: "pronoteurl", value: this.pronote_url);
      print("Saved credentials");
    } catch (e) {
      print("failed to write values");
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
    var idr = await this.communication.post("Identification", data: {'donnees': ident_json});
    print("Identification");

    var challenge = idr['donneesSec']['donnees']['challenge'];
    var e = _Encryption();
    e.aes_set_iv(this.communication.encryption.aes_iv);
    var motdepasse;

    if (this.ent != null && this.ent == true) {
      List<int> encoded = utf8.encode(this.password);
      motdepasse = sha256.convert(encoded);
      motdepasse = hex.encode(motdepasse);
      motdepasse = motdepasse.toString().toUpperCase();
      e.aes_key = md5.convert(utf8.encode(motdepasse));
    } else {
      var u = this.username;
      var p = this.password;
      if (idr['donneesSec']['donnees']['modeCompLog'] != null) {
        u = u.toString().toLowerCase();
      }

      if (idr['donneesSec']['donnees']['modeCompMdp'] != null) {
        p = p.toString().toLowerCase();
      }

      var alea = idr['donneesSec']['donnees']['alea'];
      List<int> encoded = utf8.encode(alea + p);
      motdepasse = sha256.convert(encoded);
      motdepasse = hex.encode(motdepasse.bytes);
      motdepasse = motdepasse.toString().toUpperCase();
      e.aes_key = md5.convert(utf8.encode(u + motdepasse));
    }

    var dec = e.aes_decrypt(hex.decode(challenge));

    var dec_no_alea = _enleverAlea(dec);
    var ch = e.aes_encrypt(utf8.encode(dec_no_alea));

    Map auth_json = {"connexion": 0, "challenge": ch, "espace": int.parse(this.attributes['a'])};
    try {
      print("Authentification");
      this.auth_response = await this.communication.post("Authentification", data: {'donnees': auth_json, 'identifiantNav': ''});
    } catch (e) {
      throw ("Error during auth" + e.toString());
    }

    try {
      if (this.auth_response['donneesSec']['donnees'].toString().contains("cle")) {
        await this.communication.after_auth(this.communication.last_response, this.auth_response, e.aes_key);
        this.encryption.aes_key = e.aes_key;
        if (isOldAPIUsed == false) {
          try {
            var paramsUser = await this.communication.post("ParametresUtilisateur", data: {'donnees': {}});

            this.communication.authorized_onglets = _prepare_onglets(paramsUser['donneesSec']['donnees']['listeOnglets']);
            try {
              CreateStorage("classe", paramsUser['donneesSec']['donnees']['ressource']["classeDEleve"]["L"]);
              CreateStorage("userFullName", paramsUser['donneesSec']['donnees']['ressource']["L"]);
            } catch (e) {
              print("Failed to register UserInfos");
              print(e);
            }
          } catch (e) {
            print("Surely using OLD API");
          }
        }

        print("Successfully logged in as ${this.username}");
        return true;
      } else {
        print("login failed");
        return false;
      }
    } catch (e) {
      throw ("Error during after auth " + e.toString());
    }
  }

  keep_alive() {
    return KeepAlive();
  }

  homework(DateTime date_from, {DateTime date_to}) async {
    print(date_from);
    if (date_to == null) {
      final f = new DateFormat('dd/MM/yyyy');
      date_to = f.parse(this.func_options['donneesSec']['donnees']['General']['DerniereDate']['V']);
    }
    var json_data = {
      'donnees': {
        'domaine': {'_T': 8, 'V': "[${this._get_week(date_from)}..${this._get_week(date_to)}]"}
      },
      '_Signature_': {'onglet': 88}
    };

    var response = await this.communication.post("PageCahierDeTexte", data: json_data);
    var h_list = response['donneesSec']['donnees']['ListeTravauxAFaire']['V'];
    List<localapi.homework> listHW = List();
    h_list.forEach((h) {
      listHW.add(localapi.homework(
          h["Matiere"]["V"]["L"], h["Matiere"]["V"]["N"], h["N"], h["descriptif"]["V"], null, DateFormat("dd/MM/yyyy").parse(h["PourLe"]["V"]), DateFormat("dd/MM/yyyy").parse(h["DonneLe"]["V"]), h["TAFFait"], false, false, null, null, ""));
    });
    return listHW;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  periods() {
    print("GETTING PERIODS");
    //printWrapped(this.func_options['donneesSec']['donnees'].toString());

    var json;
    try {
      json = this.func_options['donneesSec']['donnees']['General']['ListePeriodes'];
    } catch (e) {
      print(e);
    }

    List toReturn = List();
    json.forEach((j) {
      toReturn.add(Period(this, j));
    });
    return toReturn;
  }
}

_enleverAlea(String text) {
  List sansalea = List();
  int i = 0;
  text.runes.forEach((int rune) {
    var character = new String.fromCharCode(rune);
    if (i % 2 == 0) {
      sansalea.add(character);
    }
    i++;
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
  Requests session;
  var requests;

  _Communication(String site, var cookies, var client) {
    this.root_site = this.get_root_address(site)[0];
    this.html_page = this.get_root_address(site)[1];

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
    //some headers to be real
    var headers = {'connection': 'keep-alive', 'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0'};

    // get rsa keys and session id
    String hostName = Requests.getHostname(this.root_site + "/" + this.html_page);
    //set the cookies for ENT
    if (cookies != null) {
      print("Cookies set");
      Requests.setStoredCookies(hostName, this.cookies);
    }
    var get_response = await Requests.get(this.root_site + "/" + this.html_page, headers: headers);
    if (get_response.hasError) {
      print("|pImpossible de se connecter à l'adresse fournie");
    }

    this.attributes = this._parse_html(get_response.content());

    //uuid
    this.encryption.rsa_keys = {'MR': this.attributes['MR'], 'ER': this.attributes['ER']};

    var uuid = base64.encode(await this.encryption.rsa_encrypt(this.encryption.aes_iv_temp));
    //uuid
    var json_post = {'Uuid': uuid};
    this.encrypt_requests = (this.attributes["sCra"] != null ? !this.attributes["sCra"] : false);
    this.compress_requests = (this.attributes["sCra"] != null ? !this.attributes["sCoA"] : false);
    var initial_response = await this.post('FonctionParametres', data: {'donnees': json_post}, decryption_change: {'iv': md5.convert(this.encryption.aes_iv_temp).toString()});

    return [this.attributes, initial_response];
  }

  _parse_html(String html) {
    var parsed = parse(html);
    var onload = parsed.getElementById("id_body");

    String onload_c;
    print(onload);
    if (onload != null) {
      onload_c = onload.attributes["onload"].substring(14, onload.attributes["onload"].length - 37);
    } else {
      if (html.contains("IP")) {
        throw ('Your IP address is suspended.');
      } else {
        throw ("Error with HTML PAGE");
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

  post(String function_name, {var data, bool recursive = false, var decryption_change = null}) async {
    if (data != null) {
      if (data["_Signature_"] != null && !this.authorized_onglets.toString().contains(data['_Signature_']['onglet'].toString())) {
        print(data['_Signature_']['onglet']);
        print(this.authorized_onglets.toString());
        throw ('Action not permitted. (onglet is not normally accessible)');
      }
    }
    if (this.compress_requests) {
      print("Compress request");
      data = utf8.encode(jsonEncode(data.toString()));
      data = hex.encode(data);
      var zlibInstance = ZLibCodec(level: 6);
      data = zlibInstance.encode(data).sublist(2, data.length - 4);
    }
    print(data);
    if (this.encrypt_requests) {
      print("Encrypt requests");
      if (data.runtimeType == Map) {
        data = utf8.encode(data.toString());
      }
      data = encryption.aes_encrypt(data).toUpperCase();
    }

    var r_number = encryption.aes_encrypt(utf8.encode(this.request_number.toString()));

    var json = {'session': int.parse(this.attributes['h']), 'numeroOrdre': r_number, 'nom': function_name, 'donneesSec': data};
    String p_site = this.root_site + '/appelfonction/' + this.attributes['a'] + '/' + this.attributes['h'] + '/' + r_number;

    this.request_number += 2;

    var response = await Requests.post(p_site, json: json).catchError((onError) {
      print("Error occured during request : $onError");
    });

    this.last_ping = (DateTime.now().millisecondsSinceEpoch / 1000);
    this.last_response = response;
    if (response.hasError) {
      throw "Status code: ${response.statusCode}";
    }
    if (response.content().contains("Erreur")) {
      print("Error occured");
      var r_json = response.json();
      if (r_json["Erreur"]['G'] == 22) {
        throw error_messages["22"];
      }

      if (recursive != null && recursive) {
        throw "Unknown error from pronote: ${r_json["Erreur"]["G"]} | ${r_json["Erreur"]["Titre"]}\n$r_json";
      }

      //await this.client.refresh();

      return await this.client.communication.post(function_name, data: data, recursive: true);
    }

    if (decryption_change != null) {
      print("decryption change");
      if (decryption_change.toString().contains("iv")) {
        print("decryption_change contains IV");
        print(decryption_change['iv']);
        this.encryption.aes_iv = IV.fromBase16(decryption_change['iv']);
      }

      if (decryption_change.toString().contains("key")) {
        print("decryption_change contains key");
        print(decryption_change['key']);
        this.encryption.aes_key = decryption_change['key'];
      }
    }

    Map response_data = response.json();

    if (this.encrypt_requests) {
      response_data['donneesSec'] = this.encryption.aes_decrypt(hex.decode(response_data['donneesSec']));
      print("décrypté données sec");
    }
    var zlibInstanceDecode = ZLibCodec(windowBits: 15);
    if (this.compress_requests) {
      response_data['donneesSec'] = zlibInstanceDecode.decode(response_data['donneesSec']);
    }
    if (response_data['donneesSec'].runtimeType == String) {
      print("was string");
      try {
        response_data['donneesSec'] = jsonDecode(response_data['donneesSec']);
      } catch (e) {
        throw "JSONDecodeError";
      }
    }
    return response_data;
  }

  after_auth(var auth_response, var data, var auth_key) async {
    this.encryption.aes_key = auth_key;
    if (this.cookies == null) {
      var host = Requests.getHostname(auth_response.url.toString());
      this.cookies = await Requests.getStoredCookies(host);
    }

    var work = this.encryption.aes_decrypt(hex.decode(data['donneesSec']['donnees']['cle']));
    try {
      this.authorized_onglets = _prepare_onglets(data['donneesSec']['donnees']['listeOnglets']);

      CreateStorage("classe", data['donneesSec']['donnees']['ressource']["classeDEleve"]["L"]);
      CreateStorage("userFullName", data['donneesSec']['donnees']['ressource']["L"]);
      isOldAPIUsed = true;
    } catch (e) {
      isOldAPIUsed = false;
      print("Surely using the 2020 API");
    }
    var key = md5.convert(_enBytes(work));
    print("New key : $key");
    this.encryption.aes_key = key;
  }

  get_root_address(addr) {
    return [(addr.split('/').sublist(0, addr.split('/').length - 1).join("/")), (addr.split('/').sublist(addr.split('/').length - 1, addr.split('/').length).join("/"))];
  }

  _enBytes(String string) {
    List<String> list_string = string.split(',');
    List<int> ints = list_string.map(int.parse).toList();
    return ints;
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
    this.aes_iv = IV.fromBase16("00000000000000000000000000000000");

    this.aes_iv_temp = Uint8List.fromList(list);
    this.aes_key = md5.convert(utf8.encode("")).toString();

    this.rsa_keys = {};
  }
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  aes_encrypt(List<int> data) {
    var data2 = utf8.decode(data);
    var key = Key.fromBase16(this.aes_key.toString());
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));

    final encrypted = encrypter.encrypt(data2.toString(), iv: this.aes_iv).base16;

    return (encrypted);
  }

  aes_decrypt(var data) {
    var key = Key.fromBase16(this.aes_key.toString());
    print(key.base64);
    final aesEncrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    //generate AES CBC block encrypter with key and PKCS7 padding

    try {
      return aesEncrypter.decrypt64(base64.encode(data), iv: this.aes_iv);
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
    var modulusBytes = this.rsa_keys['MR'];
    var modulus = BigInt.parse(modulusBytes, radix: 16);
    var exponent = BigInt.parse(this.rsa_keys['ER'], radix: 16);
    var cipher = PKCS1Encoding(RSAEngine());
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(RSAPublicKey(modulus, exponent)));
    Uint8List output1 = cipher.process(aes_iv_temp);

    return output1;
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

class KeepAlive {
  _Communication _connection;

  bool keep_alive;

  void init(Client client) {
    this._connection = client.communication;
    this.keep_alive = true;
  }

  void alive() async {
    while (this.keep_alive) {
      if (DateTime.now().millisecondsSinceEpoch / 1000 - this._connection.last_ping >= 300) {
        this._connection.post("Presence", data: {
          '_Signature_': {'onglet': 7}
        });
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

Uint8List int32BigEndianBytes(int value) => Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);

class Period {
  DateTime end;

  DateTime start;

  var name;

  var id;

  var moyenneGenerale;
  var moyenneGeneraleClasse;

  Client _client;

  // Represents a period of the school year. You shouldn't have to create this class manually.

  // Attributes
  // ----------
  // id : str
  //     the id of the period (used internally)
  // name : str
  //     name of the period
  // start : str
  //     date on which the period starts
  // end : str
  //     date on which the period ends

  Period(Client client, Map parsed_json) {
    this._client = client;
    this.id = parsed_json['N'];
    this.name = parsed_json['L'];
    var inputFormat = DateFormat("dd/MM/yyyy");
    this.start = inputFormat.parse(parsed_json['dateDebut']['V']);
    this.end = inputFormat.parse(parsed_json['dateFin']['V']);
  }
  gradeTranslate(String value) {
    List grade_translate = ['Absent', 'Dispense', 'NonNote', 'Inapte', 'NonRendu', 'AbsentZero', 'NonRenduZero', 'Felicitations'];
    if (value.contains("|")) {
      return grade_translate[int.parse(value[1])];
    } else {
      return value;
    }
  }

  average(var json, var codeMatiere) {
    //The services for the period
    List services = json['donneesSec']['donnees']['listeServices']['V'];
    //The average data for the given matiere
    var averageData = services.firstWhere((element) => element["N"] == codeMatiere);
    //print(averageData["moyEleve"]["V"]);
    //Return the eleve average, the max average, and the class average
    return [averageData["moyEleve"]["V"], averageData["moyMax"]["V"], averageData["moyClasse"]["V"]];
  }

  grades(int codePeriode) async {
    //Get grades from the period.
    List<grade> list = List();
    var json_data = {
      'donnees': {
        'Periode': {'N': this.id, 'L': this.name}
      },
      "_Signature_": {"onglet": 198}
    };
    var response = await _client.communication.post('DernieresNotes', data: json_data);
    var grades = response['donneesSec']['donnees']['listeDevoirs']['V'];
    this.moyenneGenerale = response['donneesSec']['donnees']['moyGenerale']['V'];
    this.moyenneGeneraleClasse = response['donneesSec']['donnees']['moyGeneraleClasse']['V'];
    printWrapped(response['donneesSec']['donnees'].toString());
    var other = List();
    grades.forEach((element) async {
      list.add(grade(
          valeur: this.gradeTranslate(element["note"]["V"]),
          devoir: element["commentaire"],
          codePeriode: "A00" + codePeriode.toString(),
          codeMatiere: element["service"]["V"]["N"],
          codeSousMatiere: null,
          libelleMatiere: element["service"]["V"]["L"],
          letters: element["note"]["V"].contains("|"),
          coef: element["coefficient"].toString(),
          noteSur: element["bareme"]["V"],
          moyenneClasse: average(response, element["service"]["V"]["N"])[2],
          date: element["date"]["V"],
          nonSignificatif: this.gradeTranslate(element["note"]["V"]) == "NonNote" ? true : false,
          typeDevoir: "Interrogation",
          dateSaisie: element["date"]["V"]));
      other.add(average(response, element["service"]["V"]["N"]));
    });
    return [list, other];
  }
}
