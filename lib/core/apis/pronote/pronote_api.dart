import 'dart:convert' as conv;
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart' as conv;
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pointycastle/asymmetric/pkcs1.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:requests/requests.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/shared/login_controller.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/utils/null_safe_map_getter.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/tests.dart';

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
  for (var rune in text.runes) {
    var character = String.fromCharCode(rune);
    if (i % 2 == 0) {
      sansalea.add(character);
    }
    i++;
  }

  return sansalea.join("");
}

///Communication class used to send requests to Pronote
class Communication {
  dynamic cookies;
  late PronoteClient client;
  dynamic htmlPage;
  dynamic rootSite;
  late Encryption encryption;
  Map? attributes;
  late int requestNumber;
  List? authorizedTabs;
  late bool shouldCompressRequests;
  late double lastPing;
  late bool shouldEncryptRequests;
  dynamic lastResponse;
  Requests? session;
  dynamic requests;

  Communication(String site, this.cookies, this.client) {
    rootSite = getRootAdress(site)[0];
    htmlPage = getRootAdress(site)[1];

    encryption = Encryption();
    attributes = {};
    requestNumber = 1;
    lastPing = 0;
    authorizedTabs = [];
    shouldCompressRequests = false;
    shouldEncryptRequests = false;
    lastResponse = null;
  }

