import 'dart:async';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
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
class Offline {
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

  //Called when instanciated
  init() async {
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
    final dir = await FolderAppUtil.getDirectory();
    try {
      Hive.init("${dir.path}/offline");
      offlineBox = await Hive.openBox("offlineData");
      homeworkDoneBox = await Hive.openBox('doneHomework');
      pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
    } catch (e) {}
    homework = HomeworkOffline();
    doneHomework = DoneHomeworkOffline();
    pinnedHomework = PinnedHomeworkOffline();
    agendaEvents = AgendaEventsOffline();
    reminders = RemindersOffline();
    lessons = LessonsOffline();
    disciplines = DisciplinesOffline();
    polls = PollsOffline();
    recipients = RecipientsOffline();
  }

  //Refresh lists when needed
  refreshData() async {
    print("Refreshing offline");
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

  //Clear all databases
  clearAll() async {
    try {
      if (!offlineBox.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      if (!homeworkDoneBox.isOpen) {
        homeworkDoneBox = await Hive.openBox("doneHomework");
      }
      if (!pinnedHomeworkBox.isOpen) {
        pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
      }
      try {
        await offlineBox.clear();
      } catch (e) {}
      try {
        await homeworkDoneBox.clear();
      } catch (e) {}
      try {
        await pinnedHomeworkBox.clear();
      } catch (e) {}
      try {
        disciplinesData.clear();
      } catch (e) {}
      try {
        remindersData.clear();
      } catch (e) {}
      try {
        homeworkData.clear();
      } catch (e) {}
      try {
        lessonsData.clear();
      } catch (e) {}
      try {
        pollsData.clear();
      } catch (e) {}
      try {
        agendaEventsData.clear();
      } catch (e) {}
    } catch (e) {
      print("Failed to clear all db " + e.toString());
    }
  }

}
