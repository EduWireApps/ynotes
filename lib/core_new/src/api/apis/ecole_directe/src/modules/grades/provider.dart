part of ecole_directe;

class _GradesProvider extends Provider {
  _GradesProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get() async =>
      await _request(api, url: "eleves/${api.authModule.schoolAccount?.id}/notes.awp?verbe=get");
}
