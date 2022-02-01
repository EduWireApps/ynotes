part of school_api;

abstract class SchoolLifeModule<R extends Repository> extends Module<R> {
  SchoolLifeModule({required R repository, required SchoolApi api})
      : super(
          isSupported: api.modulesSupport.schoolLife,
          isAvailable: api.modulesAvailability.schoolLife,
          repository: repository,
          api: api,
        );

  List<SchoolLifeTicket> get tickets => offline.schoolLifeTickets.where().findAllSync();
  List<SchoolLifeSanction> get sanctions => offline.schoolLifeSanctions.where().findAllSync();

  @override
  Future<Response<void>> fetch() async {
    fetching = true;
    notifyListeners();
    final res = await repository.get();
    if (res.error != null) return res;
    final List<SchoolLifeTicket> _tickets = res.data!["tickets"] ?? [];
    final List<SchoolLifeSanction> _sanctions = res.data!["sanctions"] ?? [];
    await offline.writeTxn((isar) async {
      await offline.schoolLifeTickets.clear();
      await offline.schoolLifeSanctions.clear();
      await offline.schoolLifeTickets.putAll(_tickets);
      await offline.schoolLifeSanctions.putAll(_sanctions);
    });
    fetching = false;
    notifyListeners();
    return const Response();
  }

  @override
  Future<void> reset() async {
    await offline.writeTxn((isar) async {
      await isar.schoolLifeTickets.clear();
      await isar.schoolLifeSanctions.clear();
    });
    notifyListeners();
  }
}
