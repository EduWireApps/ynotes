part of ecole_directe_client;

// dart run packages/tmp.dart

String? _token;
const String _baseUrl = "https://api.ecoledirecte.com/v3/";

class EcoleDirecteClient {
  EcoleDirecteClient();

  Account? get account => _account;
  Account? _account;

  Future<Response<Account>> login({required String username, required String password}) async =>
      await handleNetworkError(() async {
        final res = await _request(
            url: "login.awp",
            body: {
              "identifiant": username,
              "motdepasse": password,
            },
            auth: false);
        if (res.statusCode == 200) {
          final String body = _decodeBody(res);
          final Map<String, dynamic> json = jsonDecode(body);
          if (json["token"] == "") {
            return Response(error: json["message"]);
          }
          _token = json["token"];
          _account = Account.fromMap(json["data"]["accounts"][0]);
          return Response(data: account);
        }
        return const Response(error: "An error occured");
      });

  Future<Response<String>> getGrades() async => await handleNetworkError(() async {
        final res = await _request(url: "eleves/${account!.id}/notes.awp?verbe=get");
        if (res.statusCode == 200) {
          final String body = _decodeBody(res);
          final Map<String, dynamic> json = jsonDecode(body);
          if (json["code"] != 200) {
            return Response(error: json["message"]);
          }
          return Response(data: body);
        }
        return const Response(error: "En error occured");
      });
}
