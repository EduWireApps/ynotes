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
  Future<void> reset({bool offline = false}) async {
    tickets = [];
    sanctions = [];
    await super.reset(offline: offline);
  }
}
