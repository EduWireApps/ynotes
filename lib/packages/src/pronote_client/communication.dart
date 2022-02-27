part of pronote_client;
/*
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
      Logger.log("PRONOTE", "Surely using the 2020 API");
    }
    var key = md5.convert(toBytes(work));
    Logger.log("PRONOTE", "New key : $key");
    encryption.aesKey = key;
  }

  getRootAdress(addr) {
    return [
      (addr.split('/').sublist(0, addr.split('/').length - 1).join("/")),
      (addr.split('/').sublist(addr.split('/').length - 1, addr.split('/').length).join("/"))
    ];
  }

  Future<List<Object?>> initialise() async {
    Logger.log("PRONOTE", "Getting hostname");
    // get rsa keys and session id
    String hostName = Requests.getHostname(rootSite + "/" + htmlPage);

    //set the cookies for ENT
    if (cookies != null) {
      Logger.log("PRONOTE", "Cookies set");
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
    Logger.log("PRONOTE", "Url is $url");
    client.stepsLogger.add("ⓘ Used url is `$url`");
    Logger.log("PRONOTE", (client.mobileLogin ?? false) ? "CAS" : "NOT CAS");
//?fd=1 bypass the old navigator issue
    var getResponse = await Requests.get(url, headers: headers).catchError((e) {
      client.stepsLogger.add("❌ Failed login request " + e.toString());
      throw ("Failed login request");
    });
    client.stepsLogger.add("✅ Posted login request");

    if (getResponse.hasError) {
      Logger.log("PRONOTE", "|pImpossible de se connecter à l'adresse fournie");
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
    Logger.log("PRONOTE", onload.toString());
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
      Logger.log("PRONOTE", "Compress request");
      data = conv.jsonEncode(data);

      Logger.log("PRONOTE", data);
      var zlibInstance = ZLibCodec(level: 6, raw: true);
      data = zlibInstance.encode(conv.utf8.encode(conv.hex.encode(conv.utf8.encode(data))));
      client.stepsLogger.add("✅ Compressed request");
    }
    if (shouldEncryptRequests) {
      Logger.log("PRONOTE", "Encrypt requests");
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
    Logger.log("PRONOTE", pSite);

    requestNumber += 2;
    Logger.log("PRONOTE", json.toString());
    var response = await Requests.post(pSite, json: json).catchError((onError) {
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

    if (shouldEncryptRequests) {
      responseData['donneesSec'] = encryption.aesDecryptAsBytes(conv.hex.decode(responseData['donneesSec']));
      Logger.log("PRONOTE", "décrypté données sec");
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
*/