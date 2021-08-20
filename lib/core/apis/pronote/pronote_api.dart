import 'dart:convert' as conv;
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart' as conv;
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/pkcs1.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:requests/requests.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/shared/login_controller.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/null_safe_map_getter.dart';
import 'package:ynotes/core/utils/secure_storage.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/tests.dart';

import '../ecole_directe.dart';
import '../utils.dart';

Map errorMessages = {
  22: '[ERROR 22] The object was from a previous session. Please read the "Long Term Usage" section in README on github.',
  10: '[ERROR 10] Session has expired and pronotepy was not able to reinitialise the connection.'
};
bool isOldAPIUsed = false;

Uint8List int32BigEndianBytes(int value) => Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);

//Remove some random security in challenge
prepareTabs(var tabsList) {
  List output = [];
  if (tabsList.runtimeType != List) {
    return [tabsList];
  }
  tabsList.forEach((item) {
    if (item.runtimeType == Map) {
      item = item.values();
    }
    output.add(item);
  });
  return output;
}

removeAlea(String text) {
  List sansalea = [];
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

///Communication class used to send requests to Pronote
class Communication {
  var cookies;
  late PronoteClient client;
  var htmlPage;
  var rootSite;
  late Encryption encryption;
  Map? attributes;
  late int requestNumber;
  List? authorizedTabs;
  late bool shouldCompressRequests;
  late double lastPing;
  late bool shouldEncryptRequests;
  var lastResponse;
  Requests? session;
  var requests;

  Communication(String site, var cookies, var client) {
    this.rootSite = this.getRootAdress(site)[0];
    this.htmlPage = this.getRootAdress(site)[1];

    this.encryption = Encryption();
    this.attributes = {};
    this.requestNumber = 1;
    this.cookies = cookies;
    this.lastPing = 0;
    this.authorizedTabs = [];
    this.client = client;
    this.shouldCompressRequests = false;
    this.shouldEncryptRequests = false;
    this.lastResponse = null;
  }

  afterAuth(var authentificationResponse, var data, var authentificationKey) async {
    this.encryption.aesKey = authentificationKey;
    if (this.cookies == null) {
      var host = Requests.getHostname(authentificationResponse.url.toString());
      this.cookies = await Requests.getStoredCookies(host);
    }
    var work = this.encryption.aesDecrypt(conv.hex.decode(data['donneesSec']['donnees']['cle']));
    try {
      this.authorizedTabs = prepareTabs(data['donneesSec']['donnees']['listeOnglets']);

      createStorage("classe", data['donneesSec']['donnees']['ressource']["classeDEleve"]["L"]);
      createStorage("userFullName", data['donneesSec']['donnees']['ressource']["L"]);
      isOldAPIUsed = true;
    } catch (e) {
      isOldAPIUsed = false;
      this.client.stepsLogger.add("ⓘ 2020 API");
      CustomLogger.log("PRONOTE", "Surely using the 2020 API");
    }
    var key = md5.convert(toBytes(work));
    CustomLogger.log("PRONOTE", "New key : $key");
    this.encryption.aesKey = key;
  }

  getRootAdress(addr) {
    return [
      (addr.split('/').sublist(0, addr.split('/').length - 1).join("/")),
      (addr.split('/').sublist(addr.split('/').length - 1, addr.split('/').length).join("/"))
    ];
  }

  Future<List<Object?>> initialise() async {
    CustomLogger.log("PRONOTE", "Getting hostname");
    // get rsa keys and session id
    String hostName = Requests.getHostname(this.rootSite + "/" + this.htmlPage);

    //set the cookies for ENT
    if (cookies != null) {
      CustomLogger.log("PRONOTE", "Cookies set");
      Requests.setStoredCookies(hostName, this.cookies);
    }

    var headers = {
      'connection': 'keep-alive',
      'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/74.0'
    };

    String url = this.rootSite +
        "/" +
        (this.cookies != null ? "?fd=1" : this.htmlPage) +
        (((this.client.mobileLogin ?? false) || (this.client.qrCodeLogin ?? false))
            ? "?fd=1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335"
            : "");
    if (url.contains("?login=true") || url.contains("?fd=1")) {
      url += "&fd=1";
    } else {
      url += "?fd=1";
    }
    CustomLogger.log("PRONOTE", "Url is $url");
    this.client.stepsLogger.add("ⓘ" + " Used url is " + "`" + url + "`");
    CustomLogger.log("PRONOTE", (this.client.mobileLogin ?? false) ? "CAS" : "NOT CAS");
//?fd=1 bypass the old navigator issue
    var getResponse = await Requests.get(url, headers: headers).catchError((e) {
      this.client.stepsLogger.add("❌ Failed login request " + e.toString());
      throw ("Failed login request");
    });
    this.client.stepsLogger.add("✅ Posted login request");

    if (getResponse.hasError) {
      CustomLogger.log("PRONOTE", "|pImpossible de se connecter à l'adresse fournie");
    }

    this.attributes = this.parseHtml(getResponse.content());
    this.client.stepsLogger.add("✅ Parsed HTML");
    //uuid
    this.encryption.rsaKeys = {'MR': this.attributes!['MR'], 'ER': this.attributes!['ER']};
    var uuid = conv.base64.encode(await this.encryption.rsaEncrypt(this.encryption.aesIVTemp.bytes));
    this.client.stepsLogger.add("✅ Encrypted IV");

    //uuid
    var jsonPost = {'Uuid': uuid, 'identifiantNav': null};
    this.shouldEncryptRequests = (this.attributes!["sCrA"] == null);
    if (this.attributes!["sCrA"] == null) {
      this.client.stepsLogger.add("ⓘ" + " Requests will be encrypted");
    }
    this.shouldCompressRequests = (this.attributes!["sCoA"] == null);
    if (this.attributes!["sCoA"] == null) {
      this.client.stepsLogger.add("ⓘ" + " Requests will be compressed");
    }
    var initialResponse = await this.post('FonctionParametres',
        data: {'donnees': jsonPost},
        decryptionChange: {'iv': conv.hex.encode(md5.convert(this.encryption.aesIVTemp.bytes).bytes)});

    return [this.attributes, initialResponse];
  }

  parseHtml(String html) {
    var parsed = parse(html);
    var onload = parsed.getElementById("id_body");

    String onloadC;
    CustomLogger.log("PRONOTE", onload.toString());
    if (onload != null) {
      onloadC = onload.attributes["onload"]!.substring(14, onload.attributes["onload"]!.length - 37);
    } else {
      if (html.contains("IP")) {
        throw ('Your IP address is suspended.');
      } else {
        this.client.stepsLogger.add("❌ Failed to parse HTML");
        throw ("Error with HTML PAGE");
      }
    }
    Map attributes = {};

    onloadC.split(',').forEach((attr) {
      var key = attr.split(':')[0];
      var value = attr.split(':')[1];
      attributes[key] = value.toString().replaceAll("'", "");
    });
    return attributes;
  }

  post(String functionName, {var data, bool recursive = false, var decryptionChange}) async {
    this.client.stepsLogger.add("✅ Posting " + functionName);
    if (data != null) {
      if (data["_Signature_"] != null &&
          !this.authorizedTabs.toString().contains(data['_Signature_']['onglet'].toString())) {
        throw ('Action not permitted. (onglet is not normally accessible)');
      }
    }

    if (this.shouldCompressRequests) {
      CustomLogger.log("PRONOTE", "Compress request");
      data = conv.jsonEncode(data);

      CustomLogger.log("PRONOTE", data);
      var zlibInstance = ZLibCodec(level: 6, raw: true);
      data = zlibInstance.encode(conv.utf8.encode(conv.hex.encode(conv.utf8.encode(data))));
      this.client.stepsLogger.add("✅ Compressed request");
    }
    if (this.shouldEncryptRequests) {
      CustomLogger.log("PRONOTE", "Encrypt requests");
      data = encryption.aesEncrypt(data);
      this.client.stepsLogger.add("✅ Encrypted request");
    }
    var rNumber = encryption.aesEncrypt(conv.utf8.encode(this.requestNumber.toString()));

    var json = {
      'session': int.parse(this.attributes!['h']),
      'numeroOrdre': rNumber,
      'nom': functionName,
      'donneesSec': data
    };
    String pSite =
        this.rootSite + '/appelfonction/' + this.attributes!['a'] + '/' + this.attributes!['h'] + '/' + rNumber;
    CustomLogger.log("PRONOTE", pSite);

    this.requestNumber += 2;
    CustomLogger.log("PRONOTE", json.toString());
    var response = await Requests.post(pSite, json: json).catchError((onError) {
      CustomLogger.log("PRONOTE", "Error occured during request : $onError");
    });

    this.lastPing = (DateTime.now().millisecondsSinceEpoch / 1000);
    this.lastResponse = response;
    if (response.hasError) {
      throw "Status code: ${response.statusCode}";
    }
    if (response.content().contains("Erreur")) {
      CustomLogger.log("PRONOTE", "Error occured");
      CustomLogger.log("PRONOTE", response.content());
      var responseJson = response.json();

      if (responseJson["Erreur"]['G'] == 22) {
        throw errorMessages["22"];
      }
      if (responseJson["Erreur"]['G'] == 10) {
        appSys.loginController.details = "Connexion expirée";
        appSys.loginController.actualState = loginStatus.error;

        throw errorMessages["10"];
      }

      if (recursive) {
        throw "Unknown error from pronote: ${responseJson["Erreur"]["G"]} | ${responseJson["Erreur"]["Titre"]}\n$responseJson";
      }

      return await this.client.communication?.post(functionName, data: data, recursive: true);
    }

    if (decryptionChange != null) {
      CustomLogger.log("PRONOTE", "decryption change");
      if (decryptionChange.toString().contains("iv")) {
        CustomLogger.log("PRONOTE", "decryption_change contains IV");
        CustomLogger.log("PRONOTE", decryptionChange['iv']);
        this.encryption.aesIV = IV.fromBase16(decryptionChange['iv']);
      }

      if (decryptionChange.toString().contains("key")) {
        CustomLogger.log("PRONOTE", "decryption_change contains key");
        CustomLogger.log("PRONOTE", decryptionChange['key']);
        this.encryption.aesKey = decryptionChange['key'];
      }
    }

    Map responseData = response.json();

    if (this.shouldEncryptRequests) {
      responseData['donneesSec'] = this.encryption.aesDecryptAsBytes(conv.hex.decode(responseData['donneesSec']));
      CustomLogger.log("PRONOTE", "décrypté données sec");
      this.client.stepsLogger.add("✅ Decrypted response");
    }
    var zlibInstanceDecoder = ZLibDecoder(raw: true);
    if (this.shouldCompressRequests) {
      var toDecode = responseData['donneesSec'];
      responseData['donneesSec'] = conv.utf8.decode(zlibInstanceDecoder.convert(toDecode));
      this.client.stepsLogger.add("✅ Decompressed response");
    }
    if (responseData['donneesSec'].runtimeType == String) {
      try {
        responseData['donneesSec'] = conv.jsonDecode(responseData['donneesSec']);
      } catch (e) {
        throw "JSONDecodeError";
      }
    }
    return responseData;
  }

  toBytes(String string) {
    List<String> stringsList = string.split(',');
    List<int> ints = stringsList.map(int.parse).toList();
    return ints;
  }
}

class Encryption {
  IV? aesIV;

  late IV aesIVTemp;

  var aesKey;

  late Map rsaKeys;

  Encryption() {
    this.aesIV = IV.fromLength(16);
    this.aesIVTemp = IV.fromSecureRandom(16);
    this.aesKey = generateMd5("");

    this.rsaKeys = {};
  }
  aesDecrypt(var data) {
    var key = Key.fromBase16(this.aesKey.toString());
    final aesEncrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    //generate AES CBC block encrypter with key and PKCS7 padding

    CustomLogger.log("PRONOTE", this.aesIV?.base16.toString() ?? "");

    try {
      return aesEncrypter.decrypt64(conv.base64.encode(data), iv: this.aesIV);
    } catch (e) {
      throw ("Error during decryption : $e");
    }
  }

  aesDecryptAsBytes(List<int> data) {
    var key = Key.fromBase16(this.aesKey.toString());
    final aesEncrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    //generate AES CBC block encrypter with key and PKCS7 padding

    CustomLogger.log("PRONOTE", this.aesIV.toString());

    try {
      return aesEncrypter.decryptBytes(Encrypted.from64(conv.base64.encode(data)), iv: this.aesIV);
    } catch (e) {
      throw ("Error during decryption : $e");
    }
  }

  aesEncrypt(List<int> data, {padding = true, disableIV = false}) {
    try {
      var iv;
      var key = Key.fromBase16(this.aesKey.toString());
      CustomLogger.log("PRONOTE", "KEY :" + this.aesKey.toString());
      iv = this.aesIV;
      CustomLogger.log("PRONOTE", iv.base16);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: padding ? "PKCS7" : null));
      final encrypted = encrypter.encryptBytes(data, iv: iv).base16;

      return (encrypted);
    } catch (e) {
      throw "Error during aes encryption " + e.toString();
    }
  }

  aesEncryptFromString(String data) {
    var key = Key.fromBase16(this.aesKey.toString());
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    final encrypted = encrypter.encrypt(data, iv: this.aesIV).base16;

    return (encrypted);
  }

  aesSetIV(var iv) {
    if (iv == null) {
      this.aesIV = IV.fromLength(16);
    } else {
      this.aesIV = iv;
    }
  }

  String generateMd5(String input) {
    return md5.convert(conv.utf8.encode(input)).toString();
  }

  rsaEncrypt(Uint8List data) async {
    try {
      CustomLogger.log("PRONOTE", this.rsaKeys.toString());
      String? modulusBytes = this.rsaKeys['MR'];

      var modulus = BigInt.parse(modulusBytes!, radix: 16);

      var exponent = BigInt.parse(this.rsaKeys['ER']!, radix: 16);

      var cipher = PKCS1Encoding(RSAEngine());
      cipher.init(true, PublicKeyParameter<RSAPublicKey>(RSAPublicKey(modulus, exponent)));
      Uint8List output1 = cipher.process(data);

      return output1;
    } catch (e) {
      throw ("Error while RSA encrypting " + e.toString());
    }
  }
}

