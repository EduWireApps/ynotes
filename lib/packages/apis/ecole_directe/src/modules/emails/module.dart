part of ecole_directe;

class _EmailsModule extends EmailsModule<_EmailsRepository> {
  _EmailsModule(SchoolApi api, {required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: _EmailsRepository(api), api: api);

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    return const Response(error: "Not implemented");
  }
}
