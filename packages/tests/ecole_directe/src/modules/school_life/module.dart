part of ecole_directe;

class _SchoolLifeModule extends SchoolLifeModule<_SchoolLifeRepository> {
  _SchoolLifeModule(SchoolApi api, {required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: _SchoolLifeRepository(api), api: api);

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    final res = await repository.getTickets();
    if (res.error != null) {
      return Response(error: res.error);
    }
    tickets = res.data!;
    fetching = false;
    notifyListeners();
    return const Response();
  }
}
