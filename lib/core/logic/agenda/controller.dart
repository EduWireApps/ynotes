import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

enum eventTypes { spaceEvents, dayEvents }

class AgendaController extends ChangeNotifier {
  final String _dbKey = 'todoList';
  late Box<dynamic> _db;
  DateTime? _date;
  DateTime? _oldDate;
  Map<dynamic, List<AgendaEvent>>? _cachedAgendaEvents;
  bool _yesterdayLoaded = false;
  bool _todayLoaded = false;
  bool _tomorrowLoaded = false;
  late API _api;
  List<AgendaEvent>? _yesterday;
  List<AgendaEvent>? _today;
  List<AgendaEvent>? _tomorrow;

  List<AgendaEvent>? get yesterday => _yesterday;
  List<AgendaEvent>? get today => _today;
  List<AgendaEvent>? get tomorrow => _tomorrow;
  bool get todayLoaded => _yesterdayLoaded;
  bool get tomorrowLoaded => _todayLoaded;
  bool get yesterdayLoaded => _tomorrowLoaded;

  List week = [];
  List<bool> loaded = [];
  List cachedEvents = [];

  //Constructor
  AgendaController(Box<dynamic> db, API api) {
    _db = db;
    _api = api;
    setDay(DateTime.now());
    _cachedAgendaEvents = _db.containsKey(_dbKey) ? _db.get(_dbKey) : {};
  }
  void setDay(DateTime date) async {
    _date = date;
    _oldDate = _date;
    await getAgendaEvents();
  }

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

  getAgendaEvents() async {
    if (CalendarTime(_oldDate).startOfDay == _date!.subtract(Duration(days: 1))) {}

    cachedEvents[3] = await _api.getEvents(CalendarTime(_date).startOfDay, false);
    loaded[3] = true;
    int i = 0;

    await Future.forEach(week, (dynamic date) async {
      if (i != 3) {
        cachedEvents[i] = await _api.getEvents(date, false);
        loaded[i] = true;
      }
      i++;
    });
  }
}
