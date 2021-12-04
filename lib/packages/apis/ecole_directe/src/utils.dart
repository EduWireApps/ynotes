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
      final String body = _decodeBody(res);
      final Map<String, dynamic> json = jsonDecode(body);
      if (json["code"] != 200) {
        return Response(error: json["message"]);
      }
      return Response(data: json);
    }
    return const Response(error: "En error occured");
  });
}

String parseHtml(String str) =>
    html_parser.parse(str).documentElement!.text.replaceAll("\n\n", ". ").replaceAll("\n", "");
