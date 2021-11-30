part of ecole_directe_client;

String encodeBody(Map<String, String> body, [String? token]) {
  if (token != null) {
    body['token'] = token;
  }
  return "data=${jsonEncode(body)}";
}

String decodeBody(http.Response res) => const Utf8Decoder().convert(res.bodyBytes);
