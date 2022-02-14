part of ecole_directe;

class _AuthModule extends AuthModule<_AuthRepository> {
  _AuthModule(SchoolApi api) : super(repository: _AuthRepository(api), api: api);
}

class _AuthProvider extends Provider {
  _AuthProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get(Map<String, String> body) async =>
      await _request(api, url: "login.awp", body: body, auth: false);
}

class _AuthRepository extends AuthRepository {
  @protected
  late final _AuthProvider authProvider = _AuthProvider(api);

  _AuthRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async => const Response(error: "Not implemented");

  @override
  Future<Response<Map<String, dynamic>>> login(
      {required String username, required String password, Map<String, dynamic>? parameters}) async {
    final Map<String, String> body = {
      "identifiant": username,
      "motdepasse": password,
    };

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
    if (res.error != null) return res;
    try {
      _token = res.data!["token"];
      final Map<String, dynamic> account = res.data!["data"]["accounts"][0];
      final List<SchoolAccount> accounts = account["profile"]["eleves"] ??
          []
              .map<SchoolAccount>((e) => SchoolAccount(
                  firstName: e["prenom"],
                  lastName: e["nom"],
                  className: e["classe"]["libelle"],
                  entityId: e["id"].toString(),
                  profilePicture: e["photo"],
                  school: e["nomEtablissement"]))
              .toList();
      final AppAccount appAccount =
          AppAccount(entityId: account["uid"], firstName: account["prenom"], lastName: account["nom"]);
      appAccount.accounts.addAll(accounts);
      final Map<String, dynamic> map = {
        "appAccount": appAccount,
        "schoolAccount": accounts.isEmpty
            ? SchoolAccount(
                firstName: appAccount.firstName,
                lastName: appAccount.lastName,
                className: account["profile"]["classe"]["libelle"],
                entityId: account["id"].toString(),
                profilePicture: "https:" + account["profile"]["photo"],
                school: account["nomEtablissement"])
            : accounts[0]
      };
      for (final module in (account["modules"] as List<dynamic>).map<Map<String, dynamic>>((e) => e).toList()) {
        final String name = module["code"];
        final bool enabled = module["enable"];
        if (name == "VIE_SCOLAIRE") {
          api.modulesAvailability.schoolLife = enabled;
        } else if (name == "NOTES") {
          api.modulesAvailability.grades = enabled;
        } else if (name == "MESSAGERIE") {
          api.modulesAvailability.emails = enabled;
        } else if (name == "CAHIER_DE_TEXTES") {
          api.modulesAvailability.homework = enabled;
        }
      }
      await api.modulesAvailability.save();
      api.refreshModules();
      return Response(data: map);
    } catch (e) {
      return Response(error: "$e");
    }
  }
}
