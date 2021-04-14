import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';

///Redirect to the good CAS
///Return type : cookies as Map
callCas(String? cas, String username, String? password, String url) async {
  final storage = new FlutterSecureStorage();
  await storage.write(key: "pronotecas", value: cas);
  if (cas == null) {
    cas = "aucun";
  }
  switch (cas.toLowerCase()) {
    case ("aucun"):
      {
        return null;
      }
      break;
    case ("atrium sud"):
      {
        return await atrium_sud(username, password);
      }
      break;
    case ("ile de france"):
      {
        return await idf(username, password, url);
      }
      break;
  }
}

atrium_sud(String username, String? password) async {
  // ENT / PRONOTE required URLs
  var ent_login =
      'https://www.atrium-sud.fr/connexion/login?service=https:%2F%2F0060013G.index-education.net%2Fpronote%2F';
  // ENT / PRONOTE required URLs
  var headers = {
    'connection': 'keep-alive',
    'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0'
  };
  // Ent connection
  //Session session = Session();
  var response = await Requests.get(ent_login, persistCookies: true);
  //var cookies = await Requests.getStoredCookies(Requests.getHostname(ent_login));

  print("[ATRIUM LOGIN] with $username");
  //print(response.content().toString().replaceAll("\n", "").replaceAll(" ", ""));
  //Login payload
  var parsed = parse(response.content());
  //print(parsed.outerHtml);
  var input_ = parsed.getElementsByTagName("input").firstWhere(
      (element) => element.attributes.toString().contains("hidden") && element.attributes.toString().contains("lt"));
  var lt = input_.attributes["value"];
  input_ = parsed.getElementsByTagName("input").firstWhere((element) =>
      element.attributes.toString().contains("hidden") && element.attributes.toString().contains("execution"));
  var execution = input_.attributes["value"];
  var payload = {
    'execution': execution,
    '_eventId': 'submit',
    'submit': '',
    'lt': lt,
    'username': username,
    'password': password
  };
  var response2 = await Requests.post(ent_login,
      body: payload, persistCookies: true, bodyEncoding: RequestBodyEncoding.FormURLEncoded);

  var cookies = await Requests.getStoredCookies(Requests.getHostname(ent_login));
  printWrapped(cookies.toString());

  if (response2.content().contains("Vous devez activer votre compte Atrium")) {
    // throw "runes";
  }

  return cookies;
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

idf(String username, String? password, String url) async {
  var headers = {
    'connection': 'keep-alive',
    'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0'
  };

  final client = HttpClient();
// ignore: close_sinks
  final request = await client.getUrl(Uri.parse(url));
  request.headers.set(HttpHeaders.contentTypeHeader, "plain/text");
  request.followRedirects = false;
  final response = await request.close();
  //Get location from headers
  String redirectedUrl = response.headers.value(HttpHeaders.locationHeader)!;
  String service = Uri.encodeComponent(url);

  if (redirectedUrl.startsWith('http') && redirectedUrl.contains('service=')) {
    service = redirectedUrl.substring(redirectedUrl.indexOf('=') + 1);
  }

  String ent_login = "https://ent.iledefrance.fr/auth/login";
//remove old cookies
  await Requests.clearStoredCookies(Requests.getHostname(ent_login));
  String callback = Uri.encodeComponent(Uri.encodeComponent("/cas/login?service=$service"));
  //payload to send
  var payload = {"email": username, "password": password, "callback": callback};
  print(payload);
  var response2 = await Requests.post(ent_login,
      body: payload, persistCookies: true, bodyEncoding: RequestBodyEncoding.FormURLEncoded);

  if (response2.content().contains("identifiant ou le mot de passe est incorrect.")) {
    throw "runes";
  }
  var cookies = await Requests.getStoredCookies(Requests.getHostname(ent_login));
  printWrapped(cookies.toString());
  return cookies;
}

class Session {
  Map<String, String> headers = {};

  Future get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    updateCookie(response);
    return response.body;
  }

  Future post(String url, dynamic data) async {
    print(headers);
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
