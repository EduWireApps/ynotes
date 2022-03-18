part of app;

late SchoolApi schoolApi;

final List<SchoolApi> schoolApis = [EcoleDirecteApi(), PronoteApi()];

SchoolApi schoolApiManager(Apis api) {
  SettingsService.settings.global.api = api;
  SettingsService.update();
  late SchoolApi _api;
  switch (api) {
    case Apis.ecoleDirecte:
      _api = EcoleDirecteApi();
      break;
    case Apis.pronote:
      _api = PronoteApi();
      break;
  }
  Logger.log("SCHOOL API MANAGER", "Selected: ${_api.metadata.name}");
  return _api;
}
