import 'package:html/parser.dart' show parse;
import 'package:requests/requests.dart';
import 'package:ynotes/core/utils/logging_utils.dart';

class TotalBug {
  static parseNumber(var data) {
    var parsed = parse(data);
    var onload = parsed.getElementById("nb24h");
    CustomLogger.log("TOTAL BUG", "${onload?.outerHtml}");
    return int.parse(onload?.text ?? "");
  }

  static request(String websiteName) async {
    var getResponse = await Requests.get("https://www.totalbug.com/$websiteName/");
    return getResponse.content();
  }

  static Future<int?> websiteReportsNumber(String websiteName) async {
    return parseNumber(await request(websiteName));
  }
}
