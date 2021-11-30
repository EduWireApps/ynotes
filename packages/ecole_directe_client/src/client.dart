part of ecole_directe_client;

// dart run packages/tmp.dart

class EcoleDirecteClient {
  String? _token;

  EcoleDirecteClient();

  Future<Response<String>> login({required String username, required String password}) async {
    final res = await _request(
        url: "https://api.ecoledirecte.com/v3/login.awp",
        body: {
          "identifiant": username,
          "motdepasse": password,
        },
        auth: false);
    if (res.statusCode == 200) {
      final String body = decodeBody(res);
      final Map<String, dynamic> json = jsonDecode(body);
      if (json["token"] == "") {
        return Response(error: json["message"]);
      }
      return Response(data: body);
    }
    return const Response(error: "An error occured");
  }

  Future<http.Response> _request(
      {required String url, required Map<String, String> body, Map<String, String>? headers, bool auth = true}) async {
    final String _body = encodeBody(body, auth ? _token! : null);
    headers ??= {};
    headers["Content-type"] = "text/plain";
    return await http.post(Uri.parse(url), headers: headers, body: _body);
  }
}
