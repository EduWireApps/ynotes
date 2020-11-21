import 'package:flutter/material.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/classes.dart';

///A scheme is 9 long
///it has the following form  : `WADDDDDDD`.
///`W` is the week 0 for every weeks, 1 for even weeks and 2 for odd weeks.
///`A` is a joker, it ignores everything following, if set to 1, __every days are used__.
///Every `D` is a day of the week, 0 for disabled and 1 enabled.
class RecurringEventSchemes {
  //Get schemes
  static Future<List> toScheme(DateTime date) async {
    List schemes = List();
    int parity = ((await get_week(date)).isEven) ? 1 : 2;
    int day = date.day;
    //Get all week event
    schemes.add("allWeek");
    //Get day event with parity
    schemes.add("${parity}d$day");
    //Get day event every week
    schemes.add("0d$day");
  }

  DateTime date;
  int week;
  //Get where function request
  bool testRequest(var scheme) {
    assert(date != null && week != null, "Date and week shouldn't be null");
    var stringScheme = scheme.toString();
    int parity = (week.isEven) ? 1 : 2;
    List selectedDays = List();
    for (int i = 2; i < stringScheme.runes.length; i++) {
      if (stringScheme[i] == "1") {
        selectedDays.add(i - 1);
      }
    }
    print(selectedDays);
    print(date);
    return (stringScheme.length == 9 && (((stringScheme[0] == "0" || stringScheme[0] == parity.toString()) && selectedDays.contains(date.weekday)) || stringScheme[1] == "1"));
  }

  String toCron(int scheme) {
    TimeOfDay tod = TimeOfDay.fromDateTime(this.date);
    List selectedDays;
    var stringScheme = scheme.toString();
    for (int i = 2; i < stringScheme.runes.length; i++) {
      selectedDays = List();
      if (stringScheme[i] == "1") {
        selectedDays.add(i - 1);
      }
    }
    bool everyDay = (stringScheme[1] == "1");
    String cron = tod.minute.toString() + " " + tod.hour.toString() + " *" + " *" + (everyDay ? "*" : (selectedDays.join(",")));
    return cron;
  }

  static String humanReadableTranslaterFromRecurrencyScheme(int scheme) {
    List daysList = ["lundis", "mardis", "mercredis", "jeudis", "vendredis", "samedis", "dimanches"];
    String parsed = scheme.toString();
    String weekRoot = "";
    List days = List();
    String end = "";
    switch (parsed[0]) {
      case "0":
        weekRoot = "Chaque semaine";
        break;
      case "1":
        weekRoot = "Chaque semaine paire";
        break;
      case "2":
        weekRoot = "Chaque semaine impaire";
        break;
    }

    for (int i = 2; i < 10; i++) {
      if (parsed[i] == "1") {
        days.add(daysList[i - 2]);
      }
    }

    switch (parsed[1]) {
      case "0":
        end = " " + "tous les" + " " + days.join(", ") + ".";
        break;
      case "1":
        end = " " + "tous les jours.";
        break;
    }
    return weekRoot + end;
  }
}
