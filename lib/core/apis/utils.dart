import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack/stack.dart' as sta;
import 'package:ynotes/core/apis/ecole_directe.dart';
import 'package:ynotes/core/apis/pronote.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/globals.dart';

//Return the good API (will be extended to Pronote)
List<String> colorList = [
  "#f07aa0",
  "#17d0c9",
  "#a3f7bf",
  "#cecece",
  "#ffa41b",
  "#ff5151",
  "#b967e1",
  "#8a7ca7",
  "#f18867",
  "#ffc0da",
  "#739832",
  "#8ac6d1"
];

sta.Stack<String> colorStack = sta.Stack();

apiManager(Offline _offline) {
  //The parser list index corresponding to the user choice
  switch (appSys.settings.system.chosenParser) {
    case 0:
      return APIEcoleDirecte(_offline);

    case 1:
      return APIPronote(_offline);
  }
}

String getInfoUrl(String url) {
  final List<String> rootAddress = getRootAddress(url);
  return "${rootAddress[0]}/${rootAddress[1].split("/")[1]}/InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4";
}

Future<bool> checkPronoteURL(String url) async {
  try {
    var response = await http.get(Uri.parse(getInfoUrl(url))).catchError((e) {});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    CustomLogger.error(e, stackHint:"MTE=");
    return false;
  }
}

void createStack() {
  for (var color in colorList) {
    colorStack.push(color);
  }
}

Future<int> getColor(String? disciplineCode) async {
  SharedPreferences prefs = await (SharedPreferences.getInstance());
  if (disciplineCode != null) {
    if (prefs.containsKey(disciplineCode)) {
      String color = prefs.getString(disciplineCode)!;
      return HexColor(color).value;
    } else {
      if (colorStack.isEmpty) {
        createStack();
      }
      await prefs.setString(disciplineCode, colorStack.pop());
      String color = prefs.getString(disciplineCode)!;
      return HexColor(color).value;
    }
  }
  return 0;
}

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

List<String> getRootAddress(String address) {
  final Uri uri = Uri.parse(address);
  return [
    "${uri.scheme}://${uri.host}${uri.port != 80 ? ':${uri.port}' : ''}",
    "${uri.path}${uri.query == '' ? '' : '?'}${uri.query}",
  ];
}

getWeek(DateTime date) async {
  if (await (KVS.read(key: "startday")) != null) {
    return (1 + (date.difference(DateTime.parse(await (KVS.read(key: "startday")) ?? "")).inDays / 7).floor()).round();
  } else {
    return 0;
  }
}

String linkify(String link) {
  return link.replaceAllMapped(RegExp(r'(>|\s)+(https?.+?)(<|\s)', multiLine: true, caseSensitive: false), (match) {
    return '${match.group(1)}<a href="${match.group(2)}">${match.group(2)}</a>${match.group(3)}';
  });
}

setChosenParser(int chosen) async {
  appSys.settings.system.chosenParser = chosen;
  appSys.saveSettings();
}

Future<bool> testIfPronoteCas(String url) async {
  //auto forward
  if (url.contains("?")) {
    url += "&fd=1";
  } else {
    url += "?fd=1";
  }
  var response = await http.get(Uri.parse(url));
  // CustomLogger.logWrapped("API UTILS", "Response body", response.body);
  if (response.body.contains('id="id_body"')) {
    return false;
  } else {
    return true;
  }
}

String utf8convert(String? text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