  afterAuth(var authentificationResponse, var data, var authentificationKey) async {
    encryption.aesKey = authentificationKey;
    if (cookies == null) {
      var host = Requests.getHostname(authentificationResponse.url.toString());
      cookies = await Requests.getStoredCookies(host);
    }
    var work = encryption.aesDecrypt(conv.hex.decode(data['donneesSec']['donnees']['cle']));
    try {
      authorizedTabs = prepareTabs(data['donneesSec']['donnees']['listeOnglets']);

      KVS.write(key: "classe", value: data['donneesSec']['donnees']['ressource']["classeDEleve"]["L"]);
      KVS.write(key: "userFullName", value: data['donneesSec']['donnees']['ressource']["L"]);
      isOldAPIUsed = true;
    } catch (e) {
      isOldAPIUsed = false;
      client.stepsLogger.add("ⓘ 2020 API");
      CustomLogger.log("PRONOTE", "Surely using the 2020 API");
    }
    var key = md5.convert(toBytes(work));
    CustomLogger.log("PRONOTE", "New key : $key");
    encryption.aesKey = key;
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
    String hostName = Requests.getHostname(rootSite + "/" + htmlPage);

    //set the cookies for ENT
    if (cookies != null) {
      CustomLogger.log("PRONOTE", "Cookies set");
      Requests.setStoredCookies(hostName, cookies);
    }

    var headers = {
      'connection': 'keep-alive',
      'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/74.0'
    };

    String url = rootSite +
        "/" +
        (cookies != null ? "?fd=1" : htmlPage) +
        (((client.mobileLogin ?? false) || (client.qrCodeLogin ?? false))
            ? "?fd=1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335"
            : "");
    if (url.contains("?login=true") || url.contains("?fd=1")) {
      url += "&fd=1";
    } else {
      url += "?fd=1";
    }
    CustomLogger.log("PRONOTE", "Url is $url");
    client.stepsLogger.add("ⓘ Used url is `$url`");
    CustomLogger.log("PRONOTE", (client.mobileLogin ?? false) ? "CAS" : "NOT CAS");
//?fd=1 bypass the old navigator issue
    var getResponse = await Requests.get(url, headers: headers).catchError((e) {
      client.stepsLogger.add("❌ Failed login request " + e.toString());
      throw ("Failed login request");
    });
    client.stepsLogger.add("✅ Posted login request");

    if (getResponse.hasError) {
      CustomLogger.log("PRONOTE", "|pImpossible de se connecter à l'adresse fournie");
    }

    attributes = parseHtml(getResponse.content());
    client.stepsLogger.add("✅ Parsed HTML");
    //uuid
    encryption.rsaKeys = {'MR': attributes!['MR'], 'ER': attributes!['ER']};
    var uuid = conv.base64.encode(await encryption.rsaEncrypt(encryption.aesIVTemp.bytes));
    client.stepsLogger.add("✅ Encrypted IV");

    //uuid
    var jsonPost = {'Uuid': uuid, 'identifiantNav': null};
    shouldEncryptRequests = (attributes!["sCrA"] == null);
    if (attributes!["sCrA"] == null) {
      client.stepsLogger.add("ⓘ Requests will be encrypted");
    }
    shouldCompressRequests = (attributes!["sCoA"] == null);
    if (attributes!["sCoA"] == null) {
      client.stepsLogger.add("ⓘ Requests will be compressed");
    }
    var initialResponse = await post('FonctionParametres',
        data: {'donnees': jsonPost},
        decryptionChange: {'iv': conv.hex.encode(md5.convert(encryption.aesIVTemp.bytes).bytes)});

    return [attributes, initialResponse];
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
        client.stepsLogger.add("❌ Failed to parse HTML");
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
    client.stepsLogger.add("✅ Posting " + functionName);
    if (data != null && data! is String) {
      if (data["_Signature_"] != null &&
          !authorizedTabs.toString().contains(data['_Signature_']['onglet'].toString())) {
        throw ('Action not permitted. (onglet is not normally accessible)');
      }
    }

    if (shouldCompressRequests) {
      CustomLogger.log("PRONOTE", "Compress request");
      data = conv.jsonEncode(data);

      CustomLogger.log("PRONOTE", data);
      var zlibInstance = ZLibCodec(level: 6, raw: true);
      data = zlibInstance.encode(conv.utf8.encode(conv.hex.encode(conv.utf8.encode(data))));
      client.stepsLogger.add("✅ Compressed request");
    }
    if (shouldEncryptRequests) {
      CustomLogger.log("PRONOTE", "Encrypt requests");
      data = encryption.aesEncrypt(data);
      client.stepsLogger.add("✅ Encrypted request");
    }
    var rNumber = encryption.aesEncrypt(conv.utf8.encode(requestNumber.toString()));

    var json = {
      'session': int.parse(attributes!['h']),
      'numeroOrdre': rNumber,
      'nom': functionName,
      'donneesSec': data
    };
    String pSite = rootSite + '/appelfonction/' + attributes!['a'] + '/' + attributes!['h'] + '/' + rNumber;
    CustomLogger.log("PRONOTE", pSite);

    requestNumber += 2;
    CustomLogger.log("PRONOTE", json.toString());
    var response = await Requests.post(pSite, json: json).catchError((onError) {
      CustomLogger.log("PRONOTE", "Error occured during request : $onError");
    });

    lastPing = (DateTime.now().millisecondsSinceEpoch / 1000);
    lastResponse = response;
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

      return await client.communication?.post(functionName, data: data, recursive: true);
    }

    if (decryptionChange != null) {
      CustomLogger.log("PRONOTE", "decryption change");
      if (decryptionChange.toString().contains("iv")) {
        CustomLogger.log("PRONOTE", "decryption_change contains IV");
        CustomLogger.log("PRONOTE", decryptionChange['iv']);
        encryption.aesIV = IV.fromBase16(decryptionChange['iv']);
      }

      if (decryptionChange.toString().contains("key")) {
        CustomLogger.log("PRONOTE", "decryption_change contains key");
        CustomLogger.log("PRONOTE", decryptionChange['key']);
        encryption.aesKey = decryptionChange['key'];
      }
    }

    Map responseData = response.json();

