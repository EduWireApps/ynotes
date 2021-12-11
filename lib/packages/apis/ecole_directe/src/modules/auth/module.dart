part of ecole_directe;

class _AuthModule extends AuthModule<_AuthRepository> {
  _AuthModule(SchoolApi api) : super(repository: _AuthRepository(api), api: api);

  @override
  Future<Response<void>> login(
      {required String username, required String password, Map<String, dynamic>? parameters}) async {
    final res = await repository.login({
      "identifiant": username,
      "motdepasse": password,
    });
    if (res.error != null) return res;
    authenticated = true;
    account = res.data!["appAccount"];
    schoolAccount = res.data!["schoolAccount"];
    notifyListeners();
    return const Response();
  }

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    // TODO: implement fetch
    return const Response(error: "Not implemented");
  }
}
