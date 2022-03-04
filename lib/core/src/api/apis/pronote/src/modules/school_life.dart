part of pronote;

class _SchoolLifeModule extends SchoolLifeModule<_SchoolLifeRepository> {
  _SchoolLifeModule(SchoolApi api) : super(repository: _SchoolLifeRepository(api), api: api);
}

class _SchoolLifeProvider extends Provider {
  _SchoolLifeProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get() async =>
           const Response(error: "Not implemented");

}

class _SchoolLifeRepository extends Repository {
  @protected
  late final _SchoolLifeProvider schoolLifeProvider = _SchoolLifeProvider(api);

  _SchoolLifeRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    return const Response(error: "Not implemented");
  }
}
