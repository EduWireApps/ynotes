part of pronote;

///Communication class used to send requests to Pronote
class Communication {
  dynamic cookies;
  late PronoteClient client;
  late final String url;

  late final String urlPath;
  late final String urlRoot;

  Encryption encryption = Encryption();

  ///some Pronote servers (especially not updated self hosted servers) can use an old API version
  late bool legacyApi;

  late Map attributes;
  late int requestNumber;
  List? authorizedTabs;
  late bool compressRequests;
  late double lastPing;
  late bool encryptRequests;
  req.Response? lastResponse;

  Communication(this.client) {
    url = client.url;
    urlRoot = getRootAdress(url)[0];
    urlPath = getRootAdress(url)[1];

    attributes = {};
    requestNumber = 1;
    lastPing = 0;
    authorizedTabs = [];
    compressRequests = false;
    encryptRequests = false;
    lastResponse = null;
  }

  Future<Response> afterAuth(Map data, Key authentificationKey) async {
    try {
      encryption.aesKey = authentificationKey;
      if (cookies == null) {
        var host = req.Requests.getHostname(lastResponse!.url.toString());
        cookies = await req.Requests.getStoredCookies(host);
      }
      Response<String> keyRes = encryption.aesDecrypt(hex.decode(data['donneesSec']['donnees']['cle']));
      if (keyRes.hasError) {
        Logger.error(keyRes.error);
        return Response(error: PronoteContent.loginErrors.unexpectedError + " (key decryption)");
      }
      try {
        authorizedTabs = prepareTabs(data['donneesSec']['donnees']['listeOnglets']);

        KVS.write(key: "classe", value: data['donneesSec']['donnees']['ressource']["classeDEleve"]["L"]);
        KVS.write(key: "userFullName", value: data['donneesSec']['donnees']['ressource']["L"]);
        legacyApi = true;
      } catch (e) {
        legacyApi = false;
        Logger.log("PRONOTE", "Surely using the 2020 API");
      }
      Digest key = md5.convert(toBytes(keyRes.data!));
      Logger.log("PRONOTE", "New key : $key");
      encryption.aesKey = Key(Uint8List.fromList(key.bytes));
      return Response();
    } catch (e) {
      Logger.error(e);
      return Response(error: PronoteContent.loginErrors.unexpectedError + " (after auth)");
    }
  }

  getRootAdress(addr) {
    return [
      (addr.split('/').sublist(0, addr.split('/').length - 1).join("/")),
      (addr.split('/').sublist(addr.split('/').length - 1, addr.split('/').length).join("/"))
    ];
  }

  Future<Response<List<Object>>> init() async {
    var headers = {
      'connection': 'keep-alive',
      'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/74.0'
    };

    final String url = "$urlRoot/$urlPath?fd=${client.isCas ? '1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335' : 1}";

    Logger.log("PRONOTE", "Url is $url");

    final response = await req.Requests.get(url, headers: headers);

    if (response.hasError) {
      Logger.log("PRONOTE", "|pImpossible de se connecter à l'adresse fournie");
    }

    final res = parseHtml(response.content()); // L94 legacy/communication.dart

    if (res.hasError) {
      Logger.error(res.error);
      return Response(error: res.error);
    }
    attributes = res.data!;

    //uuid
    final res0 = encryption.rsaEncrypt(encryption.aesIVTemp.bytes, {'MR': attributes['MR'], 'ER': attributes['ER']});
    if (res0.hasError) {
      Logger.error(res0.error);
      return Response(error: PronoteContent.loginErrors.unexpectedError + " (RSA encoding)");
    }
    final String uuid = base64.encode(res0.data!);

    var jsonPost = {'Uuid': uuid, 'identifiantNav': null};
    encryptRequests = (attributes["sCrA"] == null);
    if (attributes["sCrA"] == null) {}
    compressRequests = (attributes["sCoA"] == null);
    if (attributes["sCoA"] == null) {}
    var initialResponse = await post('FonctionParametres',
        data: {'donnees': jsonPost},
        decryptionChange: {'iv': hex.encode(md5.convert(encryption.aesIVTemp.bytes).bytes)});
    if (initialResponse.hasError) {
      Logger.error(initialResponse.error);
      return Response(error: PronoteContent.loginErrors.unexpectedError + " (fonction paramètres)");
    }
    return Response(data: [attributes, initialResponse.data]);
  }

