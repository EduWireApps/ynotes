part of school_api;

abstract class AuthModule<R extends Repository> extends Module<R, OfflineAuth> {
  AuthModule({required R repository, required SchoolApi api})
      : super(isSupported: true, isAvailable: true, repository: repository, api: api, offline: OfflineAuth());

  AppAccount? account;
  SchoolAccount? schoolAccount;

  bool authenticated = false;

  Future<Response<void>> login({required String username, required String password, Map<String, dynamic>? parameters});
}