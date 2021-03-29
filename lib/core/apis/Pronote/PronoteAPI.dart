import 'dart:io';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/pkcs1.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:requests/requests.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/nullSafeMap.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/core/apis/Pronote/PronoteCas.dart';
import 'package:ynotes/tests.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logsPage.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'dart:convert' as conv;
import 'package:ynotes/core/logic/shared/loginController.dart';

import '../EcoleDirecte.dart';
import '../utils.dart';

Map error_messages = {
  22: '[ERROR 22] The object was from a previous session. Please read the "Long Term Usage" section in README on github.',
  10: '[ERROR 10] Session has expired and pronotepy was not able to reinitialise the connection.'
};
bool isOldAPIUsed = false;

class Client {
  var username;
  var password;
  var pronote_url;
  Communication communication;
  var attributes;
  var funcOptions;

  bool ent;

  Encryption encryption;

  double lastPing;

  DateTime date;

  DateTime startDay;

  var week;

  var localPeriods;

  bool expired;

  var authResponse;

  bool loggedIn;

  var authCookie;
  var paramsUser;

  DateTime hourEnd;

  DateTime hourStart;

  int oneHourDuration;

  List<String> stepsLogger;
  refresh() async {
    print("Reinitialisation");

    this.communication = Communication(this.pronote_url, null, this);
    var future = await this.communication.initialise();

    this.attributes = future[0];
    this.funcOptions = future[1];
    this.encryption = Encryption();
    this.encryption.aesIV = this.communication.encryption.aesIV;
    await this._login();
    this.localPeriods = null;
    this.localPeriods = this.periods();
    this.week = await get_week(DateTime.now());

    this.hourStart = DateFormat("""'hh'h'mm'""")
        .parse(this.funcOptions['donneesSec']['donnees']['General']['ListeHeures']['V'][0]['L']);
    this.hourEnd = DateFormat("""'hh'h'mm'""")
        .parse(this.funcOptions['donneesSec']['donnees']['General']['ListeHeuresFin']['V'][0]['L']);

    this.oneHourDuration = hourEnd.difference(hourStart).inMinutes;
    print("ohduration " + oneHourDuration.toString());

    this.expired = true;
  }

  Client(String pronote_url, {String username, String password, var cookies}) {
    if (cookies == null && password == null && username == null) {
      throw 'Please provide login credentials. Cookies are None, and username and password are empty.';
    }
    this.username = username;
    this.password = password;
    this.pronote_url = pronote_url;
    print("Initiate communication");

    this.communication = Communication(pronote_url, cookies, this);
  }
  Future init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    this.stepsLogger = List();
    this.stepsLogger.add("ⓘ " +
            DateFormat("dd/MM/yyyy hh:mm:ss").format(DateTime.now()) +
            " Started login - yNotes version is : " +
            packageInfo.version +
            "+" +
            packageInfo.buildNumber +
            " T" +
            Tests.testVersion ??
        "");

    var attributesandfunctions = await this.communication.initialise();
    this.stepsLogger.add("✅ Initialized");

    this.attributes = attributesandfunctions[0];
    this.funcOptions = attributesandfunctions[1];

    if (this.attributes["e"] != null && this.attributes["f"] != null) {
      print("LOGIN AS ENT");
      this.ent = true;
    } else {
      print("LOGIN AS REGULAR USER");
      this.ent = false;
    }
    this.stepsLogger.add("✅ Login passed : using " + ((this.ent ?? false) ? "ent" : "direct") + "connection");
    //set up encryption
    this.encryption = Encryption();
    this.encryption.aesIV = this.communication.encryption.aesIV;

    //some other attribute creation
    this.lastPing = DateTime.now().millisecondsSinceEpoch / 1000;
    this.authResponse = null;
    this.authCookie = null;
    this.date = DateTime.now();
    var inputFormat = DateFormat("dd/MM/yyyy");
    this.startDay = inputFormat.parse(this.funcOptions['donneesSec']['donnees']['General']['PremierLundi']['V']);
    final storage = new FlutterSecureStorage();
    await storage.write(key: "startday", value: this.startDay.toString());
    this.week = await get_week(DateTime.now());

    this.localPeriods = this.periods;
    this.stepsLogger.add("✅ Created attributes");

    this.loggedIn = await this._login();

