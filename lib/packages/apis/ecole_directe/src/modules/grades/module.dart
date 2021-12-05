part of ecole_directe;

class _GradesModule extends GradesModule<_GradesRepository> {
  _GradesModule(SchoolApi api, {required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: _GradesRepository(api), api: api);

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    repository.x;
    return const Response(
      error: "Not implemented",
    );
  }
}
