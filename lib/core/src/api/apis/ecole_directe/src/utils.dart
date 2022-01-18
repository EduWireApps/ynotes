part of ecole_directe;

String _encodeBody(Map<String, dynamic>? body) {
  body ??= {};
  return "data=${jsonEncode(body)}";
}

String _decodeBody(http.Response res) => const Utf8Decoder().convert(res.bodyBytes);

Future<Response<Map<String, dynamic>>> _request(SchoolApi api,
    {required String url, Map<String, dynamic>? body, Map<String, String>? headers, bool auth = true}) async {
  if (auth && api.authModule.status == AuthStatus.unauthenticated) {
    return const Response(error: "Not authenticated");
  }
  return await handleNetworkError(() async {
    final String _body = _encodeBody(body);
    headers ??= {};
    headers!["Content-type"] = "text/plain";
    if (auth) {
      headers!["X-Token"] = _token!;
    }
    final res = await http.post(Uri.parse("$_baseUrl$url"), headers: headers, body: _body);
    if (res.statusCode == 200) {
      final String resBody = _decodeBody(res);
      final Map<String, dynamic> json = jsonDecode(resBody);
      if (json["code"] != 200) {
        if (json["message"] == "Token invalide !") {
          await api.authModule.loginFromOffline();
          return await _request(api, url: url, body: body, headers: headers, auth: false);
        }
        return Response(error: json["message"]);
      }
      return Response(data: json);
    }
    return Response(error: res.reasonPhrase ?? "Unknown error");
  });
}

String parseHtml(String str) =>
    html_parser.parse(str).documentElement!.text.replaceAll("\n\n", ". ").replaceAll("\n", "");

List<X> getDifference<X>(List<X> x, List<X> y) {
  final int lx = x.length;
  final int ly = y.length;
  if (lx == ly) {
    return [];
  }
  final List<X> l1 = lx > ly ? x : y;
  final List<X> l2 = lx > ly ? y : x;
  return l1.toSet().difference(l2.toSet()).toList();
}

String encodeContent(String str) => base64Encode(utf8.encode(HtmlCharacterEntities.encode(str,
    characters: "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿŒœŠšŸƒˆ˜")));

String decodeContent(String str) => HtmlCharacterEntities.decode(utf8.decode(base64Decode(str)));