    if (shouldEncryptRequests) {
      responseData['donneesSec'] = encryption.aesDecryptAsBytes(conv.hex.decode(responseData['donneesSec']));
      CustomLogger.log("PRONOTE", "décrypté données sec");
      client.stepsLogger.add("✅ Decrypted response");
    }
    var zlibInstanceDecoder = ZLibDecoder(raw: true);
    if (shouldCompressRequests) {
      var toDecode = responseData['donneesSec'];
      responseData['donneesSec'] = conv.utf8.decode(zlibInstanceDecoder.convert(toDecode));
      client.stepsLogger.add("✅ Decompressed response");
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

    CustomLogger.log("PRONOTE", aesIV?.base16.toString() ?? "");

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

    CustomLogger.log("PRONOTE", aesIV.toString());

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
      CustomLogger.log("PRONOTE", "KEY :" + aesKey.toString());
      iv = aesIV;
      CustomLogger.log("PRONOTE", iv.base16);
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
      CustomLogger.log("PRONOTE", rsaKeys.toString());
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

class KeepAlive {
  Communication? _connection;

  late bool keepAlive;

  void alive() async {
    while (keepAlive) {
      if (DateTime.now().millisecondsSinceEpoch / 1000 - _connection!.lastPing >= 300) {
        _connection!.post("Presence", data: {
          '_Signature_': {'onglet': 7}
        });
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void init(PronoteClient client) {
    _connection = client.communication;
    keepAlive = true;
  }
}

class PronoteClient {
  dynamic username;
  dynamic password;
  dynamic pronoteUrl;
  Communication? communication;
  dynamic attributes;
  dynamic funcOptions;
  PronoteUtils utils = PronoteUtils();
  bool? ent;

  late Encryption encryption;

  double? lastPing;

  DateTime? date;

  DateTime? startDay;

  dynamic week;

  dynamic localPeriods;

  bool? expired;

  dynamic authResponse;

  bool? loggedIn;

  dynamic authCookie;
  Map? paramsUser;

  late DateTime hourEnd;

  late DateTime hourStart;

  int? oneHourDuration;

  List<String> stepsLogger = [];
  bool? mobileLogin;
  bool? qrCodeLogin;

  PronoteClient(this.pronoteUrl,
      {String? username, String? password, var cookies, this.mobileLogin, this.qrCodeLogin}) {
    this.username = username ?? "";
    this.password = password ?? "";
    CustomLogger.log("PRONOTE", "Initiate communication");

    communication = Communication(pronoteUrl, cookies, this);
  }

  downloadUrl(Document document) {
    try {
      Map data = {"N": document.id, "G": int.parse(document.type!)};
      //Used by pronote to encrypt the data (I don't know why)
      var magicStuff = encryption.aesEncrypt(conv.utf8.encode(conv.jsonEncode(data)));
      String libelle = document.documentName ?? "";
      String? url = communication!.rootSite +
          '/FichiersExternes/' +
          magicStuff +
          '/' +
          libelle +
          '?Session=' +
          attributes['h'].toString();
      if (url != null) CustomLogger.log("PRONOTE", url);
      return url;
    } catch (e) {
      CustomLogger.error(e, stackHint:"MTM=");
    }
  }

  Future<bool?> init() async {
    if (!Platform.isLinux && !Platform.isWindows) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      stepsLogger.add("ⓘ " +
          DateFormat("dd/MM/yyyy hh:mm:ss").format(DateTime.now()) +
          " Started login - yNotes version is : " +
          packageInfo.version +
          "+" +
          packageInfo.buildNumber +
          " T" +
          Tests.testVersion);
    }
    var attributesandfunctions = await communication!.initialise();
    stepsLogger.add("✅ Initialized");

    attributes = attributesandfunctions[0];
    funcOptions = attributesandfunctions[1];

    if (attributes["e"] != null && attributes["f"] != null) {
      CustomLogger.log("PRONOTE", "LOGIN AS ENT");
      ent = true;
    } else {
      CustomLogger.log("PRONOTE", "LOGIN AS REGULAR USER");
      ent = false;
    }
    stepsLogger.add("✅ Login passed : using " + ((ent ?? false) ? "ent" : "direct") + "connection");
    //set up encryption
    encryption = Encryption();
    encryption.aesIV = communication!.encryption.aesIV;
    //some other attribute creation
    lastPing = DateTime.now().millisecondsSinceEpoch / 1000;
    authResponse = null;
    authCookie = null;
    date = DateTime.now();
    var inputFormat = DateFormat("dd/MM/yyyy");

    startDay = inputFormat.parse(funcOptions['donneesSec']['donnees']['General']['PremierLundi']['V']);

    await KVS.write(key: "startday", value: startDay.toString());
    week = await getWeek(DateTime.now());

    localPeriods = periods;
    stepsLogger.add("✅ Created attributes");

    loggedIn = await _login();
    hourStart =
        DateFormat("hh'h'mm").parse(funcOptions['donneesSec']['donnees']['General']['ListeHeures']['V'][0]['L']);
    hourEnd =
        DateFormat("hh'h'mm").parse(funcOptions['donneesSec']['donnees']['General']['ListeHeuresFin']['V'][0]['L']);

    oneHourDuration = hourEnd.difference(hourStart).inMinutes;
    expired = false;
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
          CustomLogger.error(e, stackHint:"MTQ=");
        }
      });
      CustomLogger.log("PRONOTE", "Agenda collecte succeeded");
      return listToReturn;
    }*/
  }

