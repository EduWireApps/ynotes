part of ecole_directe;

class _AuthRepository extends Repository {
  @protected
  late final _AuthProvider authProvider = _AuthProvider(api);

  _AuthRepository(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> login(Map<String, String> body) async {
    String encodeData(String data) {
      final List<List<String>> chars = [
        ["%", "%25"],
        ["&", "%26"],
        ["+", "%2B"],
        ["\\", "\\\\"],
        ["\"", "\\\""],
      ];
      for (var i = 0; i < chars.length; i++) {
        data = data.replaceAll(chars[i][0], chars[i][1]);
      }
      return data;
    }

    for (String k in body.keys) {
      body[k] = encodeData(body[k]!);
    }
    final res = await authProvider.get(body);
    if (res.error != null) {
      return Response(error: res.error);
    }
    try {
      _token = res.data!["token"];
      final Map<String, dynamic> account = res.data!["data"]["accounts"][0];
      final List<SchoolAccount> accounts = account["profile"]["eleves"] ??
          []
              .map<SchoolAccount>((e) => SchoolAccount(
                  firstName: e["prenom"],
                  lastName: e["nom"],
                  className: e["classe"]["libelle"],
                  id: e["id"].toString(),
                  profilePicture: e["photo"]))
              .toList();
      final AppAccount appAccount =
          AppAccount(id: account["uid"], firstName: account["prenom"], lastName: account["nom"], accounts: accounts);
      final Map<String, dynamic> map = {
        "appAccount": appAccount,
        "schoolAccount": accounts.isEmpty
            ? SchoolAccount(
                firstName: appAccount.firstName,
                lastName: appAccount.lastName,
                className: account["profile"]["classe"]["libelle"],
                id: account["id"].toString(),
                profilePicture: account["profile"]["photo"])
            : accounts[0]
      };
      return Response(data: map);
    } catch (e) {
      return Response(error: "$e");
    }
  }
}
