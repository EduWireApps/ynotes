part of app;

Future<List<AgendaEvent>?>? spaceAgendaFuture;

Future<List<AgendaEvent>?>? agendaFuture;

late ApplicationSystem appSys;

late SchoolApi schoolApi;

SchoolApi schoolApiManager(Apis api) {
  late SchoolApi _api;
  switch (api) {
    case Apis.ecoleDirecte:
      _api = EcoleDirecteApi();
  }
  Logger.log("SCHOOL API MANAGER", "Selected: ${_api.metadata.name}");
  return _api;
}

final List<SchoolApi> schoolApis = [EcoleDirecteApi()];
