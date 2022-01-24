part of ecole_directe;

class _HomeworkProvider extends Provider {
  _HomeworkProvider(SchoolApi api) : super(api);

  String? get _studentId => api.authModule.schoolAccount?.entityId;

  Future<Response<Map<String, dynamic>>> get() async =>
      await _request(api, url: "Eleves/$_studentId/cahierdetexte.awp?verbe=get");

  Future<Response<Map<String, dynamic>>> getDay(DateTime date) async {
    final String d = DateFormat("yyyy-MM-dd").format(date);
    return await _request(api, url: "Eleves/$_studentId/cahierdetexte/$d.awp?verbe=get");
  }
}
