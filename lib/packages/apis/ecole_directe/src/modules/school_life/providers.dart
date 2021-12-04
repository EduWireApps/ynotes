part of ecole_directe;

class _SchoolLifeTicketsProvider extends Provider {
  _SchoolLifeTicketsProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get() async =>
      await _request(api, url: "eleves/${api.authModule.schoolAccount?.id}/viescolaire.awp?verbe=get");
}