class KeepAlive {
  Communication? _connection;

  late bool keepAlive;

  void alive() async {
    while (this.keepAlive) {
      if (DateTime.now().millisecondsSinceEpoch / 1000 - this._connection!.lastPing >= 300) {
        this._connection!.post("Presence", data: {
          '_Signature_': {'onglet': 7}
        });
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void init(PronoteClient client) {
    this._connection = client.communication;
    this.keepAlive = true;
  }
}

class PronoteClient {
  var username;
  var password;
  var pronoteUrl;
  Communication? communication;
  var attributes;
  var funcOptions;
  PronoteUtils utils = PronoteUtils();
  bool? ent;

  late Encryption encryption;

  double? lastPing;

  DateTime? date;

  DateTime? startDay;

  var week;

  var localPeriods;

  bool? expired;

  var authResponse;

  bool? loggedIn;

  var authCookie;
  Map? paramsUser;

  late DateTime hourEnd;

  late DateTime hourStart;

  int? oneHourDuration;

  List<String> stepsLogger = [];
  bool? mobileLogin;
  bool? qrCodeLogin;

  PronoteClient(String pronoteUrl,
      {String? username, String? password, var cookies, bool? mobileLogin, bool? qrCodeLogin}) {
    this.username = username ?? "";
    this.password = password ?? "";
    this.pronoteUrl = pronoteUrl;
    this.mobileLogin = mobileLogin;
    this.qrCodeLogin = qrCodeLogin;
    CustomLogger.log("PRONOTE", "Initiate communication");

    this.communication = Communication(pronoteUrl, cookies, this);
  }

  downloadUrl(Document document) {
    try {
      Map data = {"N": document.id, "G": int.parse(document.type!)};
      //Used by pronote to encrypt the data (I don't know why)
      var magicStuff = this.encryption.aesEncrypt(conv.utf8.encode(conv.jsonEncode(data)));
      String libelle = document.documentName ?? "";
      String? url = this.communication!.rootSite +
          '/FichiersExternes/' +
          magicStuff +
          '/' +
          libelle +
          '?Session=' +
          this.attributes['h'].toString();
      if (url != null) CustomLogger.log("PRONOTE", url);
      return url;
    } catch (e) {
      CustomLogger.error(e);
    }
  }

  Future<bool?> init() async {
    if (!Platform.isLinux) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      this.stepsLogger.add("ⓘ " +
          DateFormat("dd/MM/yyyy hh:mm:ss").format(DateTime.now()) +
          " Started login - yNotes version is : " +
          packageInfo.version +
          "+" +
          packageInfo.buildNumber +
          " T" +
          Tests.testVersion);
    }
    var attributesandfunctions = await this.communication!.initialise();
    this.stepsLogger.add("✅ Initialized");

    this.attributes = attributesandfunctions[0];
    this.funcOptions = attributesandfunctions[1];

    if (this.attributes["e"] != null && this.attributes["f"] != null) {
      CustomLogger.log("PRONOTE", "LOGIN AS ENT");
      this.ent = true;
    } else {
      CustomLogger.log("PRONOTE", "LOGIN AS REGULAR USER");
      this.ent = false;
    }
    this.stepsLogger.add("✅ Login passed : using " + ((this.ent ?? false) ? "ent" : "direct") + "connection");
    //set up encryption
    this.encryption = Encryption();
    this.encryption.aesIV = this.communication!.encryption.aesIV;
    //some other attribute creation
    this.lastPing = DateTime.now().millisecondsSinceEpoch / 1000;
    this.authResponse = null;
    this.authCookie = null;
    this.date = DateTime.now();
    var inputFormat = DateFormat("dd/MM/yyyy");

    this.startDay = inputFormat.parse(this.funcOptions['donneesSec']['donnees']['General']['PremierLundi']['V']);

    final storage = new CustomSecureStorage();
    await storage.write(key: "startday", value: this.startDay.toString());
    this.week = await getWeek(DateTime.now());

    this.localPeriods = this.periods;
    this.stepsLogger.add("✅ Created attributes");

    this.loggedIn = await this._login();
    this.hourStart =
        DateFormat("hh'h'mm").parse(this.funcOptions['donneesSec']['donnees']['General']['ListeHeures']['V'][0]['L']);
    this.hourEnd = DateFormat("hh'h'mm")
        .parse(this.funcOptions['donneesSec']['donnees']['General']['ListeHeuresFin']['V'][0]['L']);

    this.oneHourDuration = hourEnd.difference(hourStart).inMinutes;
    this.expired = false;
    return loggedIn;
  }

  keepAlive() {
    return KeepAlive();
  }

  lessons(DateTime dateFrom, {DateTime? dateTo}) async {
    /* initializeDateFormatting();
    var user = this.paramsUser['donneesSec']['donnees']['ressource'];
    List<Lesson> listToReturn = [];
    //Set request
    Map data = {
      "_Signature_": {"onglet": 16},
      "donnees": {
        "ressource": user,
        "avecAbsencesEleve": false,
        "avecConseilDeClasse": true,
        "estEDTPermanence": false,
        "avecAbsencesRessource": true,
        "avecDisponibilites": true,
        "avecInfosPrefsGrille": true,
        "Ressource": user,
      }
    };

    var output = [];
    var firstWeek = await get_week(date_from);
    if (date_to == null) {
      date_to = date_from;
    }
    var lastWeek = await get_week(date_to);
    for (int week = firstWeek; lastWeek < lastWeek + 1; ++lastWeek) {
      data["donnees"]["NumeroSemaine"] = lastWeek;
      data["donnees"]["numeroSemaine"] = lastWeek;
      var response = await this.communication!.post('PageEmploiDuTemps', data: data);

      var lessonsList = response['donneesSec']['donnees']['ListeCours'];
      lessonsList.forEach((lesson) {
        try {
          listToReturn.add(PronoteConverter.lesson(this, lesson));
        } catch (e) {
          CustomLogger.error(e);
        }
      });
      CustomLogger.log("PRONOTE", "Agenda collecte succeeded");
      return listToReturn;
    }*/
  }

  List<PronotePeriod> periods() {
    CustomLogger.log("PRONOTE", "GETTING PERIODS");
    var json;
    try {
      json = this.funcOptions['donneesSec']['donnees']['General']['ListePeriodes'];
    } catch (e) {
      CustomLogger.log("PRONOTE", "ERROR WHILE PARSING JSON " + e.toString());
    }

    List<PronotePeriod> toReturn = [];
    json.forEach((j) {
      toReturn.add(PronotePeriod(this, j));
    });
    return toReturn;
  }

  refresh() async {
    CustomLogger.log("PRONOTE", "Reinitialisation");

    this.communication = Communication(this.pronoteUrl, null, this);
    var future = await this.communication!.initialise();

    this.attributes = future[0];
    this.funcOptions = future[1];
    this.encryption = Encryption();
    this.encryption.aesIV = this.communication!.encryption.aesIV;
    await this._login();
    this.localPeriods = null;
    this.localPeriods = this.periods();
    this.week = await getWeek(DateTime.now());

    this.hourStart = DateFormat("""'hh'h'mm'""")
        .parse(this.funcOptions['donneesSec']['donnees']['General']['ListeHeures']['V'][0]['L']);
    this.hourEnd = DateFormat("""'hh'h'mm'""")
        .parse(this.funcOptions['donneesSec']['donnees']['General']['ListeHeuresFin']['V'][0]['L']);

    this.oneHourDuration = hourEnd.difference(hourStart).inMinutes;
    CustomLogger.log("PRONOTE", "ohduration " + oneHourDuration.toString());

    this.expired = true;
  }

  setPollRead(String meta) async {
    var user = mapGet(paramsUser, ['donneesSec', 'donnees', 'ressource']);
    CustomLogger.log("PRONOTE", user);
    List metas = meta.split("/");
    Map data = {
      "_Signature_": {"onglet": 8},
      "donnees": {
        "listeActualites": [
          {
            "genrePublic": 4,
            "L": metas[1],
            "validationDirecte": true,
            "saisieActualite": false,
            "lue": (metas[2] == "true"),
            "marqueLueSeulement": false,
            "N": metas[0],
            "public": {"G": user["G"], "L": user["L"], "N": user["N"]}
          }
        ],
        "saisieActualite": false
      }
    };

    var response = await this.communication!.post('SaisieActualites', data: data);
    CustomLogger.log("PRONOTE", response);
  }

  setPollResponse(String meta) async {
    try {
      List metas = meta.split("/ynsplit");
      var user = mapGet(paramsUser, ['donneesSec', 'donnees', 'ressource']);
      Map mapData = conv.jsonDecode(metas[0]);
      Map pollMapData = conv.jsonDecode(metas[1]);
      String answer = metas[2];

      mapData["reponse"]["V"]["valeurReponse"]["V"] = "[$answer]";
      mapData["reponse"]["V"]["_validationSaisie"] = true;
      Map data = {
        "_Signature_": {"onglet": 8},
        "donnees": {
          "listeActualites": [
            {
              "E": 2,
              "N": pollMapData["N"],
              "L": pollMapData["L"],
              "validationDirecte": true,
              "saisieActualite": false,
              "supprimee": false,
              "lue": (pollMapData["lue"] == "true"),
              "genrePublic": 4,
              "public": {"G": user["G"], "L": user["L"], "N": user["N"]},
              "listeQuestions": [
                //adding data
                mapData
              ]
            },
          ],
          "saisieActualite": false
        }
      };
      var response = await this.communication!.post('SaisieActualites', data: data);
      CustomLogger.log("PRONOTE", response);
    } catch (e) {
      CustomLogger.error(e);
    }
  }

  _login() async {
    try {
      final storage = new FlutterSecureStorage();
      await storage.write(key: "username", value: this.username);
      if (mobileLogin == false && qrCodeLogin == false) {
        await storage.write(key: "password", value: this.password);
      }
      //In case password changed
      if ((mobileLogin == true || qrCodeLogin == true) && (await storage.read(key: "password")) != null) {
        password = await storage.read(key: "password");
      }
      await storage.write(key: "pronoteurl", value: this.pronoteUrl);
      await storage.write(
          key: "ispronotecas", value: ((this.mobileLogin ?? false) || (this.qrCodeLogin ?? false)).toString());

      CustomLogger.log("PRONOTE", "Saved credentials");
    } catch (e) {
      CustomLogger.log("PRONOTE", "failed to write values");
    }
    if (this.ent != null && this.ent!) {
      this.username = this.attributes['e'];
      this.password = this.attributes['f'];
    }
    Map indentJson = {
      "genreConnexion": 0,
      "genreEspace": int.parse(this.attributes['a']),
      "identifiant": this.username,
      "pourENT": this.ent,
      "enConnexionAuto": false,
      "demandeConnexionAuto": false,
      "enConnexionAppliMobile": (qrCodeLogin == false) ? this.mobileLogin : false,
      "demandeConnexionAppliMobile": qrCodeLogin,
      "demandeConnexionAppliMobileJeton": qrCodeLogin,
      "uuidAppliMobile": appSys.settings.system.uuid,
      "loginTokenSAV": ""
    };
    var idr = await this.communication!.post("Identification", data: {'donnees': indentJson});
    this.stepsLogger.add("✅ Posted identification successfully");

    CustomLogger.log("PRONOTE", "Identification");
    CustomLogger.log(
        "PRONOTE",
        "Using following credentials : " +
            this.username +
            " , " +
            this.password.toString().substring(0, this.password.toString().length - 2));
    var challenge = idr['donneesSec']['donnees']['challenge'];
    var e = Encryption();
    e.aesSetIV(this.communication!.encryption.aesIV);
    var motdepasse;

    if (this.ent != null && this.ent == true) {
      List<int> encoded = conv.utf8.encode(this.password);
      motdepasse = sha256.convert(encoded).bytes;
      motdepasse = conv.hex.encode(motdepasse);
      motdepasse = motdepasse.toString().toUpperCase();
      e.aesKey = conv.hex.encode(md5.convert(conv.utf8.encode(motdepasse)).bytes);
    } else {
      var u = this.username;
      var p = this.password;

      //Convert credentials to lowercase if needed (API returns 1)
      if (idr['donneesSec']['donnees']['modeCompLog'] != null && idr['donneesSec']['donnees']['modeCompLog'] != 0) {
        CustomLogger.log("PRONOTE", "LOWER CASE ID");
        CustomLogger.log("PRONOTE", idr['donneesSec']['donnees']['modeCompLog'].toString());
        u = u.toString().toLowerCase();
        this.stepsLogger.add("ⓘ Lowercased id");
      }

      if (idr['donneesSec']['donnees']['modeCompMdp'] != null && idr['donneesSec']['donnees']['modeCompMdp'] != 0) {
        CustomLogger.log("PRONOTE", "LOWER CASE PASSWORD");
        CustomLogger.log("PRONOTE", idr['donneesSec']['donnees']['modeCompMdp'].toString());
        p = p.toString().toLowerCase();
        this.stepsLogger.add("ⓘ Lowercased password");
      }

      var alea = idr['donneesSec']['donnees']['alea'];
      CustomLogger.log("PRONOTE", alea);
      List<int> encoded = conv.utf8.encode((alea ?? "") + p);
      motdepasse = sha256.convert(encoded);
      motdepasse = conv.hex.encode(motdepasse.bytes);
      motdepasse = motdepasse.toString().toUpperCase();
      e.aesKey = md5.convert(conv.utf8.encode(u + motdepasse));
    }

    var rawChallenge = e.aesDecrypt(conv.hex.decode(challenge));
    this.stepsLogger.add("✅ Decrypted challenge");

    var rawChallengeWithoutAlea = removeAlea(rawChallenge);
    this.stepsLogger.add("✅ Removed alea");

    var encryptedChallenge = e.aesEncrypt(conv.utf8.encode(rawChallengeWithoutAlea));
    this.stepsLogger.add("✅ Encrypted credentials");

    Map authentificationJson = {
      "connexion": 0,
      "challenge": encryptedChallenge,
      "espace": int.parse(this.attributes['a'])
    };
    this.stepsLogger.add("✅ Identification passed");

    try {
      CustomLogger.log("PRONOTE", "Authentification");
      this.authResponse = await this
          .communication!
          .post("Authentification", data: {'donnees': authentificationJson, 'identifiantNav': ''});
    } catch (e) {
      this.stepsLogger.add("❌  Authentification failed : " + e.toString());
      throw ("Error during auth" + e.toString());
    }

    try {
      if ((mobileLogin == true || qrCodeLogin == true) &&
          this.authResponse['donneesSec']['donnees']["jetonConnexionAppliMobile"] != null) {
        CustomLogger.log("PRONOTE", "Saving token");
        await storage.write(
            key: "password", value: this.authResponse['donneesSec']['donnees']["jetonConnexionAppliMobile"]);
        this.password = this.authResponse['donneesSec']['donnees']["jetonConnexionAppliMobile"];
      }
      if (this.authResponse['donneesSec']['donnees'].toString().contains("cle")) {
        await this.communication!.afterAuth(this.communication!.lastResponse, this.authResponse, e.aesKey);
        if (isOldAPIUsed == false) {
          try {
            paramsUser = await this.communication!.post("ParametresUtilisateur", data: {'donnees': {}});
            this.encryption.aesKey = this.communication?.encryption.aesKey;

            this.communication!.authorizedTabs =
                prepareTabs(mapGet(paramsUser, ['donneesSec', 'donnees', 'listeOnglets']));

            this.stepsLogger.add("✅ Prepared tabs");

            try {
              createStorage("classe", mapGet(paramsUser, ['donneesSec', 'donnees', 'ressource', "classeDEleve", "L"]));
              createStorage("userFullName", mapGet(paramsUser, ['donneesSec', 'donnees', 'ressource', "L"]));
            } catch (e) {
              this.stepsLogger.add("❌ Failed to register UserInfos");

              CustomLogger.log("PRONOTE", "Failed to register UserInfos");
              CustomLogger.error(e);
            }
          } catch (e) {
            this.stepsLogger.add("ⓘ Using old api ");

            CustomLogger.log("PRONOTE", "Surely using OLD API");
          }
        }

        CustomLogger.log("PRONOTE", "Successfully logged in as ${this.username}");
        return true;
      } else {
        CustomLogger.log("PRONOTE", "Login failed");
        return false;
      }
    } catch (e) {
      throw ("Error during after auth " + e.toString());
    }
  }
}

class PronotePeriod {
  DateTime? end;

  DateTime? start;

  var name;

  var id;

  var moyenneGenerale;
  var moyenneGeneraleClasse;

  late PronoteClient _client;

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

  PronotePeriod(PronoteClient client, Map parsedJson) {
    this._client = client;
    this.id = parsedJson['N'];
    this.name = parsedJson['L'];
    var inputFormat = DateFormat("dd/MM/yyyy");
    this.start = inputFormat.parse(parsedJson['dateDebut']['V']);
    this.end = inputFormat.parse(parsedJson['dateFin']['V']);
  }

  ///Return the eleve average, the max average, the min average, and the class average
  average(var json, var codeMatiere) {
    //The services for the period
    List services = json['donneesSec']['donnees']['listeServices']['V'];
    //The average data for the given matiere

    var averageData = services.firstWhere((element) => element["L"].hashCode.toString() == codeMatiere);
    //CustomLogger.log("PRONOTE", averageData["moyEleve"]["V"]);

    return [
      gradeTranslate(averageData["moyEleve"]["V"]),
      gradeTranslate(averageData["moyMax"]["V"]),
      gradeTranslate(averageData["moyMin"]["V"]),
      gradeTranslate(averageData["moyClasse"]["V"])
    ];
  }

  grades(int codePeriode) async {
    //Get grades from the period.
    List<Grade> list = [];
    var jsonData = {
      'donnees': {
        'Periode': {'N': this.id, 'L': this.name}
      },
      "_Signature_": {"onglet": 198}
    };

    //Tests

    /*var a = await Requests.get("http://192.168.1.99:3000/posts/2");

    var response = (codePeriode == 2) ? a.json() : {};
    */
    var response = await _client.communication!.post('DernieresNotes', data: jsonData);
    var grades = mapGet(response, ['donneesSec', 'donnees', 'listeDevoirs', 'V']) ?? [];
    this.moyenneGenerale = gradeTranslate(mapGet(response, ['donneesSec', 'donnees', 'moyGenerale', 'V']) ?? "");
    this.moyenneGeneraleClasse =
        gradeTranslate(mapGet(response, ['donneesSec', 'donnees', 'moyGeneraleClasse', 'V']) ?? "");

    var other = [];
    grades.forEach((element) async {
      list.add(Grade(
          value: this.gradeTranslate(mapGet(element, ["note", "V"]) ?? ""),
          testName: element["commentaire"],
          periodCode: this.id,
          periodName: this.name,
          disciplineCode: (mapGet(element, ["service", "V", "L"]) ?? "").hashCode.toString(),
          subdisciplineCode: null,
          disciplineName: mapGet(element, ["service", "V", "L"]),
          letters: (mapGet(element, ["note", "V"]) ?? "").contains("|"),
          weight: mapGet(element, ["coefficient"]).toString(),
          scale: mapGet(element, ["bareme", "V"]),
          min: this.gradeTranslate(mapGet(element, ["noteMin", "V"]) ?? ""),
          max: this.gradeTranslate(mapGet(element, ["noteMax", "V"]) ?? ""),
          classAverage: this.gradeTranslate(mapGet(element, ["moyenne", "V"]) ?? ""),
          date: mapGet(element, ["date", "V"]) != null ? DateFormat("dd/MM/yyyy").parse(element["date"]["V"]) : null,
          notSignificant: this.gradeTranslate(mapGet(element, ["note", "V"]) ?? "") == "NonNote",
          testType: "Interrogation",
          entryDate: mapGet(element, ["date", "V"]) != null
              ? DateFormat("dd/MM/yyyy").parse(mapGet(element, ["date", "V"]))
              : null,
          countAsZero: shouldCountAsZero(this.gradeTranslate(mapGet(element, ["note", "V"]) ?? ""))));
      other.add(average(response, (mapGet(element, ["service", "V", "L"]) ?? "").hashCode.toString()));
    });
    return [list, other];
  }

  gradeTranslate(String value) {
    List gradeTranslate = [
      'Absent',
      'Dispensé',
      'Non noté',
      'Inapte',
      'Non rendu',
      'Absent zéro',
      'Non rendu zéro',
      'Félicitations'
    ];
    if (value.contains("|")) {
      return gradeTranslate[int.parse(value[1]) - 1];
    } else {
      return value;
    }
  }

  shouldCountAsZero(String grade) {
    if (grade == "Absent zéro" || grade == "Non rendu zéro") {
      return true;
    } else
      return false;
  }
}

class PronoteUtils {
  gradeTranslate(String value) {
    List gradeTranslate = [
      'Absent',
      'Dispensé',
      'Non noté',
      'Inapte',
      'Non rendu',
      'Absent zéro',
      'Non rendu zéro',
      'Félicitations'
    ];
    if (value.contains("|")) {
      return gradeTranslate[int.parse(value[1]) - 1];
    } else {
      return value;
    }
  }

  shouldCountAsZero(String grade) {
    if (grade == "Absent zéro" || grade == "Non rendu zéro") {
      return true;
    } else
      return false;
  }
}
