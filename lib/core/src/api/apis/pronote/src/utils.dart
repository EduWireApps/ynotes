part of pronote;

Response<String> getDownloadUrl(
    {required Document document,
    required _Communication communication,
    required _Encryption encryption,
    required attributes}) {
  final Map<String, dynamic> data = {"N": document.id, "G": document.type};
  final res = encryption.aesEncrypt(utf8.encode(jsonEncode(data)));
  if (res.error != null) return res;
  final String encrypted = res.data!;
  final String url = "${communication.urlRoot}/FichiersExternes/$encrypted/${document.name}?Session=${attributes['h']}";
  return Response(data: url);
}

String getHostname(String url) {
  var uri = Uri.parse(url);
  return '${uri.host}:${uri.port}';
}

List<String> splitAdress(String address) {
  final Uri uri = Uri.parse(address);
  return [
    "${uri.scheme}://${uri.host}${uri.port != 80 ? ':${uri.port}' : ''}",
    "${uri.path}${uri.query == '' ? '' : '?'}${uri.query}",
  ];
}

String _decodeBody(http.Response res) => const Utf8Decoder().convert(res.bodyBytes);

String _encodeBody(Map<String, dynamic>? body) {
  body ??= {};
  return "data=${jsonEncode(body)}";
}
