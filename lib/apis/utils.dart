import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

get_week(DateTime date) async {
  final storage = new FlutterSecureStorage();
  return (1 + (date.difference(DateTime.parse(await storage.read(key: "startday"))).inDays / 7).floor()).round();
}

///Generate lesson ID using, the next scheme : week parity (1 or 2), day of week (1-7) and an hashcode
///composed of the lesson start datetime, the lesson end datetime and the discipline name
Future<int> getLessonID(DateTime start, DateTime end, String disciplineName) async {
  String _disciplineName = "";
  if (disciplineName != null) {
    _disciplineName = disciplineName;
  }
  int parity = ((await get_week(start)).isEven) ? 1 : 2;
  int weekDay = start.weekday;
  TimeOfDay startTimeOfDay = TimeOfDay.fromDateTime(start);
  TimeOfDay endTimeOfDay = TimeOfDay.fromDateTime(end);
  String parsedStartAndEnd = startTimeOfDay.hour.toString() + startTimeOfDay.minute.toString() + endTimeOfDay.hour.toString() + endTimeOfDay.minute.toString();
  int endHash = (parsedStartAndEnd + disciplineName).hashCode;

  int finalID = int.parse(parity.toString() + weekDay.toString() + endHash.toString());

  return finalID;
}
