part of pronote;

enum PronoteLoginWay { qrCodeLogin, casLogin, standardLogin }

class _Communication {
  late final String url;
  late final String urlRoot;
  late final String urlPath;
  _Encryption encryption = _Encryption();

  late double lastPing;
  final PronoteClient client;
  late bool encryptRequests;

  ///some Pronote servers (especially not updated self hosted servers) can use an old API version
  late bool legacyApi;

  late bool compressRequests;
  late Map attributes;

  late Map userParameters;

  //The request number needed for all requests
  int requestNumber = 1;
  //The list of tabs allowed by the present session
  List? authorizedTabs;

  _Communication(this.client) {
    url = client.url;
    final split = getRootAdress(url);
    urlRoot = split[0];
    urlPath = split[1];
  }

  afterAuth(var data) async {
    Response<String> keyRes = encryption.aesDecrypt(hex.decode(data['donneesSec']['donnees']['cle']));
    if (keyRes.hasError) {
      return Response(error: "Failed to decrypt key ${keyRes.error}");
    }
    //This request will surely fail will preparing tabs as it only exists on old API
    try {
      authorizedTabs = prepareTabs(data['donneesSec']['donnees']['listeOnglets']);

      KVS.write(key: "classe", value: data['donneesSec']['donnees']['ressource']["classeDEleve"]["L"]);
      KVS.write(key: "userFullName", value: data['donneesSec']['donnees']['ressource']["L"]);
      legacyApi = true;
    } catch (e) {
      legacyApi = false;
    }

    Digest key = md5.convert(utf8.encode(keyRes.data!));
    Logger.log("PRONOTE", "New key : $key");
    encryption.aesKey = Key(Uint8List.fromList(key.bytes));
  }

