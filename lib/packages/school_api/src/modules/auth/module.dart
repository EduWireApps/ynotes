part of school_api;

abstract class AuthModule<R extends Repository> extends Module<R, OfflineAuth> {
  AuthModule({required R repository, required SchoolApi api})
      : super(isSupported: true, isAvailable: true, repository: repository, api: api, offline: OfflineAuth());

  AppAccount? account;
  SchoolAccount? schoolAccount;

  bool authenticated = false;

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    // TODO: implement fetch
    return const Response(error: "Not implemented");
  }

  Future<Response<void>> login({required String username, required String password, Map<String, dynamic>? parameters});
}
