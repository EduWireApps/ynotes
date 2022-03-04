part of pronote;

class _HomeworkModule extends HomeworkModule<_HomeworkRepository> {
  _HomeworkModule(SchoolApi api) : super(repository: _HomeworkRepository(api), api: api);
}

class _HomeworkProvider extends Provider {
  _HomeworkProvider(SchoolApi api) : super(api);

  String? get _studentId => api.authModule.schoolAccount?.entityId;

  Future<Response<Map<String, dynamic>>> get() async => const Response(error: "Not implemented");

  Future<Response<Map<String, dynamic>>> getDay(DateTime date) async {
    return const Response(error: "Not implemented");
  }
}

class _HomeworkRepository extends HomeworkRepository {
  @protected
  late final _HomeworkProvider homeworkProvider = _HomeworkProvider(api);

  _HomeworkRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    return const Response(error: "Not implemented");
  }

  @override
  Future<Response<List<Homework>>> getDay(DateTime date) async {
    return const Response(error: "Not implemented");
  }
}
