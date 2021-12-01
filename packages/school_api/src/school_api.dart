part of school_api;

abstract class SchoolApi<T> {
  bool get isLoggedIn => _isLoggedIn;
  @protected
  // ignore: prefer_final_fields
  bool _isLoggedIn = false;
  @protected
  T get client;

  final Offline offline;

  final Metadata metadata;

  final ModulesAvailability modulesAvailability;

  List<Module> get modules => [authModule, gradesModule, schoolLifeModule];

  SchoolApi({required this.metadata})
      : offline = Offline(),
        modulesAvailability = ModulesAvailability();

  AuthModule get authModule;

  GradesModule get gradesModule;

  SchoolLifeModule get schoolLifeModule;

  Future<Response<String>> login({required String username, required String password});
}