    this.hourStart =
        DateFormat("hh'h'mm").parse(this.funcOptions['donneesSec']['donnees']['General']['ListeHeures']['V'][0]['L']);
    this.hourEnd = DateFormat("hh'h'mm")
        .parse(this.funcOptions['donneesSec']['donnees']['General']['ListeHeuresFin']['V'][0]['L']);

    this.oneHourDuration = hourEnd.difference(hourStart).inMinutes;
    this.expired = false;
  }

  _login() async {
    try {
      final storage = new FlutterSecureStorage();
      await storage.write(key: "username", value: this.username);
      await storage.write(key: "password", value: this.password);
      await storage.write(key: "pronoteurl", value: this.pronote_url);
      print("Saved credentials");
    } catch (e) {
      print("failed to write values");
    }
    if (this.ent != null && this.ent) {
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
    var idr = await this.communication.post("Identification", data: {'donnees': ident_json});
    this.stepsLogger.add("✅ Posted identification successfully");

    print("Identification");

    var challenge = idr['donneesSec']['donnees']['challenge'];
    var e = Encryption();
    e.aesSetIV(this.communication.encryption.aesIV);
    var motdepasse;

    if (this.ent != null && this.ent == true) {
      List<int> encoded = conv.utf8.encode(this.password);
      motdepasse = sha256.convert(encoded).bytes;
      motdepasse = hex.encode(motdepasse);
      motdepasse = motdepasse.toString().toUpperCase();
      e.aesKey = hex.encode(md5.convert(conv.utf8.encode(motdepasse)).bytes);
    } else {
      var u = this.username;
      var p = this.password;

      //Convert credentials to lowercase if needed (API returns 1)
      if (idr['donneesSec']['donnees']['modeCompLog'] != null && idr['donneesSec']['donnees']['modeCompLog'] != 0) {
        print("LOWER CASE ID");
        print(idr['donneesSec']['donnees']['modeCompLog']);
        u = u.toString().toLowerCase();
        this.stepsLogger.add("ⓘ Lowercased id");
      }

      if (idr['donneesSec']['donnees']['modeCompMdp'] != null && idr['donneesSec']['donnees']['modeCompMdp'] != 0) {
        print("LOWER CASE PASSWORD");
        print(idr['donneesSec']['donnees']['modeCompMdp']);
        p = p.toString().toLowerCase();
        this.stepsLogger.add("ⓘ Lowercased password");
      }
      var alea = idr['donneesSec']['donnees']['alea'];
      List<int> encoded = conv.utf8.encode((alea ?? "") + p);
      motdepasse = sha256.convert(encoded);
      motdepasse = hex.encode(motdepasse.bytes);
      motdepasse = motdepasse.toString().toUpperCase();
      e.aesKey = md5.convert(conv.utf8.encode(u + motdepasse));
    }
    print(e.aesKey);
    print("CHALLENGE" + challenge);
    print("IV " + e.aesIV.base16);

    var rawChallenge = e.aesDecrypt(hex.decode(challenge));
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
      print("Authentification");
      this.authResponse = await this
          .communication
          .post("Authentification", data: {'donnees': authentificationJson, 'identifiantNav': ''});
    } catch (e) {
      this.stepsLogger.add("❌  Authentification failed : " + e.toString());
      throw ("Error during auth" + e.toString());
    }

    try {
      if (this.authResponse['donneesSec']['donnees'].toString().contains("cle")) {
        await this.communication.afterAuth(this.communication.lastResponse, this.authResponse, e.aesKey);
        if (isOldAPIUsed == false) {
          try {
            paramsUser = await this.communication.post("ParametresUtilisateur", data: {'donnees': {}});

            this.communication.authorizedTabs = prepareTabs(paramsUser['donneesSec']['donnees']['listeOnglets']);
            this.stepsLogger.add("✅ Prepared tabs");

            try {
              CreateStorage("classe", paramsUser['donneesSec']['donnees']['ressource']["classeDEleve"]["L"] ?? "");
              CreateStorage("userFullName", paramsUser['donneesSec']['donnees']['ressource']["L"] ?? "");
              actualUser = paramsUser['donneesSec']['donnees']['ressource']["L"];
            } catch (e) {
              this.stepsLogger.add("❌ Failed to register UserInfos");

              print("Failed to register UserInfos");
              print(e);
            }
          } catch (e) {
            this.stepsLogger.add("ⓘ Using old api ");

            print("Surely using OLD API");
          }
        }

        print("Successfully logged in as ${this.username}");
        return true;
      } else {
        print("Login failed");
        return false;
      }
    } catch (e) {
      throw ("Error during after auth " + e.toString());
    }
  }

  keepAlive() {
    return KeepAlive();
  }

  downloadUrl(Document document) {
    try {
      Map data = {"N": document.id, "G": int.parse(document.type)};
      //Used by pronote to encrypt the data (I don't know why)
      var magic_stuff = this.encryption.aesEncryptFromString(conv.jsonEncode(data));
      String libelle = Uri.encodeComponent(Uri.encodeComponent(document.documentName));
      String url = this.communication.rootSite +
          '/FichiersExternes/' +
          magic_stuff +
          '/' +
          libelle +
          '?Session=' +
          this.attributes['h'].toString();

      return url;
    } catch (e) {
      print(e);
    }
  }

  homework(DateTime date_from, {DateTime date_to}) async {
    print(date_from);
    if (date_to == null) {
      final f = new DateFormat('dd/MM/yyyy');
      date_to = f.parse(this.funcOptions['donneesSec']['donnees']['General']['DerniereDate']['V']);
    }
    var json_data = {
      'donnees': {
        'domaine': {'_T': 8, 'V': "[${await get_week(date_from)}..${await get_week(date_to)}]"}
      },
      '_Signature_': {'onglet': 88}
    };
    var response = await this.communication.post("PageCahierDeTexte", data: json_data);
    var json_data_contenu = {
      'donnees': {
        'domaine': {'_T': 8, 'V': "[${1}..${62}]"}
      },
      '_Signature_': {'onglet': 89}
    };
    //Get "Contenu de cours"
    var responseContent = await this.communication.post("PageCahierDeTexte", data: json_data_contenu);

    var c_list = responseContent['donneesSec']['donnees']['ListeCahierDeTextes']['V'];
    //Content homework
    List<Homework> listCHW = List();

    c_list.forEach((h) {
      List<Document> listDocs = List();
      //description
      String description = "";
      h["listeContenus"]["V"].forEach((value) {
        if (value["descriptif"]["V"] != null) {
          description += value["descriptif"]["V"] + "<br>";
        }
        try {
          value["ListePieceJointe"]["V"].forEach((pj) {
            try {
              downloadUrl(Document(pj["L"], pj["N"], pj["G"].toString(), 0));
            } catch (e) {}
          });
        } catch (e) {}
      });

      listCHW.add(Homework(
          h["Matiere"]["V"]["L"],
          h["Matiere"]["V"]["L"].hashCode.toString(),
          "",
          "",
          description,
          DateFormat("dd/MM/yyyy hh:mm:ss").parse(h["DateFin"]["V"]),
          DateFormat("dd/MM/yyyy hh:mm:ss").parse(h["Date"]["V"]),
          false,
          false,
          false,
          listDocs,
          listDocs,
          "",
          true));
    });

    //Homework(matiere, codeMatiere, idDevoir, contenu, contenuDeSeance, date, datePost, done, rendreEnLigne, interrogation, documents, documentsContenuDeSeance, nomProf)
    var homeworkList = response['donneesSec']['donnees']['ListeTravauxAFaire']['V'];
    List<Homework> parsedHomeworkList = List();
    homeworkList.forEach((h) {
      //set a generated ID (Pronote ID is never the same)
      String idDevoir =
          (DateFormat("dd/MM/yyyy").parse(h["PourLe"]["V"]).toString() + h["Matiere"]["V"]["L"]).hashCode.toString() +
              h["descriptif"]["V"].hashCode.toString();
      parsedHomeworkList.add(Homework(
          h["Matiere"]["V"]["L"],
          h["Matiere"]["V"]["L"].hashCode.toString(),
          idDevoir,
          h["descriptif"]["V"],
          null,
          DateFormat("dd/MM/yyyy").parse(h["PourLe"]["V"]),
          DateFormat("dd/MM/yyyy").parse(h["DonneLe"]["V"]),
          h["TAFFait"] ?? false,
          h["peuRendre"] ?? false,
          false,
          null,
          null,
          "",
          true));
    });
    parsedHomeworkList.forEach((homework) {
      try {
        homework.sessionRawContent = listCHW
            .firstWhere((content) => content.disciplineCode == homework.disciplineCode && content.date == homework.date)
            .sessionRawContent;
      } catch (e) {}
    });
    return parsedHomeworkList;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  List<PronotePeriod> periods() {
    print("GETTING PERIODS");
    //printWrapped(this.func_options['donneesSec']['donnees'].toString());

    var json;
    try {
      json = this.funcOptions['donneesSec']['donnees']['General']['ListePeriodes'];
    } catch (e) {
      print("ERROR WHILE PARSING JSON " + e.toString());
    }

    List<PronotePeriod> toReturn = List();
    json.forEach((j) {
      toReturn.add(PronotePeriod(this, j));
    });
    return toReturn;
  }

  polls() async {
    print("GETTING POLLS");
    Map data = {
      "_Signature_": {"onglet": 8},
    };
    var response = await this.communication.post('PageActualites', data: data);
    var listActus = response['donneesSec']['donnees']['listeActualites']["V"];
    List<PollInfo> listInfosPolls = List();
    listActus.forEach((element) {
      List<Document> documents = List();
      try {
        element["listePiecesJointes"]["V"].forEach((pj) {
          documents.add(Document(pj["L"], pj["N"], pj["G"], 0));
        });
      } catch (e) {}
      try {
        //PollInfo(this.auteur, this.datedebut, this.questions, this.read);

        List<String> questions = List();
        List<Map> choices = List();
        element["listeQuestions"]["V"].forEach((question) {
          questions.add(conv.jsonEncode(question));
        });
        listInfosPolls.add(PollInfo(
            element["elmauteur"]["V"]["L"],
            DateFormat("dd/MM/yyyy").parse(element["dateDebut"]["V"]),
            questions,
            element["lue"],
            element["L"],
            element["N"],
            documents,
            element));
      } catch (e) {
        print("Failed to add an element to the polls list " + e.toString());
      }
    });
    return listInfosPolls;
  }

  setPollRead(String meta) async {
    var user = this.paramsUser['donneesSec']['donnees']['ressource'];
    print(user);
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
    print(data);
    var response = await this.communication.post('SaisieActualites', data: data);
    print(response);
  }

  setPollResponse(String meta) async {
    try {
      List metas = meta.split("/ynsplit");
      var user = this.paramsUser['donneesSec']['donnees']['ressource'];
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
      print(data);
      var response = await this.communication.post('SaisieActualites', data: data);
      print(response);
    } catch (e) {
      print(e);
    }
  }

  lessons(DateTime date_from, {DateTime date_to}) async {
    initializeDateFormatting();
    var user = this.paramsUser['donneesSec']['donnees']['ressource'];
    List<Lesson> listToReturn = List();
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
    print(firstWeek);
    if (date_to == null) {
      date_to = date_from;
    }
    var lastWeek = await get_week(date_to);
    for (int week = firstWeek; lastWeek < lastWeek + 1; ++lastWeek) {
      data["donnees"]["NumeroSemaine"] = lastWeek;
      data["donnees"]["numeroSemaine"] = lastWeek;

      var response = await this.communication.post('PageEmploiDuTemps', data: data);

      var lessonsList = response['donneesSec']['donnees']['ListeCours'];
      lessonsList.forEach((lesson) {
        try {
          //Lesson(String room, List<String> teachers, DateTime start, int duration, bool canceled, String status, List<String> groups, String content, String matiere, String codeMatiere)
          String room;
          try {
            var roomContainer = lesson["ListeContenus"]["V"].firstWhere((element) => element["G"] == 17);
            room = roomContainer["L"];
          }
          //Sort of null aware
          catch (e) {}

          List<String> teachers = List();
          try {
            lesson["ListeContenus"]["V"].forEach((element) {
              if (element["G"] == 3) {
                teachers.add(element["L"]);
              }
            });
          } catch (e) {}

          DateTime start = DateFormat("dd/MM/yyyy HH:mm:ss", "fr_FR").parse(lesson["DateDuCours"]["V"]);
          DateTime end = start.add(Duration(minutes: this.oneHourDuration * lesson["duree"]));
          int duration = this.oneHourDuration * lesson["duree"];
          String matiere = lesson["ListeContenus"]["V"][0]["L"];
          String codeMatiere = lesson["ListeContenus"]["V"][0]["L"].hashCode.toString();
          String id = lesson["N"];
          String status;
          bool canceled = false;
          if (lesson["Statut"] != null) {
            status = lesson["Statut"];
          }
          if (lesson["estAnnule"] != null) {
            canceled = lesson["estAnnule"];
          }
          listToReturn.add(Lesson(
              room: room,
              teachers: teachers,
              start: start,
              end: end,
              duration: duration,
              canceled: canceled,
              status: status,
              discipline: matiere,
              id: id,
              disciplineCode: codeMatiere));
        } catch (e) {
          print("Error while getting lessons " + e.toString());
        }
      });
      print("Agenda collecte succeeded");
      return listToReturn;
    }
  }
}

