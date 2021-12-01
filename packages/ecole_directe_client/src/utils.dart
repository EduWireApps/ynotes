part of ecole_directe_client;

String _encodeBody(Map<String, String>? body, [String? token]) {
  body ??= {};
  if (token != null) {
    body['token'] = token;
  }
  return "data=${jsonEncode(body)}";
}

String _decodeBody(http.Response res) => const Utf8Decoder().convert(res.bodyBytes);

Future<http.Response> _request(
    {required String url, Map<String, String>? body, Map<String, String>? headers, bool auth = true}) async {
  final String _body = _encodeBody(body, auth ? _token! : null);
  headers ??= {};
  headers["Content-type"] = "text/plain";
  return await http.post(Uri.parse("$_baseUrl$url"), headers: headers, body: _body);
}
