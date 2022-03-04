part of pronote;

class _Communication {
  late final String url;
  late final String urlRoot;
  late final String urlPath;
  _Encryption encryption = _Encryption();
  late double lastPing;
  final PronoteClient client;
  late bool encryptRequests;
  late bool compressRequests;

  Map? attributes;
  //The request number needed for all requests
  late int requestNumber;
  //The list of tabs allowed by the present session
  List? authorizedTabs;

  _Communication(this.client) {
    url = client.url;
    final split = splitAdress(url);
    urlRoot = split[0];
    urlPath = split[1];
  }

  Future<Response<List<Object>>> init() async {
    final Map<String, String> headers = {
      'connection': 'keep-alive',
      'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/74.0'
    };
    final String url = "$urlRoot/?fd=${client.isCas ? '1&bydlg=A6ABB224-12DD-4E31-AD3E-8A39A1C2C335' : 1}";
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      final res = parseHtml(response.body); // L94 legacy/communication.dart
      if (res.error != null) return Response(error: res.error);
      final Map<String, dynamic> attributes = res.data!;
      final res0 = encryption.rsaEncrypt(encryption.aesIVTemp.bytes, {'MR': attributes['MR'], 'ER': attributes['ER']});
      if (res0.error != null) return Response(error: res0.error);
      final String uuid = base64.encode(res0.data!);
      final Map<String, dynamic> data = {
        "donnees": {
          {'Uuid': uuid, 'identifiantNav': null}
        }
      };
      encryptRequests = attributes["sCrA"] == null;
      compressRequests = attributes["sCoA"] == null;
      final initialResponse = await post("FonctionsParametres",
          data: data, decryptionChange: {"iv": hex.encode(md5.convert(encryption.aesIVTemp.bytes).bytes)});
      return Response(data: [attributes, initialResponse]);
    } catch (e) {
      return Response(error: e.toString());
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
        return const Response(error: "IP suspended.");
      } else {
        return const Response(error: "HTML page error.");
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
    if (data != null && data is Map) {
      if (data["_Signature_"] != null &&
          !authorizedTabs.toString().contains(data['_Signature_']['onglet'].toString())) {
        return const Response(error: "Action not permitted. (onglet is not normally accessible)");
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

    var request_json = {
      'session': int.parse(attributes!['h']),
      'numeroOrdre': rNumber,
      'nom': name,
      'donneesSec': data
    };
    String pSite = urlRoot + '/appelfonction/' + attributes!['a'] + '/' + attributes!['h'] + '/' + (rNumber ?? "");

    requestNumber += 2;

    final res = await http.post(Uri.parse(pSite), body: request_json).catchError((onError) {
      return Response(error: "Error occured during request : ${onError.toString()}");
    });

    final String resBody = _decodeBody(res);
    final Map<String, dynamic> json = jsonDecode(resBody);

    lastPing = (DateTime.now().millisecondsSinceEpoch / 1000);

    if (resBody.contains("Erreur")) {
      if (json["Erreur"]['G'] == 22) {
        return Response(error: "Connexion expirée");
      }
      if (json["Erreur"]['G'] == 10) {
        /*
        appSys.loginController.details = "Connexion expirée";
        appSys.loginController.actualState = loginStatus.error;*/

        return const Response(error: "Connexion expirée");
      }

      if (decryptionChange != null) {
        if (decryptionChange.toString().contains("iv")) {
          encryption.aesIV = IV.fromBase16(decryptionChange['iv']);
        }

        if (decryptionChange.toString().contains("key")) {
          encryption.aesKey = decryptionChange['key'];
        }
      }

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
          return const Response(error: "JSON decode error");
        }
      }
    }
    return Response(data: json);
  }
}