  Response<Map<String, dynamic>> parseHtml(String html) {
    final parsed = parse(html);
    final body = parsed.getElementById("id_body");
    late String onLoad;
    if (body != null) {
      onLoad = body.attributes["onload"]!.substring(14, body.attributes["onload"]!.length - 37);
    } else {
      if (html.contains("IP")) {
        return Response(error: PronoteContent.loginErrors.ipSuspended);
      } else {
        return Response(error: PronoteContent.loginErrors.unexpectedError + " (HTML)");
      }
    }
    final Map<String, dynamic> attributes = {};
    for (final attribute in onLoad.split(',')) {
      final String key = attribute.split(':')[0];
      final dynamic value = attribute.split(':')[1];
      attributes[key] = value.toString().replaceAll("'", "");
    }
    return Response(data: attributes);
  }

  Future<Response> post(String functionName, {var data, Map<String, dynamic>? decryptionChange}) async {
    if (data != null && data! is String) {
      if (data["_Signature_"] != null &&
          !authorizedTabs.toString().contains(data['_Signature_']['onglet'].toString())) {
        throw ('Action not permitted. (onglet is not normally accessible)');
      }
    }

    if (compressRequests) {
      Logger.log("PRONOTE", "Compress request");
      data = jsonEncode(data);

      Logger.log("PRONOTE", data);
      var zlibInstance = ZLibCodec(level: 6, raw: true);
      data = zlibInstance.encode(utf8.encode(hex.encode(utf8.encode(data))));
    }
    if (encryptRequests) {
      Logger.log("PRONOTE", "Encrypt requests");
      data = encryption.aesEncrypt(data).data;
    }
    String? rNumber = encryption.aesEncrypt(utf8.encode(requestNumber.toString())).data;

    var json = {'session': int.parse(attributes['h']), 'numeroOrdre': rNumber, 'nom': functionName, 'donneesSec': data};
    String pSite = urlRoot + '/appelfonction/' + attributes['a'] + '/' + attributes['h'] + '/' + rNumber!;
    Logger.log("PRONOTE", pSite);

    requestNumber += 2;
    Logger.log("PRONOTE", json.toString());
    var response = await req.Requests.post(pSite, json: json).catchError((onError) {
      Logger.log("PRONOTE", "Error occured during request : $onError");
    });

    lastPing = (DateTime.now().millisecondsSinceEpoch / 1000);
    lastResponse = response;
    if (response.hasError) {
      throw "Status code: ${response.statusCode}";
    }
    if (response.content().contains("Erreur")) {
      Logger.log("PRONOTE", "Error occured");
      Logger.log("PRONOTE", response.content());
      var responseJson = response.json();

      if (responseJson["Erreur"]['G'] == 22) {
        return Response(error: PronoteContent.loginErrors.expiredConnexion);
      }
      if (responseJson["Erreur"]['G'] == 10) {
        return Response(error: PronoteContent.loginErrors.expiredConnexion);
      }
      Logger.error("Erreur while posting ${responseJson["Erreur"]}");
      return Response(error: PronoteContent.loginErrors.unexpectedError + " (post)");
    }

    if (decryptionChange != null) {
      Logger.log("PRONOTE", "decryption change");
      if (decryptionChange.toString().contains("iv")) {
        Logger.log("PRONOTE", "decryption_change contains IV");
        Logger.log("PRONOTE", decryptionChange['iv']);
        encryption.aesIV = IV.fromBase16(decryptionChange['iv']);
      }

      if (decryptionChange.toString().contains("key")) {
        Logger.log("PRONOTE", "decryption_change contains key");
        Logger.log("PRONOTE", decryptionChange['key']);
        encryption.aesKey = decryptionChange['key'];
      }
    }

    Map responseData = response.json();

    if (encryptRequests) {
      responseData['donneesSec'] = encryption.aesDecryptAsBytes(hex.decode(responseData['donneesSec']));
      Logger.log("PRONOTE", "décrypté données sec");
    }
    var zlibInstanceDecoder = ZLibDecoder(raw: true);
    if (compressRequests) {
      var toDecode = responseData['donneesSec'];
      responseData['donneesSec'] = utf8.decode(zlibInstanceDecoder.convert(toDecode));
    }
    if (responseData['donneesSec'].runtimeType == String) {
      try {
        responseData['donneesSec'] = jsonDecode(responseData['donneesSec']);
      } catch (e) {
        Logger.error("JSONDecodeError");
        return Response(error: PronoteContent.loginErrors.unexpectedError);
      }
    }
    return Response(data: responseData);
  }

  toBytes(String string) {
    List<String> stringsList = string.split(',');
    List<int> ints = stringsList.map(int.parse).toList();
    return ints;
  }
}

