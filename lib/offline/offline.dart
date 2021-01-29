import 'dart:async';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/UI/screens/settings/sub_pages/logsPage.dart';
import 'package:ynotes/offline/data/agenda/events.dart';
import 'package:ynotes/offline/data/agenda/reminders.dart';
import 'package:ynotes/offline/data/agenda/lessons.dart';

import 'package:ynotes/offline/data/disciplines/disciplines.dart';
import 'package:ynotes/offline/data/homework/homework.dart';
import 'package:ynotes/offline/data/homework/doneHomework.dart';
import 'package:ynotes/offline/data/homework/pinnedHomework.dart';
import 'package:ynotes/offline/data/mails/recipients.dart';
import 'package:ynotes/offline/data/polls/polls.dart';
import 'package:ynotes/utils/fileUtils.dart';

import 'package:ynotes/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/usefulMethods.dart';
import '../apis/utils.dart';
import '../classes.dart';

///An offline class to deal with the `hivedb` package
///used to store offline data and stored values such as agenda events
///The "locked" boolean avoid database unwanted modifications on another thread
///Unlock it on another thread/isolate could `definitely break the user database, so please be cautious`.
class Offline {
  //To use in isolate in order to read only
  final bool locked;

  //Return disciplines + grades
  List<Discipline> disciplinesData;
  //Return homework
  List<Homework> homeworkData;
  //Return lessons
  Map<dynamic, dynamic> lessonsData;
  //Return polls
  List<PollInfo> pollsData;
  //Return agenda reminder
  List<AgendaReminder> remindersData;
  //Return agenda event
  Map<dynamic, dynamic> agendaEventsData;
  //Return recipients
  List<Recipient> recipientsData;
  //Boxes containing offline data
  Box offlineBox;
  Box homeworkDoneBox;
  Box pinnedHomeworkBox;

//Imports
  HomeworkOffline homework;
  DoneHomeworkOffline doneHomework;
  PinnedHomeworkOffline pinnedHomework;
  AgendaEventsOffline agendaEvents;
  RemindersOffline reminders;
  LessonsOffline lessons;

  DisciplinesOffline disciplines;

  PollsOffline polls;

  RecipientsOffline recipients;

  Offline(this.locked);
  //Called on dispose
  void dispose() async {
    await Hive.close();
  }

  //Called when instanciated
  init() async {
    if (!locked) {
      //Register adapters once
      try {
        Hive.registerAdapter(GradeAdapter());
        Hive.registerAdapter(DisciplineAdapter());
        Hive.registerAdapter(DocumentAdapter());
        Hive.registerAdapter(HomeworkAdapter());
        Hive.registerAdapter(LessonAdapter());
        Hive.registerAdapter(PollInfoAdapter());
        Hive.registerAdapter(AgendaReminderAdapter());
        Hive.registerAdapter(AgendaEventAdapter());
        Hive.registerAdapter(RecipientAdapter());
        Hive.registerAdapter(alarmTypeAdapter());
      } catch (e) {
        print("Error " + e.toString());
      }
      var dir = await FolderAppUtil.getDirectory();
      try {
        Hive.init("${dir.path}/offline");
        offlineBox = await safeBoxOpen("offlineData");
        homeworkDoneBox = await safeBoxOpen('doneHomework');
        pinnedHomeworkBox = await safeBoxOpen('pinnedHomework');
      } catch (e) {
        print(e);
      }
    }
    homework = HomeworkOffline(this.locked);
    doneHomework = DoneHomeworkOffline(this.locked);
    pinnedHomework = PinnedHomeworkOffline(this.locked);
    agendaEvents = AgendaEventsOffline(this.locked);
    reminders = RemindersOffline(this.locked);
    lessons = LessonsOffline(this.locked);
    disciplines = DisciplinesOffline(this.locked);
    polls = PollsOffline(this.locked);
    recipients = RecipientsOffline(this.locked);
  }

  safeBoxOpen(String boxName) async {
    try {
      Box box = await Hive.openBox(boxName);
      print("Correctly opened box");
      return box;
    } catch (e) {
      if (boxName.contains("offlineData")) await deleteCorruptedBox(boxName);
      await init();
      await logFile("Error while opening $boxName");
      print("Error while opening $boxName");
      throw ("Error while opening $boxName");
    }
  }

  ///DIRTY FIX
  ///Deletes corrupted box
  deleteCorruptedBox(String boxName) async {
    await Hive.deleteBoxFromDisk(boxName);
  }

  //Refresh lists when needed
  refreshData() async {
    print("Refreshing offline");
    if (!locked) {
      try {
        if (offlineBox == null || !offlineBox.isOpen) {
          offlineBox = await Hive.openBox("offlineData");
        }
        //Get data and cast it
        var offlineLessonsData = await offlineBox.get("lessons");
        var offlineDisciplinesData = await offlineBox.get("disciplines");
        var offlinehomeworkData = await offlineBox.get("homework");
        var offlinePollsData = await offlineBox.get("polls");
        var offlineRemindersData = await offlineBox.get("reminders");
        var offlineAgendaEventsData = await offlineBox.get("agendaEvents");
        var offlineRecipientsData = await offlineBox.get("recipients");
        //ensure that fetched data isn't null and if not, add it to the final value
        if (offlineLessonsData != null) {
          this.lessonsData = Map<dynamic, dynamic>.from(offlineLessonsData);
        }
        if (offlineDisciplinesData != null) {
          this.disciplinesData = offlineDisciplinesData.cast<Discipline>();
        }
        if (offlinehomeworkData != null) {
          this.homeworkData = offlinehomeworkData.cast<Homework>();
        }
        if (offlinePollsData != null) {
          this.pollsData = offlinePollsData.cast<PollInfo>();
        }
        if (offlineRemindersData != null) {
          this.remindersData = offlineRemindersData.cast<AgendaReminder>();
        }
        if (offlineAgendaEventsData != null) {
          this.agendaEventsData = Map<dynamic, dynamic>.from(offlineAgendaEventsData);
        }
        if (offlineRecipientsData != null) {
          this.recipientsData = offlineRecipientsData.cast<Recipient>();
        }
      } catch (e) {
        print("Error while refreshing " + e.toString());
      }
    }
  }

  //Clear all databases
  clearAll() async {
    try {
      await Hive.deleteFromDisk();
    } catch (e) {
      print("Failed to clear all db " + e.toString());
    }
  }
}
