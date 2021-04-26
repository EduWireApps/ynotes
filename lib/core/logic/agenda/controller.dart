import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

class AgendaController extends ChangeNotifier {
  DateTime? _date;
  DateTime? _oldDate;

  late API? _api;

  List week = List.filled(7, null);
  List<bool> loaded = List.filled(7, false);
  List<List<AgendaEvent>?>? _cachedEvents = List.filled(7, []);
  AgendaController(API? api) {
    _api = api;
    setDay(DateTime.now());
  }
  List<AgendaEvent>? get today => (_cachedEvents ?? [])[3];
  bool get todayLoaded => loaded[3];

  List<AgendaEvent>? get tomorrow => (_cachedEvents ?? [])[4];
  bool get tomorrowLoaded => loaded[4];
  List<AgendaEvent>? get yesterday => (_cachedEvents ?? [])[2];

  //Constructor
  bool get yesterdayLoaded => loaded[2];

  filterEvents(eventTypes eventType, List<AgendaEvent> events) {
    List<AgendaEvent> dayEvents = [];
    DateTime? dayEventsEnd;

    events.forEach((event) {
      if (event.isLesson!) {
        dayEvents.add(event);
      }
    });
    if (dayEvents != null) {
      dayEvents.sort((a, b) => a.end!.compareTo(b.end!));
      dayEventsEnd = dayEvents.last.end;
    }

    if (eventType == eventTypes.dayEvents) {
      return events.where((event) =>
          event.end!.isAfter(dayEventsEnd!) ||
          event.start!.isAfter(dayEventsEnd) ||
          event.start!.isAtSameMomentAs(dayEventsEnd));
    } else {
      return events.where((event) => event.start!.isBefore(dayEventsEnd!));
    }
  }

  getAgendaEvents() async {
    List<List<AgendaEvent>?>? oldEvents = [];
    //We clone the old events
    oldEvents.addAll((_cachedEvents ?? []));

    //we reset the cached events
    _cachedEvents = List.filled(7, []);

    //We reproduce the old week
    var oldweek = List.filled(7, DateTime.now());
    oldweek[0] = CalendarTime(_oldDate).startOfDay.subtract(Duration(days: 3));
    oldweek[1] = CalendarTime(_oldDate).startOfDay.subtract(Duration(days: 2));
    oldweek[2] = CalendarTime(_oldDate).startOfDay.subtract(Duration(days: 1));
    oldweek[3] = CalendarTime(_oldDate).startOfDay;
    oldweek[4] = CalendarTime(_oldDate).startOfDay.add(Duration(days: 1));
    oldweek[5] = CalendarTime(_oldDate).startOfDay.add(Duration(days: 2));
    oldweek[6] = CalendarTime(_oldDate).startOfDay.add(Duration(days: 3));

    //We search for old week elements that are still present in the new week
    if (week.any((element) => oldweek.contains(element))) {
      oldweek.forEach((oldWeekDate) {
        for (int i = 0; i < week.length; i++) {
          if (week[i] == oldWeekDate) {
            //We add these events
            (_cachedEvents ?? [])[i] = [];
            (_cachedEvents ?? [])[i]!.addAll(oldEvents[i] ?? []);
          }
        }
      });
    }
    if ((_cachedEvents ?? [])[3] == null) {
      (_cachedEvents ?? [])[3] = await _api?.getEvents(CalendarTime(_date).startOfDay, false, forceReload: false);
    }

    loaded[3] = true;
    int i = 0;
    notifyListeners();

    //We offline fetch the rest
    await Future.forEach(week, (dynamic date) async {
      if (i != 3 && (_cachedEvents ?? [])[i] != null) {
        (_cachedEvents ?? [])[i] = (await _api?.getEvents(date, false, forceReload: false)) ?? [];
        loaded[i] = true;
        notifyListeners();
      }
      i++;
    });
    print("Agenda events set");
  }

  initWeek() {
    week[0] = CalendarTime(_date).startOfDay.subtract(Duration(days: 3));
    week[1] = CalendarTime(_date).startOfDay.subtract(Duration(days: 2));
    week[2] = CalendarTime(_date).startOfDay.subtract(Duration(days: 1));
    week[3] = CalendarTime(_date).startOfDay;
    week[4] = CalendarTime(_date).startOfDay.add(Duration(days: 1));
    week[5] = CalendarTime(_date).startOfDay.add(Duration(days: 2));
    week[6] = CalendarTime(_date).startOfDay.add(Duration(days: 3));
    for (int i = 0; i < 7; i++) {
      loaded[i] = false;
    }
  }

  Future<void> setDay(DateTime date) async {
    _oldDate = _date;
    _date = date;

    initWeek();
    await getAgendaEvents();
  }
}

enum eventTypes { spaceEvents, dayEvents }
