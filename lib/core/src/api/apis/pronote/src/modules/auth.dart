part of pronote;

class _AuthModule extends AuthModule<_AuthRepository> {
  _AuthModule(SchoolApi api) : super(repository: _AuthRepository(api), api: api);
}

class _AuthProvider extends Provider {
  _AuthProvider(PronoteApi api) : super(api);

  List account(Map accountData) {
    Map? data = safeMapGetter(accountData, ["donneesSec", "donnees", "ressource"]);

    if (safeMapGetter(data, ["listeRessources"]) != null) {
      String? name = safeMapGetter(data, ["L"]);
      bool isParentMainAccount = true;
      List<SchoolAccount> accounts = schoolAccounts(safeMapGetter(data, ["listeRessources"]));

      //we generate a random UUID
      String id = const Uuid().v1();
      AppAccount(
        firstName: name ?? "Sans nom",
        lastName: "" ?? "Sans nom",
        entityId: id,
      ).accounts.addAll(accounts);
      return [
        AppAccount(
          firstName: name ?? "Sans nom",
          lastName: "" ?? "Sans nom",
          entityId: id,
        ),
        accounts
      ];
    }
    //If this is a single account
    else {
      String? name = safeMapGetter(data, ["L"]);
      bool isParentMainAccount = false;
      List<SchoolAccount> accounts = [singleSchoolAccount((data ?? {}))];
      String id = const Uuid().v1();

      return [
        AppAccount(
          firstName: name ?? "Sans nom",
          lastName: "",
          entityId: id,
        ),
        accounts
      ];
    }
  }

  Future<Response<Map>> firstInit(String username, String password, Map<String, dynamic> parameters) async {
    (api as PronoteApi).client = null;
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
    return Response(data: login.data);
  }

  Future<Response<Map<String, dynamic>>> get(Map<String, String> body) async => Response();

  Future<Response<Map<String, dynamic>>> handleError(Map<String, String> body) async => Response();

  List<SchoolAccount> schoolAccounts(List? schoolAccountsData) {
    List<SchoolAccount> accounts = [];
    for (var studentData in (schoolAccountsData ?? [])) {
      String? name = safeMapGetter(studentData, ["L"]);
      String? studentClass = safeMapGetter(studentData, ["classeDEleve", "L"]);
      String? schoolName = safeMapGetter(studentData, ["Etablissement", "V", "L"]);
      String? studentID = safeMapGetter(studentData, ["N"]);

      accounts.add(SchoolAccount(
          firstName: name ?? "Sans nom",
          lastName: "Sans nom",
          className: studentClass ?? "",
          entityId: studentID ?? "",
          school: schoolName ?? "Sans nom",
          profilePicture: ""));
    }
    return accounts;
  }

  SchoolAccount singleSchoolAccount(Map schoolAccountData) {
    String? name = safeMapGetter(schoolAccountData, ["L"]);
    String? schoolName = safeMapGetter(schoolAccountData, ["Etablissement", "V", "L"]);
    String? studentClass = safeMapGetter(schoolAccountData, ["classeDEleve", "L"]);
    String? studentID = safeMapGetter(schoolAccountData, ["N"]);
    return SchoolAccount(
        firstName: name ?? "Sans nom",
        lastName: "Sans nom",
        className: studentClass ?? "",
        entityId: studentID ?? "",
        school: schoolName ?? "Sans nom",
        profilePicture: "");
  }
}

class _AuthRepository extends AuthRepository {
  @protected
  late final _AuthProvider authProvider = _AuthProvider(api as PronoteApi);

  _AuthRepository(SchoolApi api) : super(api);
  Future<Response<Map<String, dynamic>>> login(
      {required String username, required String password, Map<String, dynamic>? parameters}) async {
    Response<Map> res = await authProvider.firstInit(username, password, parameters!);
    if (res.hasError) return Response(error: "Error while login");
    Map accountData = res.data!;
    AppAccount appAccount = authProvider.account(accountData)[0];
    List<SchoolAccount> accounts = authProvider.account(accountData)[1];
      api.modulesAvailability.grades = true;
      await api.modulesAvailability.save();
      api.refreshModules();
    final Map<String, dynamic> map = {"appAccount": appAccount, "schoolAccount": accounts[0]};
    return Response(data: map);
  }
}
