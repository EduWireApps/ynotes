import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:math';

abstract class SessionClient {
  http.Client client = new http.Client();
  String token = '';
  String base_url = '';
  bool started = false;
  String? user_agent;
  int last_refresh = 0;
  int limit_refresh = 5000;
  int token_expiration = 1200000;
  int req = 0;
  late Map<String, dynamic> credentials;

  Future<List> init(Map<String, dynamic> credentials);

  Future<List> start(Map<String, dynamic> credentials) async {
    this.credentials = credentials;
    var res = await this.init(credentials);
    this.started = true;
    var now = new DateTime.now();
    this.last_refresh = now.millisecondsSinceEpoch;
    return res;
  }

  Future<http.Response> get(Uri url,
      {Map<String, String>? headers, bool token = true, baseUrl = true}) async {
    if (baseUrl) {
      String requrl = url.toString();
      url = Uri.parse(this.base_url + requrl);
    }

    if (this.user_agent != null) {
      if (headers == null) {
        headers = {};
      }
      headers['User-Agent'] = this.user_agent!;
    }
    return await await client.get(url, headers: headers);
  }

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool token = true,
      baseUrl = true}) async {
    if (baseUrl) {
      String requrl = url.toString();
      url = Uri.parse(this.base_url + requrl);
    }
    if (this.user_agent != null) {
      if (headers == null) {
        headers = {};
      }
      headers['User-Agent'] = this.user_agent!;
    }
    return client.post(url, body: body, headers: headers);
  }

  Future<String> getToken([refresh = false]) async {
    if (!this.started) {
      return '';
    }
    var now = new DateTime.now();

    if (refresh &&
            now.millisecondsSinceEpoch - this.last_refresh >
                this.limit_refresh ||
        now.millisecondsSinceEpoch - this.last_refresh >
            this.token_expiration) {
      var previous_token = this.token;
      await this.start(this.credentials);
      if (this.token == previous_token) {
        return '';
      }
    }
    return this.token;
  }

  String setUser_agent({String agent = ''}) {
    if (agent != '') {
      Random random = new Random();
      int randomNumber = random.nextInt(15);
      return this.user_agent = [
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Mozilla/5.0 (Windows NT 6.3; WOW64; rv:53.0) Gecko/20100101 Firefox/53.0",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4",
        "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:53.0) Gecko/20100101 Firefox/53.0",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:53.0) Gecko/20100101 Firefox/53.0",
        "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:53.0) Gecko/20100101 Firefox/53.0",
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:53.0) Gecko/20100101 Firefox/53.0"
      ][randomNumber];
    }
    return this.user_agent = agent;
  }
}
