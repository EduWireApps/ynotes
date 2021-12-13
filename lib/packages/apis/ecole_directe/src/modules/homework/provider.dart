part of ecole_directe;

class _HomeworkProvider extends Provider {
  _HomeworkProvider(SchoolApi api) : super(api);

  String? get _studentId => api.authModule.schoolAccount?.id;

  Future<Response<Map<String, dynamic>>> get() async =>
      await _request(api, url: "eleves/$_studentId/cahierdetexte.awp?verbe=get");
}
