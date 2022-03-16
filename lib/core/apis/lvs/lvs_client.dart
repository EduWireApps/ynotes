import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'session_client.dart';

class LvsClient extends SessionClient {
  HwClient hw_client = new HwClient();

  Future<List> init(credentials) async {
    if (credentials['username'] is! String ||
        credentials['password'] is! String) {
      throw ('Lvs credentials username and password must be string');
    }
    if (credentials['url'] is! Uri) {
      throw ('Lvs credentials url must be Uri');
    }
    var data = {
      'login': credentials['username'],
      'password': credentials['password']
    };

    this.setUser_agent();
    var rep = await this.post(
        Uri.parse(credentials['url'].toString() + '/vsn.main/WSAuth/connexion'),
        body: json.encode(data),
        headers: {"Content-Type": "application/json"},
        token: false,
        baseUrl: false);
    // CustomLogger.saveLog(object: 'LVS', text: rep.body.toString());
    if (rep.statusCode == 200) {
      CustomLogger.log('LVS', 'successful authentication for Lvs');
      this.token = rep.headers['set-cookie'].toString();
      this.base_url = credentials['url'].toString();
      this.hw_client.started = false;
      return [1, "success"];
    }
    return [0, "error"];
  }

  @override
  Future<http.Response> get(Uri url,
      {Map<String, String>? headers, bool token = true, baseUrl = true}) async {
    Map<String, String>? theheaders = {};
    if (token) {
      var thetoken = await this.getToken();
      if (thetoken == '') {
        return http.Response('', 401);
      }
      thetoken = thetoken.replaceAll(RegExp(r','), ';');
      theheaders["Cookie"] = thetoken;
    }

    if (headers == Map) {
      theheaders.addAll(headers!);
    }

    return await super.get(url, headers: theheaders, baseUrl: baseUrl);
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool token = true,
      baseUrl = true}) async {
    Map<String, String>? theheaders = {};

    if (token) {
      var thetoken = await this.getToken();
      if (thetoken == '') {
        return http.Response('', 401);
      }
      thetoken = thetoken.replaceAll(RegExp(r','), ';');
      theheaders["Cookie"] = thetoken;
    }

    if (headers == Map) {
      theheaders.addAll(headers!);
    }
    return await super
        .post(url, body: body, headers: theheaders, baseUrl: baseUrl);
  }

  getHwClient() async {
    if (!this.hw_client.started) {
      var theclient = new HwClient();
      await theclient.start({
        'method': this.get,
        'args': Uri.parse(
            '/vsn.main/WSMenu/getModuleUrl?mod=CDT&minuteEcartGMTClient=-120&add=123'),
        'named': {}
      });
      this.hw_client = theclient;
    }
    return this.hw_client;
  }
}

class HwClient extends SessionClient {
  HwClient() : super();
  Future<List> init(Map<String, dynamic> credentials) async {
    var entry =
        await Function.apply(credentials['method'], [credentials['args']]);
    var entry_url = jsonDecode(entry.body)['location'];
    // CustomLogger.saveLog(object: 'Entry Url for Hw', text: entry_url);
    if (entry.statusCode == 200) {
      this.base_url = entry_url.substring(0, entry_url.indexOf('.fr') + 3) +
          '/eliot-textes';

      var request = new Request('GET', Uri.parse(entry_url))
        ..followRedirects = false;
      var response = await client.send(request);

      var i = 1;
      while (i < 6 && response.statusCode == 302) {
        request = new Request('GET', Uri.parse(response.headers['location']!))
          ..followRedirects = false;
        response = await client.send(request);
        i++;
      }

      var raw_token = response.headers['location']!;

      var debut = raw_token.indexOf(';');
      var end = raw_token.indexOf('?');
      var token = raw_token.substring(debut, end);

      if (token != '') {
        this.token = token;
        /* var resp = await this.post(
            Uri.parse('/rechercheActivite/rechercheJournaliere'),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body:
                "params=%7B%22start%22%3A0%2C%22limit%22%3A100%2C%22contexteId%22%3A-1%2C%22typeId%22%3A-1%2C%22cdtId%22%3A-1%2C%22matiereId%22%3A-1%2C%22groupeId%22%3A-1%2C%22dateDebut%22%3A%2208%2F06%2F2021%22%2C%22dateFin%22%3A%2208%2F06%2F2021%22%2C%22actionRecherche%22%3Atrue%2C%22activeTab%22%3A%22idlisteTab%22%7D&xaction=read");
      */

        CustomLogger.log('LVS_HW', 'successful authentication for Lvs Hw');
        return [1, "success"];
      }
      return [0, "invalid token for Lvs Hw"];
    }
    return [0, "error while retrieving homeworks"];
  }

  @override
  Future<http.Response> get(Uri url,
      {Map<String, String>? headers,
      bool token = true,
      baseUrl = true,
      params = ''}) async {
    if (token) {
      var thetoken = await this.getToken();
      if (thetoken == '') {
        return http.Response('', 401);
      }
      String requrl = url.toString();
      url = Uri.parse(requrl + thetoken + params);
    }
    return super.get(url, headers: headers, baseUrl: baseUrl);
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool token = true,
      baseUrl = true}) async {
    if (token) {
      var thetoken = await this.getToken();
      if (thetoken == '') {
        return http.Response('', 401);
      }
      String requrl = url.toString();
      url = Uri.parse(requrl + thetoken);
    }
    return super.post(url, body: body, headers: headers, baseUrl: baseUrl);
  }
}