  List<PronotePeriod> periods() {
    CustomLogger.log("PRONOTE", "GETTING PERIODS");
    dynamic json;
    try {
      json = funcOptions['donneesSec']['donnees']['General']['ListePeriodes'];
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

    communication = Communication(pronoteUrl, null, this);
    var future = await communication!.initialise();

    attributes = future[0];
    funcOptions = future[1];
    encryption = Encryption();
    encryption.aesIV = communication!.encryption.aesIV;
    await _login();
    localPeriods = null;
    localPeriods = periods();
    week = await getWeek(DateTime.now());

    hourStart =
        DateFormat("""'hh'h'mm'""").parse(funcOptions['donneesSec']['donnees']['General']['ListeHeures']['V'][0]['L']);
    hourEnd = DateFormat("""'hh'h'mm'""")
        .parse(funcOptions['donneesSec']['donnees']['General']['ListeHeuresFin']['V'][0]['L']);

    oneHourDuration = hourEnd.difference(hourStart).inMinutes;
    CustomLogger.log("PRONOTE", "ohduration " + oneHourDuration.toString());

    expired = true;
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

    var response = await communication!.post('SaisieActualites', data: data);
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
      var response = await communication!.post('SaisieActualites', data: data);
      CustomLogger.log("PRONOTE", response);
    } catch (e) {
      CustomLogger.error(e, stackHint:"MTU=");
    }
  }