  Future<Response<List<Object>>> init() async {
    requestNumber = 1;
    final Map<String, String> headers = {
      'connection': 'keep-alive',
      'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/74.0'
    };
    final String url = "$urlRoot/$urlPath?fd=${client.isCas ? '1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335' : 1}";
    Logger.log("TWEAKED URL", url);
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      final res = parseHtml(response.body); // L94 legacy/communication.dart

      if (res.hasError) return Response(error: res.error);

      attributes = res.data!;
      final res0 = encryption.rsaEncrypt(encryption.aesIVTemp.bytes, {'MR': attributes['MR'], 'ER': attributes['ER']});
      if (res0.hasError) return Response(error: res0.error);
      final String uuid = base64.encode(res0.data!);
      final Map<String, dynamic> data = {
        "donnees": {"Uuid": uuid, "identifiantNav": ""}
      };
      encryptRequests = attributes["sCrA"] == null;
      compressRequests = attributes["sCoA"] == null;
      final initialResponse = await post("FonctionsParametres",
          data: data, decryptionChange: {"iv": hex.encode(md5.convert(encryption.aesIVTemp.bytes).bytes)});
      Logger.log("INIT", "Init successful");
      return Response(data: [attributes, initialResponse]);
    } catch (e) {
      Logger.log("INIT", "Fail to init $e");

      return Response(error: e.toString());
    }
  }

  login() async {
    try {
      Map indentJson = {
        "genreConnexion": 0,
        "genreEspace": int.parse(attributes['a']),
        "identifiant": client.username,
        "pourENT": client.isCas,
        "enConnexionAuto": false,
        "demandeConnexionAuto": false,
        "enConnexionAppliMobile": client.loginWay == PronoteLoginWay.casLogin,
        "demandeConnexionAppliMobile": client.loginWay == PronoteLoginWay.qrCodeLogin,
        "demandeConnexionAppliMobileJeton": client.loginWay == PronoteLoginWay.qrCodeLogin,
        "uuidAppliMobile": SettingsService.settings.global.uuid,
        "loginTokenSAV": ""
      };

      Response identificationResponse =
          await client.communication.post("Identification", data: {'donnees': indentJson});

      if (identificationResponse.hasError) {
        return Response(error: "Error during Identification ${identificationResponse.error}");
      }
      Map identificationData = identificationResponse.data;
      Logger.log("PRONOTE", "Identification");
      Logger.logWrapped("PRONOTE", "Identification", identificationData.toString());
      var challenge = identificationData['donneesSec']['donnees']['challenge'];

      dynamic postablePassword;

      if (client.loginWay != PronoteLoginWay.standardLogin) {
        List<int> encoded = utf8.encode(client.password);
        postablePassword = sha256.convert(encoded).bytes;
        postablePassword = hex.encode(postablePassword);
        postablePassword = postablePassword.toString().toUpperCase();
        client.encryption.aesKey = Key.fromBase16(hex.encode(md5.convert(utf8.encode(postablePassword)).bytes));
      } else {
        var u = client.username;
        var p = client.password;

        //Convert credentials to lowercase if needed (API returns 1)
        if (identificationData['donneesSec']['donnees']['modeCompLog'] != null &&
            identificationData['donneesSec']['donnees']['modeCompLog'] != 0) {
          Logger.log("PRONOTE", "LOWER CASE ID");
          Logger.log("PRONOTE", identificationData['donneesSec']['donnees']['modeCompLog'].toString());
          u = u.toString().toLowerCase();
        }

        if (identificationData['donneesSec']['donnees']['modeCompMdp'] != null &&
            identificationData['donneesSec']['donnees']['modeCompMdp'] != 0) {
          Logger.log("PRONOTE", "LOWER CASE PASSWORD");
          Logger.log("PRONOTE", identificationData['donneesSec']['donnees']['modeCompMdp'].toString());
          p = p.toString().toLowerCase();
        }

        var alea = identificationData['donneesSec']['donnees']['alea'];
        Logger.log("PRONOTE", alea);
        List<int> encoded = utf8.encode((alea ?? "") + p);
        postablePassword = sha256.convert(encoded);
        postablePassword = hex.encode(postablePassword.bytes);
        postablePassword = postablePassword.toString().toUpperCase();
        client.encryption.aesKey = Key.fromBase16(utf8.decode(md5.convert(utf8.encode(u + postablePassword)).bytes));
      }

      Response rawChallenge = client.encryption.aesDecrypt(hex.decode(challenge));

      if (rawChallenge.hasError) {
        return Response(error: "Error while AES decrypting " + rawChallenge.error!);
      }

      var rawChallengeWithoutAlea = removeAlea(rawChallenge.data);

      var encryptedChallenge = client.encryption.aesEncrypt(utf8.encode(rawChallengeWithoutAlea));

      Map authentificationJson = {
        "connexion": 0,
        "challenge": encryptedChallenge,
        "espace": int.parse(attributes['a'])
      };

      Response authResponse =
          await post("Authentification", data: {'donnees': authentificationJson, 'identifiantNav': ''});

      Map authResponseData = {};
      if (authResponse.hasError) {
        return Response(error: "Error during Authentification ${authResponse.error}");
      } else {
        authResponseData = authResponse.data;
      }

      if ((client.loginWay != PronoteLoginWay.standardLogin) &&
          authResponseData['donneesSec']['donnees']["jetonConnexionAppliMobile"] != null) {
        Logger.log("PRONOTE", "Saving token");
        String newPassword = authResponseData['donneesSec']['donnees']["jetonConnexionAppliMobile"];

        Map<String, dynamic> newCredentials = {
          "password": newPassword,
          "username": client.username,
          "parameters:": client.parameters
        };

        client.password = newPassword;
        _setCredentials(newCredentials);
      }
      if (authResponseData['donneesSec']['donnees'].toString().contains("cle")) {
        await afterAuth(authResponseData);

        if (legacyApi == false) {
          try {
            Response parameters = await post("ParametresUtilisateur", data: {'donnees': {}});
            if (parameters.hasError) {
              return Response(error: "Failed to get user parameters ${parameters.error}");
            }
            encryption.aesKey = encryption.aesKey;

            authorizedTabs = prepareTabs(safeMapGetter(userParameters, ['donneesSec', 'donnees', 'listeOnglets']));

            try {
              KVS.write(
                  key: "classe",
                  value: safeMapGetter(userParameters, ['donneesSec', 'donnees', 'ressource', "classeDEleve", "L"]));
              KVS.write(
                  key: "userFullName",
                  value: safeMapGetter(userParameters, ['donneesSec', 'donnees', 'ressource', "L"]));
            } catch (e) {
              Logger.log("PRONOTE", "Failed to register UserInfos");
              Logger.error(e, stackHint: "MTY=");
            }
          } catch (e) {
            Logger.log("PRONOTE", "Surely using OLD API");
          }
        }

        Logger.log("PRONOTE", "Successfully logged in as ${client.username}");

        final Map<String, dynamic> map = {
          "appAccount": AppAccount(entityId: "", lastName: "", firstName: ""),
          "schoolAccount": SchoolAccount(
              firstName: "Test",
              lastName: "Test",
              className: "Test",
              entityId: "test",
              profilePicture: "",
              school: "test")
        };
        return Response(data: map);
      } else {
        Logger.log("PRONOTE", "Login failed");
        return Response(error: "Login failed");
      }
    } catch (e) {
      return Response(error: "Error during Login " + e.toString());
    }
  }

  Response<Map<String, dynamic>> parseHtml(String html) {
    final parsed = parse(html);
    final body = parsed.getElementById("id_body");
    late String onLoad;
    if (body != null) {
      onLoad = body.attributes["onload"]!.substring(14, body.attributes["onload"]!.length - 37);
    } else {
      if (html.contains("IP")) {
        return Response(error: "IP suspended.");
      } else {
        return Response(error: "HTML page error.");
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

  Future<Response<Map<String, dynamic>>> post(String name,
      {dynamic data, Map<String, dynamic>? decryptionChange}) async {
    try {
      if (data != null && data is Map) {
        if (data["_Signature_"] != null &&
            !authorizedTabs.toString().contains(data['_Signature_']['onglet'].toString())) {
          return Response(error: "Action not permitted. (onglet is not normally accessible)");
        }
      }

      if (compressRequests) {
        data = jsonEncode(data);
        var zlibInstance = ZLibCodec(level: 6, raw: true);
        data = zlibInstance.encode(utf8.encode(hex.encode(utf8.encode(data))));
      }

      if (encryptRequests) {
        data = encryption.aesEncrypt(data).data;
      }

      String? rNumber = encryption.aesEncrypt(utf8.encode(requestNumber.toString())).data;


      Map<String, dynamic> requestJson = {
        'session': int.parse(attributes['h']),
        'numeroOrdre': rNumber ?? "",
        'nom': name,
        'donneesSec': data
      };
      Logger.log("REQUEST", "E");

      Logger.logWrapped("requestJson", "Test", requestJson.toString());
      String pSite = urlRoot + '/appelfonction/' + attributes['a'] + '/' + attributes['h'] + '/' + (rNumber ?? "");
      requestNumber += 2;


      try {
        final res = (await http.post(
          Uri.parse(pSite),
          body: jsonEncode(requestJson),
        ));


        final String resBody = _decodeBody(res);
        Logger.log("TEST", pSite);


        final Map<String, dynamic> json = jsonDecode(resBody);
        lastPing = (DateTime.now().millisecondsSinceEpoch / 1000);


        if (resBody.contains("Erreur")) {
          if (json["Erreur"]['G'] == 22) {
            return Response(error: "Connexion expirée");
          }
          if (json["Erreur"]['G'] == 10) {
            return Response(error: "Connexion expirée");
          }
          if (json["Erreur"]['G'] == 11) {
            return Response(error: "Page expirée");
          }
          if (decryptionChange != null) {
            if (decryptionChange.toString().contains("iv")) {
              encryption.aesIV = IV.fromBase16(decryptionChange['iv']);
            }

            if (decryptionChange.toString().contains("key")) {
              encryption.aesKey = decryptionChange['key'];
            }
          }
          Logger.log("REQUEST", "J");

          if (encryptRequests) {
            json['donneesSec'] = encryption.aesDecryptAsBytes(hex.decode(json['donneesSec']));
          }
          var zlibInstanceDecoder = ZLibDecoder(raw: true);
          if (compressRequests) {
            var toDecode = json['donneesSec'];
            json['donneesSec'] = utf8.decode(zlibInstanceDecoder.convert(toDecode));
          }
          if (json['donneesSec'].runtimeType == String) {
            try {
              json['donneesSec'] = jsonDecode(json['donneesSec']);
            } catch (e) {
              return Response(error: "JSON decode error");
            }
          }
        }
        return Response(data: json);
      } catch (e) {
        return Response(error: "Error occured during request : ${e.toString()}");
      }
    } catch (e) {
      return Response(error: "Error occured during request : ${e.toString()}");
    }
  }

  List<int> toBytes(String string) {
    List<String> stringsList = string.split(',');
    List<int> ints = stringsList.map(int.parse).toList();
    return ints;
  }

  Future<void> _setCredentials(Map<String, dynamic> credentials) async {
    await KVS.write(key: "credentials", value: json.encode(credentials));
  }
}
