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

  _Communication(this.client) {
    url = client.url;
    final split = Utils.splitAdress(url);
    urlRoot = split[0];
    urlPath = split[1];
  }

  Future<Response<Map<String, dynamic>>> post(String name,
      {Map<String, dynamic>? data, Map<String, dynamic>? decryptionChange}) async {
    return Response(error: "Not implemented");
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
}
