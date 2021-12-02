part of ecole_directe;

class _SchoolLifeTicketsProvider extends Provider {
  _SchoolLifeTicketsProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get() async {
    if (!api.authModule.authenticated) {
      return const Response(error: "Not authenticated");
    }
    return await _request(url: "eleves/${api.authModule.schoolAccount!.id}/viescolaire.awp?verbe=get");
  }
}
