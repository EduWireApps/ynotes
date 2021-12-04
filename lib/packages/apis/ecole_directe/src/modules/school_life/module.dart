part of ecole_directe;

class _SchoolLifeModule extends SchoolLifeModule<_SchoolLifeRepository> {
  _SchoolLifeModule(SchoolApi api, {required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: _SchoolLifeRepository(api), api: api);

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      final res = await repository.getTickets();
      if (res.error != null) {
        return Response(error: res.error);
      }
      tickets = res.data!["tickets"];
      offline.setTickets(tickets);
      sanctions = res.data!["sanctions"];
      offline.setSanctions(sanctions);
    } else {
      tickets = await offline.getTickets();
      sanctions = await offline.getSanctions();
    }
    fetching = false;
    notifyListeners();
    return const Response();
  }
}
