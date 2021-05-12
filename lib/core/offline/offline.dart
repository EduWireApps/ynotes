import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/data/agenda/events.dart';
import 'package:ynotes/core/offline/data/agenda/lessons.dart';
import 'package:ynotes/core/offline/data/agenda/reminders.dart';
import 'package:ynotes/core/offline/data/disciplines/disciplines.dart';
import 'package:ynotes/core/offline/data/homework/doneHomework.dart';
import 'package:ynotes/core/offline/data/homework/homework.dart';
import 'package:ynotes/core/offline/data/homework/pinnedHomework.dart';
import 'package:ynotes/core/offline/data/mails/recipients.dart';
import 'package:ynotes/core/offline/data/polls/polls.dart';
import 'package:ynotes/core/utils/fileUtils.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logsPage.dart';

///An offline class to deal with the `hivedb` package
///used to store offline data and stored values such as agenda events
///The "locked" boolean avoid database unwanted modifications on another thread
///Unlock it on another thread/isolate could `definitely break the user database, so please be cautious`.
class Offline {
  //To use in isolate in order to read only
  final bool locked;

  //Return disciplines + grades
  List<Discipline>? disciplinesData;
  //Return homework
  List<Homework>? homeworkData;
  //Return lessons
  Map<dynamic, dynamic>? lessonsData;
  //Return polls
  List<PollInfo>? pollsData;
  //Return agenda reminder
  List<AgendaReminder>? remindersData;
  //Return agenda event
  Map<dynamic, dynamic>? agendaEventsData;
  //Return recipients
  List<Recipient>? recipientsData;
  //Boxes containing offline data
  Box? offlineBox;
  Box? homeworkDoneBox;
  Box? pinnedHomeworkBox;
  Box? agendaBox;

//Imports
  late HomeworkOffline homework;
  late DoneHomeworkOffline doneHomework;
  late PinnedHomeworkOffline pinnedHomework;
  late AgendaEventsOffline agendaEvents;
  late RemindersOffline reminders;
  late LessonsOffline lessons;

  late DisciplinesOffline disciplines;

  late PollsOffline polls;

  late RecipientsOffline recipients;

  Offline(this.locked);
  //Called on dispose
  clearAll() async {
    try {
      if (offlineBox == null || !offlineBox!.isOpen) {
        offlineBox = await Hive.openBox("offlineData");
      }
      if (homeworkDoneBox == null || !homeworkDoneBox!.isOpen) {
        homeworkDoneBox = await Hive.openBox("doneHomework");
      }
      if (pinnedHomeworkBox == null || !pinnedHomeworkBox!.isOpen) {
        pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
      }
      if (agendaBox == null || !agendaBox!.isOpen) {
        agendaBox = await Hive.openBox("agenda");
      }
      await offlineBox!.deleteFromDisk();
      await homeworkDoneBox!.deleteFromDisk();
      await pinnedHomeworkBox!.deleteFromDisk();
      disciplinesData?.clear();
      homeworkData?.clear();
      lessonsData?.clear();
      remindersData?.clear();
      agendaEventsData?.clear();
      recipientsData?.clear();
      await this.init();
    } catch (e) {
      print("Failed to clear all db " + e.toString());
    }
  }

  ///DIRTY FIX
  ///Deletes corrupted box
  deleteCorruptedBox(String boxName) async {
    await Hive.deleteBoxFromDisk(boxName);
    await logFile("Recovered $boxName");
  }

  //Called when instanciated
  void dispose() async {
    await Hive.close();
    print("Disposed hive");
  }

  init() async {
    print("Init offline");
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
        homeworkDoneBox = await Hive.openBox('doneHomework');
        pinnedHomeworkBox = await Hive.openBox('pinnedHomework');
        agendaBox = await Hive.openBox("agenda");
        print("All boxes opened");
      } catch (e) {
        print("Issue while opening boxes : " + e.toString());
      }
    }
    initObjects();
  }

  initObjects() {
    homework = HomeworkOffline(this.locked, this);
    doneHomework = DoneHomeworkOffline(this.locked, this);
    pinnedHomework = PinnedHomeworkOffline(this.locked, this);
    agendaEvents = AgendaEventsOffline(this.locked, this);
    reminders = RemindersOffline(this.locked, this);
    lessons = LessonsOffline(this.locked, this);
    disciplines = DisciplinesOffline(this.locked, this);
    polls = PollsOffline(this.locked, this);
    recipients = RecipientsOffline(this.locked, this);
  }

  openBoxes() {}

  refreshData() async {
    if (!locked) {
      print("Refreshing offline");
      try {
        //Get data and cast it
        var offlineLessonsData = await agendaBox?.get("lessons");
        var offlineDisciplinesData = await offlineBox?.get("disciplines");
        var offlinehomeworkData = await offlineBox?.get("homework");
        var offlinePollsData = await offlineBox?.get("polls");
        var offlineRemindersData = await agendaBox?.get("reminders");
        var offlineAgendaEventsData = await agendaBox?.get("agendaEvents");
        var offlineRecipientsData = await offlineBox?.get("recipients");
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

  //Refresh lists when needed
  safeBoxOpen(String boxName) async {
    try {
      Box box = await Hive.openBox(boxName).catchError((e) async {
        await logFile("Error while opening $boxName");
        throw ("Something bad happened.");
      });
      print("Correctly opened $boxName");
      return box;
    } catch (e) {
      print("Error while opening $boxName");
      if (boxName.contains("offlineData")) {
        await deleteCorruptedBox(boxName);
      }
      await init();

      throw ("Error while opening $boxName");
    }
  }

  //Clear all databases
  test() {
    print(offlineBox);
  }
}
