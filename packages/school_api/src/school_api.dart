part of school_api;

abstract class SchoolApi<T> {
  bool get isLoggedIn => _isLoggedIn;
  bool _isLoggedIn = false;
  late final T client;

  final Offline offline;

  final Metadata metadata;

  final ModulesAvailability modulesAvailability;

  SchoolApi({required this.metadata})
      : offline = Offline(),
        modulesAvailability = ModulesAvailability();

  @protected
  GradesModule get gradesModule;

  @protected
  Future<Response<String>> login({required String username, required String password});
}
