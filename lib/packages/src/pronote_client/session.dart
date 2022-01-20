part of pronote_client;
/*
class Session {
  Map<String, String> headers = {};

  Future get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    updateCookie(response);
    return response.body;
  }

  Future post(String url, dynamic data) async {
    Logger.log("PRONOTE", "Session post headers: $headers");
    http.Response response = await http.post(Uri.parse(url), body: data, headers: headers);
    updateCookie(response);
    return response.body;
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
*/