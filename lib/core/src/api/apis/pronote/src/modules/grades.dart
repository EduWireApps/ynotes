part of pronote;

class _GradesModule extends GradesModule<_GradesRepository> {
  _GradesModule(SchoolApi api) : super(repository: _GradesRepository(api), api: api);
}

class _GradesProvider extends Provider {
  _GradesProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get() async => Response();
}

class _GradesRepository extends Repository {
  @protected
  late final _GradesProvider gradesProvider = _GradesProvider(api);

  _GradesRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    final res = await gradesProvider.get();

    List<Period> periods = [];
    List<Period> subjects = [];

    List<Period> grades = [];

    return Response(data: {
      "periods": periods,
      "subjects": subjects,
      "grades": grades,
    });
  }
}
