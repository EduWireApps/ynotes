import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/data/agenda/events.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/services/space/recurring_events.dart';
import 'package:ynotes/core/utils/bugreport_utils.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/globals.dart';

part 'model.g.dart';

abstract class API {
  bool loggedIn = false;
  final Offline offlineController;
  final String apiName;

  List<Grade>? gradesList;

  API(this.offlineController, {required this.apiName});

  Future<AppAccount?> account() async {
    String? appAccount = await KVS.read(key: "appAccount");
    if (appAccount != null) {
      CustomLogger.log("API MODEL", "Returning account");
      return AppAccount.fromJson(jsonDecode(appAccount));
    } else {
      return null;
    }
  }

  ///Get the API status (down etc..;)
  Future<List> apiStatus();

  ///Apps
  app(String appname, {String? args, String? action, CloudItem? folder});

  ///Download a file from his name
  Future<Request> downloadRequest(Document document);

  ///All events
  Future<List<AgendaEvent>?> getEvents(DateTime date,
      {bool forceReload = false}) async {
    List<AgendaEvent> events = [];
    List<AgendaEvent>? extracurricularEvents = [];
    List<Lesson>? lessons =
        await (appSys.api!.getNextLessons(date, forceReload: forceReload));
    int week = await getWeek(date);
    //Add lessons for this day
    if (lessons != null) {
      events.addAll(AgendaEvent.eventsFromLessons(lessons));
      //Add extracurricular events
      lessons.sort((a, b) => a.end!.compareTo(b.end!));
    }

    events.addAll(extracurricularEvents);
    RecurringEventSchemes recurr = RecurringEventSchemes();
    recurr.date = date;
    recurr.week = week;
    var recurringEvents = await AgendaEventsOffline(appSys.offline)
        .getAgendaEvents(week, selector: recurr.testRequest);
    if (recurringEvents != null && recurringEvents.isNotEmpty) {
      for (var recurringEvent in recurringEvents) {
        events.removeWhere((element) => element.id == recurringEvent.id);
        if (recurringEvent.start != null && recurringEvent.end != null) {
          recurringEvent.start = DateTime(date.year, date.month, date.day,
              recurringEvent.start!.hour, recurringEvent.start!.minute);
          recurringEvent.end = DateTime(date.year, date.month, date.day,
              recurringEvent.end!.hour, recurringEvent.end!.minute);
        }
      }

      events.addAll(recurringEvents);
    } else {}
    return events;
  }

  ///Get marks
  Future<List<Discipline>?> getGrades({bool? forceReload});

  ///Get the list of homework only for a specific day (time travel feature)
  Future<List<Homework>?> getHomeworkFor(DateTime? dateHomework,
      {bool? forceReload});

  //Get a list of lessons for the agenda part
  ///Get the list of all the next homework (sent by specifics API).
  ///
  ///Caution : `EcoleDirecte` api returns a list of unloaded homework
  Future<List<Homework>?> getNextHomework({bool? forceReload});

  Future<List<Lesson>?> getNextLessons(DateTime from, {bool? forceReload});

  ///SchoolLife
  Future<List<SchoolLifeTicket>?> getSchoolLife({bool forceReload = false});

  ///Connect to the API
  ///Should return a connection status
  Future<List> login(username, password, {Map? additionnalSettings});

  ///Test to know if there are new grades
  Future<bool?> testNewGrades();

  ///Send file to cloud or anywhere
  Future uploadFile(String context, String id, String filepath);
}

enum API_TYPE { ecoleDirecte, pronote }

@JsonSerializable()
class AppAccount {
  //User name
  final String? name;
  final String? surname;

  ///this is an internal ID used to name the offline boxes
  ///IT HAS TO BE GENERATED USING UUID, using provided API ID might be a security issue (offline boxes are named with this ID)
  final String? id;
  //additionnal settings
  final Map? apiSettings;
  //if a parent can manage accounts
  final bool isParentMainAccount;
  final API_TYPE apiType;
  //other accounts
  final List<SchoolAccount>? managableAccounts;
  AppAccount({
    this.name,
    this.surname,
    this.id,
    required this.managableAccounts,
    this.apiSettings,
    required this.isParentMainAccount,
    required this.apiType,
  });
  factory AppAccount.fromJson(Map<String, dynamic> json) =>
      _$AppAccountFromJson(json);
  Map<String, dynamic> toJson() => _$AppAccountToJson(this);
}

@JsonSerializable()
class SchoolAccount {
  //Name of the student
  final String? name;

  final String? surname;

  final String? schoolName;

  //Class of the student
  final String? studentClass;

  final String? studentID;

  final String? profilePicture;
  //Tabs the student can have access to
  List<appTabs> availableTabs;

  ///Configuration credentials
  Map? credentials;
  SchoolAccount(
      {this.name,
      this.studentClass,
      this.studentID,
      required this.availableTabs,
      this.surname,
      this.schoolName,
      this.profilePicture})
      : super();
  factory SchoolAccount.fromJson(Map<String, dynamic> json) =>
      _$SchoolAccountFromJson(json);
  Map<String, dynamic> toJson() => _$SchoolAccountToJson(this);
}

///Main converter class
///Every converter has to use it
class YConverter {
  final API_TYPE apiType;
  final String? logSlot;
  final Function converter;
  final Function? anonymizer;

  YConverter({
    required this.apiType,
    required this.converter,
    this.anonymizer,
    this.logSlot,
  });

  convert(data) {
    if (logSlot != null && anonymizer != null) {
      try {
        final String anonymizedData = anonymizer!(data);
        LogsManager.saveLogs(
            logs: [YLog(category: logSlot!, comment: anonymizedData)],
            category: logSlot!);
        BugReportUtils.prepareReportData();
      } catch (e) {
        CustomLogger.log("CONVERTER", "Error anonymizing data");
      }
    }
    return converter(data);
  }
}
