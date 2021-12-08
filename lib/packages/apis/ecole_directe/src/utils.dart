part of ecole_directe;

String _encodeBody(Map<String, String>? body, [String? token]) {
  body ??= {};
  if (token != null) {
    body['token'] = token;
  }
  return "data=${jsonEncode(body)}";
}

String _decodeBody(http.Response res) => const Utf8Decoder().convert(res.bodyBytes);

Future<Response<Map<String, dynamic>>> _request(SchoolApi api,
    {required String url, Map<String, String>? body, Map<String, String>? headers, bool auth = true}) async {
  if (auth && !api.authModule.authenticated) {
    return const Response(error: "Not authenticated");
  }
  return await handleNetworkError(() async {
    final String _body = _encodeBody(body, auth ? _token! : null);
    headers ??= {};
    headers!["Content-type"] = "text/plain";
    final res = await http.post(Uri.parse("$_baseUrl$url"), headers: headers, body: _body);
    if (res.statusCode == 200) {
      final String resBody = _decodeBody(res);
      final Map<String, dynamic> json = jsonDecode(resBody);
      if (json["code"] != 200) {
        if (json["message"] == "Token invalide !") {
          // TODO: load credentials
          await api.authModule.login(username: "", password: "");
          return await _request(api, url: url, body: body, headers: headers, auth: false);
        }
        return Response(error: json["message"]);
      }
      return Response(data: json);
    }
    return const Response(error: "En error occured");
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
