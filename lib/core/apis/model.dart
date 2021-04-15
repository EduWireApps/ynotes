import 'dart:core';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/services/space/recurringEvents.dart';
import 'package:ynotes/globals.dart';

enum apiType { EcoleDirecte, Pronote }

abstract class API {
  bool loggedIn = false;
  final Offline? offlineController;

  API(this.offlineController);

  ///Connect to the API
  ///Should return a connection status
  Future<List> login(username, password, {url, cas, mobileCasLogin});

  ///Get years periods
  Future<List<Period>> getPeriods();

  ///Get marks
  Future<List<Discipline>> getGrades({bool? forceReload});

  ///Get the dates of next homework (deprecated)
  Future<List<DateTime>> getDatesNextHomework();

  ///Get the list of all the next homework (sent by specifics API).
  ///
  ///Caution : `EcoleDirecte` api returns a list of unloaded homework
  Future<List<Homework>> getNextHomework({bool? forceReload});

  ///Get the list of homework only for a specific day (time travel feature)
  Future<List<Homework>?> getHomeworkFor(DateTime? dateHomework);

  //Get a list of lessons for the agenda part
  Future<List<Lesson>?> getNextLessons(DateTime from, {bool? forceReload});

  ///Test to know if there are new grades
  Future<bool?> testNewGrades();

  ///Send file to cloud or anywhere
  Future uploadFile(String context, String id, String filepath);

  ///Download a file from his name
  Future<Request> downloadRequest(Document document);

  ///Apps
  Future app(String appname, {String? args, String? action, CloudItem? folder});

  ///All events
  Future<List<AgendaEvent>?> getEvents(DateTime date, bool afterSchool, {bool forceReload = false}) async {
    List<AgendaEvent> events = [];
    List<AgendaEvent>? extracurricularEvents = [];
    List<Lesson>? lessons = await (appSys.api!.getNextLessons(date, forceReload: forceReload));
    int week = await get_week(date);
    //Add lessons for this day
    if (lessons != null) {
      events.addAll(AgendaEvent.eventsFromLessons(lessons));
      //Add extracurricular events
      lessons.sort((a, b) => a.end!.compareTo(b.end!));
    }
    if (!afterSchool) {
      extracurricularEvents = await (appSys.offline!.agendaEvents.getAgendaEvents(week) as Future<List<AgendaEvent>>);
      if (extracurricularEvents != null) {
        if (lessons != null && lessons.length > 0) {
          //Last date
          DateTime? lastLessonEnd = lessons.last.end;
          //delete the last one

          extracurricularEvents.removeWhere((event) =>
              DateTime.parse(DateFormat("yyyy-MM-dd").format(event.start!)) !=
              DateTime.parse(DateFormat("yyyy-MM-dd").format(date)));
          /*if (lessons.last.end != null) {
            extracurricularEvents.removeWhere((element) => element.start.isAfter(lastLessonEnd));
          }*/
        }
        //merge
        for (AgendaEvent extracurricularEvent in extracurricularEvents) {
          events.removeWhere((element) => element.id == extracurricularEvent.id);
        }
      }
    } else {
      extracurricularEvents = await (appSys.offline!.agendaEvents.getAgendaEvents(week) as Future<List<AgendaEvent>>);

      if (extracurricularEvents != null) {
        //extracurricularEvents.removeWhere((element) => element.isLesson);
        if (lessons != null && lessons.length > 0) {
          //Last date
          DateTime? lastLessonEnd = lessons.last.end;
          //delete the last one
          extracurricularEvents.removeWhere((event) =>
              DateTime.parse(DateFormat("yyyy-MM-dd").format(event.start!)) !=
              DateTime.parse(DateFormat("yyyy-MM-dd").format(date)));
          //extracurricularEvents.removeWhere((event) => event.start.isBefore(lastLessonEnd));
        }
        //merge
        for (AgendaEvent extracurricularEvent in extracurricularEvents) {
          events.removeWhere((element) => element.id == extracurricularEvent.id);
        }
      }
    }
    if (extracurricularEvents != null) {
      events.addAll(extracurricularEvents);
    }
    RecurringEventSchemes recurr = RecurringEventSchemes();
    recurr.date = date;
    recurr.week = week;
    var recurringEvents = await appSys.offline!.agendaEvents.getAgendaEvents(week, selector: recurr.testRequest);
    if (recurringEvents != null && recurringEvents.length != 0) {
      recurringEvents.forEach((recurringEvent) {
        events.removeWhere((element) => element.id == recurringEvent.id);
        if (recurringEvent.start != null && recurringEvent.end != null) {
          recurringEvent.start =
              DateTime(date.year, date.month, date.day, recurringEvent.start!.hour, recurringEvent.start!.minute);
          recurringEvent.end =
              DateTime(date.year, date.month, date.day, recurringEvent.end!.hour, recurringEvent.end!.minute);
        }
      });

      events.addAll(recurringEvents);
    } else {}
    return events as Future<List<AgendaEvent>>;
  }

  List<Grade>? gradesList;
}