  _login() async {
    try {
      await KVS.write(key: "username", value: username);
      if (mobileLogin == false && qrCodeLogin == false) {
        await KVS.write(key: "password", value: password);
      }
      //In case password changed
      if ((mobileLogin == true || qrCodeLogin == true) && (await KVS.read(key: "password")) != null) {
        password = await KVS.read(key: "password");
      }
      await KVS.write(key: "pronoteurl", value: pronoteUrl);
      await KVS.write(key: "ispronotecas", value: ((mobileLogin ?? false) || (qrCodeLogin ?? false)).toString());

      CustomLogger.log("PRONOTE", "Saved credentials");
    } catch (e) {
      CustomLogger.log("PRONOTE", "failed to write values");
    }
    if (ent != null && ent!) {
      username = attributes['e'];
      password = attributes['f'];
    }
    Map indentJson = {
      "genreConnexion": 0,
      "genreEspace": int.parse(attributes['a']),
      "identifiant": username,
      "pourENT": ent,
      "enConnexionAuto": false,
      "demandeConnexionAuto": false,
      "enConnexionAppliMobile": (qrCodeLogin == false) ? mobileLogin : false,
      "demandeConnexionAppliMobile": qrCodeLogin,
      "demandeConnexionAppliMobileJeton": qrCodeLogin,
      "uuidAppliMobile": appSys.settings.system.uuid,
      "loginTokenSAV": ""
    };
    var idr = await communication!.post("Identification", data: {'donnees': indentJson});
    stepsLogger.add("✅ Posted identification successfully");

    CustomLogger.log("PRONOTE", "Identification");
    CustomLogger.log(
        "PRONOTE",
        "Using following credentials : " +
            username +
            " , " +
            password.toString().substring(0, password.toString().length - 2),
        save: false);
    var challenge = idr['donneesSec']['donnees']['challenge'];
    var e = Encryption();
    e.aesSetIV(communication!.encryption.aesIV);
    dynamic motdepasse;

    if (ent != null && ent == true) {
      List<int> encoded = conv.utf8.encode(password);
      motdepasse = sha256.convert(encoded).bytes;
      motdepasse = conv.hex.encode(motdepasse);
      motdepasse = motdepasse.toString().toUpperCase();
      e.aesKey = conv.hex.encode(md5.convert(conv.utf8.encode(motdepasse)).bytes);
    } else {
      var u = username;
      var p = password;

      //Convert credentials to lowercase if needed (API returns 1)
      if (idr['donneesSec']['donnees']['modeCompLog'] != null && idr['donneesSec']['donnees']['modeCompLog'] != 0) {
        CustomLogger.log("PRONOTE", "LOWER CASE ID");
        CustomLogger.log("PRONOTE", idr['donneesSec']['donnees']['modeCompLog'].toString());
        u = u.toString().toLowerCase();
        stepsLogger.add("ⓘ Lowercased id");
      }

      if (idr['donneesSec']['donnees']['modeCompMdp'] != null && idr['donneesSec']['donnees']['modeCompMdp'] != 0) {
        CustomLogger.log("PRONOTE", "LOWER CASE PASSWORD");
        CustomLogger.log("PRONOTE", idr['donneesSec']['donnees']['modeCompMdp'].toString());
        p = p.toString().toLowerCase();
        stepsLogger.add("ⓘ Lowercased password");
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
    stepsLogger.add("✅ Decrypted challenge");

    var rawChallengeWithoutAlea = removeAlea(rawChallenge);
    stepsLogger.add("✅ Removed alea");

    var encryptedChallenge = e.aesEncrypt(conv.utf8.encode(rawChallengeWithoutAlea));
    stepsLogger.add("✅ Encrypted credentials");

    Map authentificationJson = {"connexion": 0, "challenge": encryptedChallenge, "espace": int.parse(attributes['a'])};
    stepsLogger.add("✅ Identification passed");

    try {
      CustomLogger.log("PRONOTE", "Authentification");
      authResponse =
          await communication!.post("Authentification", data: {'donnees': authentificationJson, 'identifiantNav': ''});
    } catch (e) {
      stepsLogger.add("❌  Authentification failed : " + e.toString());
      throw ("Error during auth" + e.toString());
    }

    try {
      if ((mobileLogin == true || qrCodeLogin == true) &&
          authResponse['donneesSec']['donnees']["jetonConnexionAppliMobile"] != null) {
        CustomLogger.log("PRONOTE", "Saving token");
        await KVS.write(key: "password", value: authResponse['donneesSec']['donnees']["jetonConnexionAppliMobile"]);
        password = authResponse['donneesSec']['donnees']["jetonConnexionAppliMobile"];
      }
      if (authResponse['donneesSec']['donnees'].toString().contains("cle")) {
        await communication!.afterAuth(communication!.lastResponse, authResponse, e.aesKey);
        if (isOldAPIUsed == false) {
          try {
            paramsUser = await communication!.post("ParametresUtilisateur", data: {'donnees': {}});
            encryption.aesKey = communication?.encryption.aesKey;

            communication!.authorizedTabs = prepareTabs(mapGet(paramsUser, ['donneesSec', 'donnees', 'listeOnglets']));

            stepsLogger.add("✅ Prepared tabs");

            try {
              KVS.write(
                  key: "classe",
                  value: mapGet(paramsUser, ['donneesSec', 'donnees', 'ressource', "classeDEleve", "L"]));
              KVS.write(key: "userFullName", value: mapGet(paramsUser, ['donneesSec', 'donnees', 'ressource', "L"]));
            } catch (e) {
              stepsLogger.add("❌ Failed to register UserInfos");

              CustomLogger.log("PRONOTE", "Failed to register UserInfos");
              CustomLogger.error(e, stackHint:"MTY=");
            }
          } catch (e) {
            stepsLogger.add("ⓘ Using old api ");

            CustomLogger.log("PRONOTE", "Surely using OLD API");
          }
        }

        CustomLogger.log("PRONOTE", "Successfully logged in as $username");
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

  dynamic name;

  dynamic id;

  dynamic moyenneGenerale;
  dynamic moyenneGeneraleClasse;

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
    _client = client;
    id = parsedJson['N'];
    name = parsedJson['L'];
    var inputFormat = DateFormat("dd/MM/yyyy");
    start = inputFormat.parse(parsedJson['dateDebut']['V']);
    end = inputFormat.parse(parsedJson['dateFin']['V']);
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
        'Periode': {'N': id, 'L': name}
      },
      "_Signature_": {"onglet": 198}
    };

    //Tests

    /*var a = await Requests.get("http://192.168.1.99:3000/posts/2");

    var response = (codePeriode == 2) ? a.json() : {};
    */
    var response = await _client.communication!.post('DernieresNotes', data: jsonData);
    var grades = mapGet(response, ['donneesSec', 'donnees', 'listeDevoirs', 'V']) ?? [];
    moyenneGenerale = gradeTranslate(mapGet(response, ['donneesSec', 'donnees', 'moyGenerale', 'V']) ?? "");
    moyenneGeneraleClasse = gradeTranslate(mapGet(response, ['donneesSec', 'donnees', 'moyGeneraleClasse', 'V']) ?? "");

    var other = [];
    grades.forEach((element) async {
      list.add(Grade(
          value: gradeTranslate(mapGet(element, ["note", "V"]) ?? ""),
          testName: element["commentaire"],
          periodCode: id,
          periodName: name,
          disciplineCode: (mapGet(element, ["service", "V", "L"]) ?? "").hashCode.toString(),
          subdisciplineCode: null,
          disciplineName: mapGet(element, ["service", "V", "L"]),
          letters: (mapGet(element, ["note", "V"]) ?? "").contains("|"),
          weight: mapGet(element, ["coefficient"]).toString(),
          scale: mapGet(element, ["bareme", "V"]),
          min: gradeTranslate(mapGet(element, ["noteMin", "V"]) ?? ""),
          max: gradeTranslate(mapGet(element, ["noteMax", "V"]) ?? ""),
          classAverage: gradeTranslate(mapGet(element, ["moyenne", "V"]) ?? ""),
          date: mapGet(element, ["date", "V"]) != null ? DateFormat("dd/MM/yyyy").parse(element["date"]["V"]) : null,
          notSignificant: gradeTranslate(mapGet(element, ["note", "V"]) ?? "") == "NonNote",
          testType: "Interrogation",
          entryDate: mapGet(element, ["date", "V"]) != null
              ? DateFormat("dd/MM/yyyy").parse(mapGet(element, ["date", "V"]))
              : null,
          countAsZero: shouldCountAsZero(gradeTranslate(mapGet(element, ["note", "V"]) ?? ""))));
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
    } else {
      return false;
    }
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
    } else {
      return false;
    }
  }
}
