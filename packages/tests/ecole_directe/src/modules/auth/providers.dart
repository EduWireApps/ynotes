part of ecole_directe;

class _AuthProvider extends Provider {
  _AuthProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get(Map<String, String> body) async =>
      await _request(url: "login.awp", body: body, auth: false);
}
