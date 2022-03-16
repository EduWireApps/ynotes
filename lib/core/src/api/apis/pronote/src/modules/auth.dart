part of pronote;

class _AuthModule extends AuthModule<_AuthRepository> {
  _AuthModule(SchoolApi api) : super(repository: _AuthRepository(api), api: api);
}

class _AuthProvider extends Provider {
  _AuthProvider(PronoteApi api) : super(api);

  Future<Response> firstInit(String username, String password, Map<String, dynamic> parameters) async {
    if ((api as PronoteApi).client == null) {
      (api as PronoteApi).client = PronoteClient(username: username, password: password, parameters: parameters);
    }

    Response init = await (api as PronoteApi).client!.init();
     if (init.hasError) {
      return Response(error: init.error);
    }
    Response login = await (api as PronoteApi).client!.login();

    if (login.hasError) {
      return Response(error: login.error);
    }
    return Response(error: "");
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
    Response res = await authProvider.firstInit(username, password, parameters!);
    if (res.hasError) {
      return Response(error: res.error);
    }
    return Response(error: "Mocking");
  }
}
