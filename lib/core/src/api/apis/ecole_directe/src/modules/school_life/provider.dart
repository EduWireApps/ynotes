part of ecole_directe;

class _SchoolLifeProvider extends Provider {
  _SchoolLifeProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get() async =>
      await _request(api, url: "eleves/${api.authModule.schoolAccount?.entityId}/viescolaire.awp?verbe=get");
}
