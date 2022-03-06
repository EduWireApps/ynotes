part of pronote;

class _AuthModule extends AuthModule<_AuthRepository> {
  _AuthModule(SchoolApi api) : super(repository: _AuthRepository(api), api: api);
}

class _AuthProvider extends Provider {
  _AuthProvider(PronoteApi api) : super(api);

  Future<Response<Map<String, dynamic>>> firstInit(String username, String password, Map parameters) async {
    (api as PronoteApi).client =
        PronoteClient(username: parameters["is"], password: parameters["isCas"], parameters: parameters);
    (api as PronoteApi).client.communication.init();
    (api as PronoteApi).client.communication.login();
    return Response();
  }

  Future<Response<Map<String, dynamic>>> get(Map<String, String> body) async => Response();

  Future<Response<Map<String, dynamic>>> handleError(Map<String, String> body) async => Response();
}

class _AuthRepository extends AuthRepository {
  @protected
  late final _AuthProvider authProvider = _AuthProvider(api as PronoteApi);

  _AuthRepository(SchoolApi api) : super(api);
  Future<Response<Map<String, dynamic>>> login(
      {required String username, required String password, Map<String, dynamic>? parameters}) async {
    return Response();
  }
}
