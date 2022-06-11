import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ynotes/core/utilities.dart';

class ApisUtilities {
  const ApisUtilities._();

  static List<String> getPronoteRootAddress(String address) {
    final Uri uri = Uri.parse(address);
    return [
      "${uri.scheme}://${uri.host}${uri.port != 80 ? ':${uri.port}' : ''}",
      "${uri.path}${uri.query == '' ? '' : '?'}${uri.query}",
    ];
  }

  static String getPronoteInfoUrl(String url) {
    final List<String> rootAddress = getPronoteRootAddress(url);
    return "${rootAddress[0]}/${rootAddress[1].split("/")[1]}/InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4";
  }

  static Future<bool> checkPronoteURL(String url) async {
    try {
      var response = await http.get(Uri.parse(getPronoteInfoUrl(url))).catchError((e) {});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Logger.error(e, stackHint:"MjQ=");
      return false;
    }
  }

  static Future<bool> checkPronoteCas(String url) async {
    //auto forward
    if (url.contains("?")) {
      url += "&fd=1";
    } else {
      url += "?fd=1";
    }
    var response = await http.get(Uri.parse(url));
    // Logger.logWrapped("API UTILS", "Response body", response.body);
    if (response.body.contains('id="id_body"')) {
      return false;
    } else {
      return true;
    }
  }

  static String linkify(String link) {
    return link.replaceAllMapped(RegExp(r'(>|\s)+(https?.+?)(<|\s)', multiLine: true, caseSensitive: false), (match) {
      return '${match.group(1)}<a href="${match.group(2)}">${match.group(2)}</a>${match.group(3)}';
    });
  }
}

// TODO: relocate

///Generate lesson ID using, the next scheme : week parity (1 or 2), day of week (1-7) and an hashcode
///composed of the lesson start datetime, the lesson end datetime and the discipline name
Future<int> getLessonID(DateTime start, DateTime end, String disciplineName) async {
  int parity = ((await getWeek(start)).isEven) ? 1 : 2;
  int weekDay = start.weekday;
  TimeOfDay startTimeOfDay = TimeOfDay.fromDateTime(start);
  TimeOfDay endTimeOfDay = TimeOfDay.fromDateTime(end);
  String parsedStartAndEnd = startTimeOfDay.hour.toString() +
      startTimeOfDay.minute.toString() +
      endTimeOfDay.hour.toString() +
      endTimeOfDay.minute.toString();
  int endHash = (parsedStartAndEnd + disciplineName).hashCode;

  int finalID = int.parse(parity.toString() + weekDay.toString() + endHash.toString());

  return finalID;
}

getWeek(DateTime date) async {
  if (await (KVS.read(key: "startday")) != null) {
    return (1 + (date.difference(DateTime.parse(await (KVS.read(key: "startday")) ?? "")).inDays / 7).floor()).round();
  } else {
    return 0;
  }
}
