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

  List<SchoolLifeTicket> tickets = [];
  List<SchoolLifeSanction> sanctions = [];

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      final res = await repository.get();
      if (res.error != null) return res;
      tickets = res.data!["tickets"];
      sanctions = res.data!["sanctions"];
      await offline.setTickets(tickets);
      await offline.setSanctions(sanctions);
    } else {
      tickets = await offline.getTickets();
      sanctions = await offline.getSanctions();
    }
    fetching = false;
    notifyListeners();
    return const Response();
  }

  @override
  Future<void> reset({bool offline = false}) async {
    tickets = [];
    sanctions = [];
    await super.reset(offline: offline);
  }
}
