part of school_api;

abstract class SchoolLifeModule<R extends Repository> extends Module<R> {
  SchoolLifeModule(
      {required bool isSupported, required bool isAvailable, required R repository, required SchoolApi api})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: repository, api: api);

  List<SchoolLifeTicket> tickets = [];
}