/*
class PronoteClient {
  dynamic username;
  dynamic password;
  dynamic pronoteUrl;
  Communication? communication;
  dynamic attributes;
  dynamic funcOptions;

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
    Logger.log("PRONOTE", "Initiate communication");

    communication = Communication(pronoteUrl, cookies, this);
  }
/*
  downloadUrl(Document document) {
    try {
      Map data = {"N": document.id, "G": int.parse(document.type!)};
      //Used by pronote to encrypt the data (I don't know why)
      var magicStuff = encryption.aesEncrypt(utf8.encode(jsonEncode(data)));
      String libelle = document.documentName ?? "";
      String? url = communication!.rootSite +
          '/FichiersExternes/' +
          magicStuff +
          '/' +
          libelle +
          '?Session=' +
          attributes['h'].toString();
      if (url != null) Logger.log("PRONOTE", url);
      return url;
    } catch (e) {
      CustomLogger.error(e);
    }
  }
*/
  Future<bool?> init() async {
    var attributesandfunctions = await communication!.init();

    attributes = attributesandfunctions[0];
    funcOptions = attributesandfunctions[1];

    if (attributes["e"] != null && attributes["f"] != null) {
      Logger.log("PRONOTE", "LOGIN AS ENT");
      ent = true;
    } else {
      Logger.log("PRONOTE", "LOGIN AS REGULAR USER");
      ent = false;
    }

    //fonctionParameters up encryption
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
    //fonctionParameters request
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
      Logger.log("PRONOTE", "Agenda collecte succeeded");
      return listToReturn;
    }*/
  }
/*
  List<PronotePeriod> periods() {
    Logger.log("PRONOTE", "GETTING PERIODS");
    dynamic json;
    try {
      json = funcOptions['donneesSec']['donnees']['General']['ListePeriodes'];
    } catch (e) {
      Logger.log("PRONOTE", "ERROR WHILE PARSING JSON " + e.toString());
    }

    List<PronotePeriod> toReturn = [];
    json.forEach((j) {
      toReturn.add(PronotePeriod(this, j));
    });
    return toReturn;
  }
*/

/*
  refresh() async {
    Logger.log("PRONOTE", "Reinitialisation");

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
    Logger.log("PRONOTE", "ohduration " + oneHourDuration.toString());

    expired = true;
  }
*/

/*
  fonctionParametersPollRead(String meta) async {
    var user = safeMapGetter(paramsUser, ['donneesSec', 'donnees', 'ressource']);
    Logger.log("PRONOTE", user);
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
    Logger.log("PRONOTE", response);
  }

  setPollResponse(String meta) async {
    try {
      List metas = meta.split("/ynsplit");
      var user = safeMapGetter(paramsUser, ['donneesSec', 'donnees', 'ressource']);
      Map mapData = jsonDecode(metas[0]);
      Map pollMapData = jsonDecode(metas[1]);
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
      Logger.log("PRONOTE", response);
    } catch (e) {
      CustomLogger.error(e);
    }
  }
*/
  _login() async {
    try {
    
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
      "uuidAppliMobile": SettingsService.settings.global.uuid,
      "loginTokenSAV": ""
    };

   Response identificationResponse =
          await communication.post("Identification", data: {'donnees': indentJson});
    Logger.log("PRONOTE", "Identification");
    Logger.log(
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
      List<int> encoded = utf8.encode(password);
      motdepasse = sha256.convert(encoded).bytes;
      motdepasse = hex.encode(motdepasse);
      motdepasse = motdepasse.toString().toUpperCase();
      e.aesKey = hex.encode(md5.convert(utf8.encode(motdepasse)).bytes);
    } else {
      var u = username;
      var p = password;

      //Convert credentials to lowercase if needed (API returns 1)
      if (idr['donneesSec']['donnees']['modeCompLog'] != null && idr['donneesSec']['donnees']['modeCompLog'] != 0) {
        Logger.log("PRONOTE", "LOWER CASE ID");
        Logger.log("PRONOTE", idr['donneesSec']['donnees']['modeCompLog'].toString());
        u = u.toString().toLowerCase();
      }

      if (idr['donneesSec']['donnees']['modeCompMdp'] != null && idr['donneesSec']['donnees']['modeCompMdp'] != 0) {
        Logger.log("PRONOTE", "LOWER CASE PASSWORD");
        Logger.log("PRONOTE", idr['donneesSec']['donnees']['modeCompMdp'].toString());
        p = p.toString().toLowerCase();
      }

      var alea = idr['donneesSec']['donnees']['alea'];
      Logger.log("PRONOTE", alea);
      List<int> encoded = utf8.encode((alea ?? "") + p);
      motdepasse = sha256.convert(encoded);
      motdepasse = hex.encode(motdepasse.bytes);
      motdepasse = motdepasse.toString().toUpperCase();
      e.aesKey = md5.convert(utf8.encode(u + motdepasse));
    }

    var rawChallenge = e.aesDecrypt(hex.decode(challenge));

    var rawChallengeWithoutAlea = removeAlea(rawChallenge);

    var encryptedChallenge = e.aesEncrypt(utf8.encode(rawChallengeWithoutAlea));

    Map authentificationJson = {"connexion": 0, "challenge": encryptedChallenge, "espace": int.parse(attributes['a'])};

    try {
      Logger.log("PRONOTE", "Authentification");
      authResponse =
          await communication!.post("Authentification", data: {'donnees': authentificationJson, 'identifiantNav': ''});
    } catch (e) {
      throw ("Error during auth" + e.toString());
    }

    try {
      if ((mobileLogin == true || qrCodeLogin == true) &&
          authResponse['donneesSec']['donnees']["jetonConnexionAppliMobile"] != null) {
        Logger.log("PRONOTE", "Saving token");
        await KVS.write(key: "password", value: authResponse['donneesSec']['donnees']["jetonConnexionAppliMobile"]);
        password = authResponse['donneesSec']['donnees']["jetonConnexionAppliMobile"];
      }
      if (authResponse['donneesSec']['donnees'].toString().contains("cle")) {
        await communication!.afterAuth(communication!.lastResponse, authResponse, e.aesKey);
        if (isOldAPIUsed == false) {
          try {
            paramsUser = await communication!.post("ParametresUtilisateur", data: {'donnees': {}});
            encryption.aesKey = communication?.encryption.aesKey;

            communication!.authorizedTabs =
                prepareTabs(safeMapGetter(paramsUser, ['donneesSec', 'donnees', 'listeOnglets']));

            try {
              KVS.write(
                  key: "classe",
                  value: safeMapGetter(paramsUser, ['donneesSec', 'donnees', 'ressource', "classeDEleve", "L"]));
              KVS.write(
                  key: "userFullName", value: safeMapGetter(paramsUser, ['donneesSec', 'donnees', 'ressource', "L"]));
            } catch (e) {
              Logger.log("PRONOTE", "Failed to register UserInfos");
              CustomLogger.error(e);
            }
          } catch (e) {
            Logger.log("PRONOTE", "Surely using OLD API");
          }
        }

        Logger.log("PRONOTE", "Successfully logged in as $username");
        return true;
      } else {
        Logger.log("PRONOTE", "Login failed");
        return false;
      }
    } catch (e) {
      throw ("Error during after auth " + e.toString());
    }
  }
}

