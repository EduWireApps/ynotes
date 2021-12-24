part of school_api;

abstract class SchoolLifeModule<R extends Repository> extends Module<R, OfflineSchoolLife> {
  SchoolLifeModule(
      {required bool isSupported, required bool isAvailable, required R repository, required SchoolApi api})
      : super(
            isSupported: isSupported,
            isAvailable: isAvailable,
            repository: repository,
            api: api,
            offline: OfflineSchoolLife());

  List<SchoolLifeTicket> get tickets => _tickets;
  List<SchoolLifeSanction> get sanctions => _sanctions;
  List<SchoolLifeTicket> _tickets = [];
  List<SchoolLifeSanction> _sanctions = [];

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      final res = await repository.get();
      if (res.error != null) return res;
      _tickets = res.data!["tickets"] ?? [];
      _sanctions = res.data!["sanctions"] ?? [];
      await offline.setTickets(_tickets);
      await offline.setSanctions(_sanctions);
    } else {
      _tickets = await offline.getTickets();
      _sanctions = await offline.getSanctions();
    }
    fetching = false;
    notifyListeners();
    return const Response();
  }

  @override
  Future<void> reset({bool offline = false}) async {
    _tickets = [];
    _sanctions = [];
    await super.reset(offline: offline);
  }
}
