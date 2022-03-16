part of pronote;

class PronoteClient {
  final Map parameters;
  String username;
  String password;
  late String url;
  late PronoteLoginWay loginWay;

  late bool isCas; // either using qrcode or mobileLogin

  double? lastPing;
  late Map fonctionParameters;
  late Map userParameters;

  late final Communication communication;
  late Encryption encryption;
  late DateTime startDay;
  late DateTime currentDate;
  late DateTime hourStart;

  late DateTime hourEnd;
  late int oneHourDuration;

  late int currentWeek;

  late Map<String, dynamic> attributes;

  PronoteClient({required this.username, required this.password, required this.parameters}) {
    Logger.log("URL", parameters["url"]);
    url = parameters["url"];

    PronoteLoginWay _loginWay() {
      switch (parameters["loginWay"]) {
        case "qr":
          return PronoteLoginWay.qrCodeLogin;
        case "cas":
          return PronoteLoginWay.casLogin;
        default:
          return PronoteLoginWay.standardLogin;
      }
    }

    loginWay = _loginWay();
    isCas = loginWay != PronoteLoginWay.standardLogin;
    communication = Communication(this);
  }

  init() async {
    try {
      Response<List<Object>> communicationInitReq = await communication.init();
      if (communicationInitReq.hasError) return Response(error: "Error while initing");
      List communicationInitData = communicationInitReq.data!;

      attributes = communicationInitData[0];
      fonctionParameters = communicationInitData[1];

      //set up encryption
      encryption = Encryption();
      encryption.aesIV = communication.encryption.aesIV;
      //some other attribute creation
      lastPing = DateTime.now().millisecondsSinceEpoch / 1000;

      currentDate = DateTime.now();
      var inputFormat = DateFormat("dd/MM/yyyy");

      startDay = inputFormat.parse(fonctionParameters['donneesSec']['donnees']['General']['PremierLundi']['V']);

      await KVS.write(key: "startday", value: startDay.toString());
      currentWeek = await getWeek(DateTime.now());

      hourStart = DateFormat("hh'h'mm")
          .parse(fonctionParameters['donneesSec']['donnees']['General']['ListeHeures']['V'][0]['L']);
      hourEnd = DateFormat("hh'h'mm")
          .parse(fonctionParameters['donneesSec']['donnees']['General']['ListeHeuresFin']['V'][0]['L']);

      oneHourDuration = hourEnd.difference(hourStart).inMinutes;
      return Response();
    } catch (e) {
      return Response(error: "Error while initiating $e");
    }
  }

  Future<Response<Map>> login() async {
    try {
      if (isCas) {
        username = attributes['e'];
        password = attributes['f'];
      }
      Map indentJson = {
        "genreConnexion": 0,
        "genreEspace": int.parse(attributes['a']),
        "identifiant": username,
        "pourENT": isCas,
        "enConnexionAuto": false,
        "demandeConnexionAuto": false,
        "enConnexionAppliMobile": loginWay == PronoteLoginWay.casLogin,
        "demandeConnexionAppliMobile": loginWay == PronoteLoginWay.qrCodeLogin,
        "demandeConnexionAppliMobileJeton": loginWay == PronoteLoginWay.qrCodeLogin,
        "uuidAppliMobile": SettingsService.settings.global.uuid,
        "loginTokenSAV": ""
      };

      Response identificationResponse = await communication.post("Identification", data: {'donnees': indentJson});

      var idr = identificationResponse.data!;
      Logger.log("PRONOTE", "Identification");

      var challenge = idr['donneesSec']['donnees']['challenge'];
      var e = Encryption();

      e.setAesIV(communication.encryption.aesIV);
      dynamic motdepasse;

      if (isCas) {
        List<int> encoded = utf8.encode(password);
        motdepasse = sha256.convert(encoded).bytes;
        motdepasse = hex.encode(motdepasse);
        motdepasse = motdepasse.toString().toUpperCase();
        e.aesKey = Key.fromBase16(hex.encode(md5.convert(utf8.encode(motdepasse)).bytes));
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
        e.aesKey = Key(Uint8List.fromList(md5.convert(utf8.encode(u + motdepasse)).bytes));
      }

      Response<String> resRawChallenge = e.aesDecrypt(hex.decode(challenge));
      if (resRawChallenge.hasError) {
        return Response(error: "Failed to decrypt key ${resRawChallenge.error}");
      }
      String rawChallengeWithoutAlea = removeAlea(resRawChallenge.data!);

      Response<String> encryptedChallenge = e.aesEncrypt(utf8.encode(rawChallengeWithoutAlea));
      if (encryptedChallenge.hasError) return Response(error: "Failed to encrypt challenge");
      Map authentificationJson = {
        "connexion": 0,
        "challenge": encryptedChallenge.data!,
        "espace": int.parse(attributes['a'])
      };

      Map authResponseData = {};

      Logger.log("PRONOTE", "Authentification");
      Response authResponse =
          await communication.post("Authentification", data: {'donnees': authentificationJson, 'identifiantNav': ''});
      if (authResponse.hasError) {
        return Response(error: "Error during Authentification ${authResponse.error}");
      }
      authResponseData = authResponse.data;

      Logger.log("PRONOTE", "Authentification success");

      if (isCas && authResponseData['donneesSec']['donnees']["jetonConnexionAppliMobile"] != null) {
        Logger.log("PRONOTE", "Saving token");
        await KVS.write(key: "password", value: authResponseData['donneesSec']['donnees']["jetonConnexionAppliMobile"]);
        password = authResponseData['donneesSec']['donnees']["jetonConnexionAppliMobile"];
      }

      if (authResponseData['donneesSec']['donnees'].toString().contains("cle")) {
        Response afterAuthReq = await communication.afterAuth(authResponseData, e.aesKey);
        if (afterAuthReq.hasError) return Response(error: afterAuthReq.error);
        if (communication.legacyApi == false) {
          try {
            Response fonctionParametersReq = await communication.post("ParametresUtilisateur", data: {'donnees': {}});
            if (fonctionParametersReq.hasError) return Response(error: "Error while collecting ParametresUtilisateur");
            fonctionParameters = fonctionParametersReq.data!;
            encryption.aesKey = communication.encryption.aesKey;

            communication.authorizedTabs =
                prepareTabs(safeMapGetter(fonctionParameters, ['donneesSec', 'donnees', 'listeOnglets']));

            try {
              KVS.write(
                  key: "classe",
                  value:
                      safeMapGetter(fonctionParameters, ['donneesSec', 'donnees', 'ressource', "classeDEleve", "L"]));
              KVS.write(
                  key: "userFullName",
                  value: safeMapGetter(fonctionParameters, ['donneesSec', 'donnees', 'ressource', "L"]));
            } catch (e) {
              Logger.log("PRONOTE", "Failed to register UserInfos");
            }
          } catch (e) {
            Logger.log("PRONOTE", "Surely using OLD API");
          }
        }

        Logger.log("PRONOTE", "Successfully logged in as $username");
        return Response(
          data: fonctionParameters,
        );
      } else {
        Logger.log("PRONOTE", "Login failed");
        return Response(error: "Login failed (no details)");
      }
    } catch (e) {
      return Response(error: "Login failed $e");
    }
  }

  refresh() {
    communication = Communication(this);
  }
}

enum PronoteLoginWay { qrCodeLogin, casLogin, standardLogin }
