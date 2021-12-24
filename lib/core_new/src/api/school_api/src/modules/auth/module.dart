part of school_api;

enum AuthStatus { authenticated, unauthenticated, offline, error }

abstract class AuthModule<R extends Repository> extends Module<R, OfflineAuth> {
  AuthModule({required R repository, required SchoolApi api})
      : super(isSupported: true, isAvailable: true, repository: repository, api: api, offline: OfflineAuth()) {
    _connectivity.onConnectivityChanged.listen(_checkConnectivity);
  }

  static const String _credentialsKey = "credentials";

  AppAccount? account;
  SchoolAccount? schoolAccount;

  AuthStatus status = AuthStatus.unauthenticated;

  final Connectivity _connectivity = Connectivity();

  Future<Response<Map<String, dynamic>>> getCredentials() async {
    final String? data = await KVS.read(key: _credentialsKey);
    if (data == null) {
      return const Response(error: "No credentials found");
    }
    return Response(data: json.decode(data));
  }

  Future<void> setCredentials(Map<String, dynamic> credentials) async {
    await KVS.write(key: _credentialsKey, value: json.encode(credentials));
  }

  Future<void> _checkConnectivity(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.none:
        status = AuthStatus.offline;
        notifyListeners();
        break;
      default:
        // Reconnecté
        status = AuthStatus.unauthenticated;
        notifyListeners();
        await loginFromOffline();
        break;
    }
  }

  Future<void> loginFromOffline() async {
    final credentials = await getCredentials();
    if (credentials.error != null) {
      // Erreur de connexion
      status = AuthStatus.error;
      notifyListeners();
      return;
    }
    final creds = credentials.data!;
    await login(username: creds["username"], password: creds["password"], parameters: creds["parameters"]);
  }

  @override
  Future<void> _init() async {
    await super._init();
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    await _checkConnectivity(result);
  }

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    account = await offline.getAccount();
    schoolAccount = await offline.getSchoolAccount();
    return const Response();
  }

  Future<void> save() async {
    await offline.setAccount(account);
    await offline.setSchoolAccount(schoolAccount);
  }

  Future<Response<void>> login({required String username, required String password, Map<String, dynamic>? parameters});

  @override
  Future<void> reset({bool offline = false}) async {
    account = null;
    schoolAccount = null;
    await super.reset(offline: offline);
  }
}
