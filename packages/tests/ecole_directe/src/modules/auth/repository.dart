part of ecole_directe;

class _AuthRepository extends Repository {
  @protected
  late final _AuthProvider authProvider = _AuthProvider(api);

  _AuthRepository(SchoolApi api) : super(api);

  Future<Response<AppAccount>> login(Map<String, String> body) async {
    // TODO: implement offline support
    final res = await authProvider.get(body);
    if (res.error != null) {
      return Response(error: res.error);
    }
    try {
      _token = res.data!["token"];
      final Map<String, dynamic> account = res.data!["data"]["accounts"][0];
      return Response(
          data: AppAccount(
              firstName: account["prenom"], lastName: account["prenom"], accounts: account["profile"]["eleves"] ?? []));
    } catch (e) {
      return Response(error: "$e");
    }
  }
}
