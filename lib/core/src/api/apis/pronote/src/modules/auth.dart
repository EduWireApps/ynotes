part of pronote;

class _AuthModule extends AuthModule<_AuthRepository> {
  _AuthModule(SchoolApi api) : super(repository: _AuthRepository(api), api: api);
}

class _AuthProvider extends Provider {
  _AuthProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get(Map<String, String> body) async => Response();
}

class _AuthRepository extends AuthRepository {
  @protected
  late final _AuthProvider authProvider = _AuthProvider(api);

  _AuthRepository(SchoolApi api) : super(api);
  Future<Response<Map<String, dynamic>>> login(
      {required String username, required String password, Map<String, dynamic>? parameters}) async {
    return Response();
  }
}
