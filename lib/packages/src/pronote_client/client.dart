part of pronote_client;
/*
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
    Logger.log("PRONOTE", "Initiate communication");

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
      if (url != null) Logger.log("PRONOTE", url);
      return url;
    } catch (e) {
      Logger.error(e, stackHint:"Mg==");
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
          packageInfo.buildNumber);
    }
    var attributesandfunctions = await communication!.initialise();
    stepsLogger.add("✅ Initialized");

    attributes = attributesandfunctions[0];
    funcOptions = attributesandfunctions[1];

    if (attributes["e"] != null && attributes["f"] != null) {
      Logger.log("PRONOTE", "LOGIN AS ENT");
      ent = true;
    } else {
      Logger.log("PRONOTE", "LOGIN AS REGULAR USER");
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
          Logger.error(e, stackHint:"Mw==");
        }
      });
      Logger.log("PRONOTE", "Agenda collecte succeeded");
      return listToReturn;
    }*/
  }

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

  setPollRead(String meta) async {
    var user = paramsUser?['donneesSec']['donnees']['ressource'];
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
      var user = paramsUser?['donneesSec']['donnees']['ressource'];
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
      Logger.log("PRONOTE", response);
    } catch (e) {
      Logger.error(e, stackHint:"NA==");
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

      Logger.log("PRONOTE", "Saved credentials");
    } catch (e) {
      Logger.log("PRONOTE", "failed to write values");
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
        Logger.log("PRONOTE", "LOWER CASE ID");
        Logger.log("PRONOTE", idr['donneesSec']['donnees']['modeCompLog'].toString());
        u = u.toString().toLowerCase();
        stepsLogger.add("ⓘ Lowercased id");
      }

      if (idr['donneesSec']['donnees']['modeCompMdp'] != null && idr['donneesSec']['donnees']['modeCompMdp'] != 0) {
        Logger.log("PRONOTE", "LOWER CASE PASSWORD");
        Logger.log("PRONOTE", idr['donneesSec']['donnees']['modeCompMdp'].toString());
        p = p.toString().toLowerCase();
        stepsLogger.add("ⓘ Lowercased password");
      }

      var alea = idr['donneesSec']['donnees']['alea'];
      Logger.log("PRONOTE", alea);
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
      Logger.log("PRONOTE", "Authentification");
      authResponse =
          await communication!.post("Authentification", data: {'donnees': authentificationJson, 'identifiantNav': ''});
    } catch (e) {
      stepsLogger.add("❌  Authentification failed : " + e.toString());
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

            communication!.authorizedTabs = prepareTabs(paramsUser?['donneesSec']['donnees']['listeOnglets']);

            stepsLogger.add("✅ Prepared tabs");

            try {
              KVS.write(key: "classe", value: paramsUser?['donneesSec']['donnees']['ressource']["classeDEleve"]["L"]);
              KVS.write(key: "userFullName", value: paramsUser?['donneesSec']['donnees']['ressource']["L"]);
            } catch (e) {
              stepsLogger.add("❌ Failed to register UserInfos");

              Logger.log("PRONOTE", "Failed to register UserInfos");
              Logger.error(e, stackHint:"NQ==");
            }
          } catch (e) {
            stepsLogger.add("ⓘ Using old api ");

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
*/