enum PronoteLoginWay { qrCodeLogin, casLogin, standardLogin }
/*
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
    //Logger.log("PRONOTE", averageData["moyEleve"]["V"]);

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
    var grades = safeMapGetter(response, ['donneesSec', 'donnees', 'listeDevoirs', 'V']) ?? [];
    moyenneGenerale = gradeTranslate(safeMapGetter(response, ['donneesSec', 'donnees', 'moyGenerale', 'V']) ?? "");
    moyenneGeneraleClasse = gradeTranslate(safeMapGetter(response, ['donneesSec', 'donnees', 'moyGeneraleClasse', 'V']) ?? "");

    var other = [];
    grades.forEach((element) async {
      list.add(Grade(
          value: gradeTranslate(safeMapGetter(element, ["note", "V"]) ?? ""),
          testName: element["commentaire"],
          periodCode: id,
          periodName: name,
          disciplineCode: (safeMapGetter(element, ["service", "V", "L"]) ?? "").hashCode.toString(),
          subdisciplineCode: null,
          disciplineName: safeMapGetter(element, ["service", "V", "L"]),
          letters: (safeMapGetter(element, ["note", "V"]) ?? "").contains("|"),
          weight: safeMapGetter(element, ["coefficient"]).toString(),
          scale: safeMapGetter(element, ["bareme", "V"]),
          min: gradeTranslate(safeMapGetter(element, ["noteMin", "V"]) ?? ""),
          max: gradeTranslate(safeMapGetter(element, ["noteMax", "V"]) ?? ""),
          classAverage: gradeTranslate(safeMapGetter(element, ["moyenne", "V"]) ?? ""),
          date: safeMapGetter(element, ["date", "V"]) != null ? DateFormat("dd/MM/yyyy").parse(element["date"]["V"]) : null,
          notSignificant: gradeTranslate(safeMapGetter(element, ["note", "V"]) ?? "") == "NonNote",
          testType: "Interrogation",
          entryDate: safeMapGetter(element, ["date", "V"]) != null
              ? DateFormat("dd/MM/yyyy").parse(safeMapGetter(element, ["date", "V"]))
              : null,
          countAsZero: shouldCountAsZero(gradeTranslate(safeMapGetter(element, ["note", "V"]) ?? ""))));
      other.add(average(response, (safeMapGetter(element, ["service", "V", "L"]) ?? "").hashCode.toString()));
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
*/*/