removeAlea(String text) {
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

class Communication {
  var cookies;
  var client;
  var htmlPage;
  var rootSite;
  Encryption encryption;
  Map attributes;
  int requestNumber;
  List authorizedTabs;
  bool shouldCompressRequests;
  double lastPing;
  bool shouldEncryptRequests;
  var lastResponse;
  Requests session;
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

  Future<List<Object>> initialise() async {
    print("Getting hostname");
    // get rsa keys and session id
    String hostName = Requests.getHostname(this.rootSite + "/" + this.htmlPage);

    //set the cookies for ENT
    if (cookies != null) {
      print("Cookies set");
      Requests.setStoredCookies(hostName, this.cookies);
    }

    var headers = {
      'connection': 'keep-alive',
      'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/74.0'
    };
    String url = this.rootSite + "/" + this.htmlPage + (this.cookies != null ? "?fd=1" : "");
    if (url.contains("?login=true") || url.contains("?fd=1")) {
      url += "&fd=1";
    } else {
      url += "?fd=1";
    }
    print(url);
    this.client.stepsLogger.add("ⓘ" + " Used url is " + "`" + url + "`");
//?fd=1 bypass the old navigator issue
    var getResponse = await Requests.get(url, headers: headers).catchError((e) {
      this.client.stepsLogger.add("❌ Failed login request " + e.toString());
      throw ("Failed login request");
    });
    this.client.stepsLogger.add("✅ Posted login request");

    if (getResponse.hasError) {
      print("|pImpossible de se connecter à l'adresse fournie");
    }

    this.attributes = this.parseHtml(getResponse.content());
    this.client.stepsLogger.add("✅ Parsed HTML");
    //uuid
    this.encryption.rsaKeys = {'MR': this.attributes['MR'], 'ER': this.attributes['ER']};
    var uuid = conv.base64.encode(await this.encryption.rsaEncrypt(this.encryption.aesIVTemp.bytes));
    this.client.stepsLogger.add("✅ Encrypted IV");

    //uuid
    var jsonPost = {'Uuid': uuid, 'identifiantNav': null};
    print(this.attributes);
    this.shouldEncryptRequests = (this.attributes["sCrA"] == null);
    if (this.attributes["sCrA"] == null) {
      this.client.stepsLogger.add("ⓘ" + " Requests will be encrypted");
    }
    this.shouldCompressRequests = (this.attributes["sCoA"] == null);
    if (this.attributes["sCoA"] == null) {
      this.client.stepsLogger.add("ⓘ" + " Requests will be compressed");
    }
    var initialResponse = await this.post('FonctionParametres',
        data: {'donnees': jsonPost},
        decryptionChange: {'iv': hex.encode(md5.convert(this.encryption.aesIVTemp.bytes).bytes)});

    return [this.attributes, initialResponse];
  }

  parseHtml(String html) {
    var parsed = parse(html);
    var onload = parsed.getElementById("id_body");

    String onloadC;
    print(onload);
    if (onload != null) {
      onloadC = onload.attributes["onload"].substring(14, onload.attributes["onload"].length - 37);
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
    print(data);
    if (this.shouldCompressRequests) {
      print("Compress request");
      data = """{"donnees": {"Uuid": "${data["donnees"]["Uuid"]}", "identifiantNav": null}}""";
      print(data);
      var zlibInstance = ZLibCodec(level: 6, raw: true);
      data = zlibInstance.encode(conv.utf8.encode(hex.encode(conv.utf8.encode(data))));
      this.client.stepsLogger.add("✅ Compressed request");
    }
    if (this.shouldEncryptRequests) {
      print("Encrypt requests");
      data = encryption.aesEncrypt(data);
      this.client.stepsLogger.add("✅ Encrypted request");
    }
    var zlibInstance = ZLibCodec(level: 6, raw: true);
    var rNumber = encryption.aesEncrypt(conv.utf8.encode(this.requestNumber.toString()));

    var json = {
      'session': int.parse(this.attributes['h']),
      'numeroOrdre': rNumber,
      'nom': functionName,
      'donneesSec': data
    };
    print(json.toString());
    String p_site =
        this.rootSite + '/appelfonction/' + this.attributes['a'] + '/' + this.attributes['h'] + '/' + rNumber;
    //p_site = "http://192.168.1.99:3000/home";
    print(p_site);

    this.requestNumber += 2;
    if (requestNumber > 90) {
      await this.client.refresh();
    }

    var response = await Requests.post(p_site, json: json).catchError((onError) {
      print("Error occured during request : $onError");
    });

    this.lastPing = (DateTime.now().millisecondsSinceEpoch / 1000);
    this.lastResponse = response;
    if (response.hasError) {
      throw "Status code: ${response.statusCode}";
    }
    if (response.content().contains("Erreur")) {
      print("Error occured");
      print(response.content());
      var responseJson = response.json();

      if (responseJson["Erreur"]['G'] == 22) {
        throw error_messages["22"];
      }
      if (responseJson["Erreur"]['G'] == 10) {
        tlogin.details = "Connexion expirée";
        tlogin.actualState = loginStatus.error;

        throw error_messages["10"];
      }

      if (recursive != null && recursive) {
        throw "Unknown error from pronote: ${responseJson["Erreur"]["G"]} | ${responseJson["Erreur"]["Titre"]}\n$responseJson";
      }

      return await this.client.communication.post(functionName, data: data, recursive: true);
    }

    if (decryptionChange != null) {
      print("decryption change");
      if (decryptionChange.toString().contains("iv")) {
        print("decryption_change contains IV");
        this.encryption.aesIV = IV.fromBase16(decryptionChange["iv"]);
      }

      if (decryptionChange.toString().contains("key")) {
        print("decryption_change contains key");
        print(decryptionChange['key']);
        this.encryption.aesKey = decryptionChange['key'];
      }
    }

    Map responseData = response.json();

    if (this.shouldEncryptRequests) {
      responseData['donneesSec'] = this.encryption.aesDecryptAsBytes(hex.decode(responseData['donneesSec']));
      print("décrypté données sec");
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

  afterAuth(var authentificationResponse, var data, var authentificationKey) async {
    this.encryption.aesKey = authentificationKey;
    if (this.cookies == null) {
      var host = Requests.getHostname(authentificationResponse.url.toString());
      this.cookies = await Requests.getStoredCookies(host);
    }
    var work = this.encryption.aesDecrypt(hex.decode(data['donneesSec']['donnees']['cle']));
    try {
      this.authorizedTabs = prepareTabs(data['donneesSec']['donnees']['listeOnglets']);

      CreateStorage("classe", data['donneesSec']['donnees']['ressource']["classeDEleve"]["L"]);
      CreateStorage("userFullName", data['donneesSec']['donnees']['ressource']["L"]);
      isOldAPIUsed = true;
    } catch (e) {
      isOldAPIUsed = false;
      this.client.stepsLogger.add("ⓘ 2020 API");
      print("Surely using the 2020 API");
    }
    var key = md5.convert(toBytes(work));
    print("New key : $key");
    this.encryption.aesKey = key;
  }

  getRootAdress(addr) {
    return [
      (addr.split('/').sublist(0, addr.split('/').length - 1).join("/")),
      (addr.split('/').sublist(addr.split('/').length - 1, addr.split('/').length).join("/"))
    ];
  }

  toBytes(String string) {
    List<String> stringsList = string.split(',');
    List<int> ints = stringsList.map(int.parse).toList();
    return ints;
  }
}

prepareTabs(var tabsList) {
  List output = List();
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

class Encryption {
  IV aesIV;

  IV aesIVTemp;

  var aesKey;

  Map rsaKeys;

  Encryption() {
    this.aesIV = IV.fromLength(16);
    this.aesIVTemp = IV.fromSecureRandom(16);
    this.aesKey = generateMd5("");

    this.rsaKeys = {};
  }
  String generateMd5(String input) {
    return md5.convert(conv.utf8.encode(input)).toString();
  }

  aesEncrypt(List<int> data, {padding = true, disableIV = false}) {
    try {
      var iv;
      var key = Key.fromBase16(this.aesKey.toString());
      print("KEY :" + this.aesKey.toString());
      iv = this.aesIV;
      print(iv.base16);
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

  aesDecrypt(var data) {
    var key = Key.fromBase16(this.aesKey.toString());
    final aesEncrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    //generate AES CBC block encrypter with key and PKCS7 padding

    print(this.aesIV);

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

    print(this.aesIV);

    try {
      return aesEncrypter.decryptBytes(Encrypted.from64(conv.base64.encode(data)), iv: this.aesIV);
    } catch (e) {
      throw ("Error during decryption : $e");
    }
  }

  aesSetIV(var iv) {
    if (iv == null) {
      this.aesIV = IV.fromLength(16);
    } else {
      this.aesIV = iv;
    }
  }

  rsaEncrypt(Uint8List data) async {
    try {
      var modulusBytes = this.rsaKeys['MR'];

      var modulus = BigInt.parse(modulusBytes, radix: 16);

      var exponent = BigInt.parse(this.rsaKeys['ER'], radix: 16);
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
  Communication _connection;

  bool keepAlive;

  void init(Client client) {
    this._connection = client.communication;
    this.keepAlive = true;
  }

  void alive() async {
    while (this.keepAlive) {
      if (DateTime.now().millisecondsSinceEpoch / 1000 - this._connection.lastPing >= 300) {
        this._connection.post("Presence", data: {
          '_Signature_': {'onglet': 7}
        });
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

Uint8List int32BigEndianBytes(int value) => Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);

class PronotePeriod {
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

  PronotePeriod(Client client, Map parsedJson) {
    this._client = client;
    this.id = parsedJson['N'];
    this.name = parsedJson['L'];
    var inputFormat = DateFormat("dd/MM/yyyy");
    this.start = inputFormat.parse(parsedJson['dateDebut']['V']);
    this.end = inputFormat.parse(parsedJson['dateFin']['V']);
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

  ///Return the eleve average, the max average, the min average, and the class average
  average(var json, var codeMatiere) {
    //The services for the period
    List services = json['donneesSec']['donnees']['listeServices']['V'];
    //The average data for the given matiere

    var averageData = services.firstWhere((element) => element["L"].hashCode.toString() == codeMatiere);
    //print(averageData["moyEleve"]["V"]);

    return [
      gradeTranslate(averageData["moyEleve"]["V"]),
      gradeTranslate(averageData["moyMax"]["V"]),
      gradeTranslate(averageData["moyMin"]["V"]),
      gradeTranslate(averageData["moyClasse"]["V"])
    ];
  }

  shouldCountAsZero(String grade) {
    if (grade == "Absent zéro" || grade == "Non rendu zéro") {
      return true;
    } else
      return false;
  }

  grades(int codePeriode) async {
    //Get grades from the period.
    List<Grade> list = List();
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
    var response = await _client.communication.post('DernieresNotes', data: jsonData);
    var grades = mapGet(response, ['donneesSec', 'donnees', 'listeDevoirs', 'V']) ?? [];
    this.moyenneGenerale = gradeTranslate(mapGet(response, ['donneesSec', 'donnees', 'moyGenerale', 'V']) ?? "");
    this.moyenneGeneraleClasse =
        gradeTranslate(mapGet(response, ['donneesSec', 'donnees', 'moyGeneraleClasse', 'V']) ?? "");

    var other = List();
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
}

class PronoteLesson {
  String id;
  String teacherName;
  String classroom;
  bool canceled;
  String status;
  String backgroundColor;
  String outing;
  DateTime start;
  String groupName;
  var _content;
  Client _client;
  PronoteLesson(Client client, var parsedJson) {
    this._client = client;
    this._content = null;
  }
}
