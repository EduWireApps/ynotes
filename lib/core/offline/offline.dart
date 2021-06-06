import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/fileUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logsPage.dart';

class HiveBoxProvider {
  static Future<dynamic>? _initFlutterFuture;

  Future deleteBox(String name) async {
    return await Hive.deleteBoxFromDisk(name);
  }

  Future<Box<TValue>> openBox<TValue>(String name) async {
    await init();
    return await Hive.openBox<TValue>(name);
  }

  static Future close() async {
    _initFlutterFuture = null;
    await Hive.close();
  }

  static Future init() async {
    if (_initFlutterFuture == null) {
      var dir = await FolderAppUtil.getDirectory();
      try {
        Hive.init("${dir.path}/offline");
      } catch (e) {
        print("Issue while initing Hive : " + e.toString());
      }
      registerAdapters();
    }
    await _initFlutterFuture;
  }

  static void registerAdapters() {
    _registerAdapter(GradeAdapter());
    _registerAdapter(HomeworkAdapter());
    _registerAdapter(DisciplineAdapter());
    _registerAdapter(DocumentAdapter());
    _registerAdapter(LessonAdapter());
    _registerAdapter(PollInfoAdapter());
    _registerAdapter(AgendaReminderAdapter());
    _registerAdapter(AgendaEventAdapter());
    _registerAdapter(RecipientAdapter());
    _registerAdapter(SchoolLifeTicketAdapter());
    _registerAdapter(AlarmTypeAdapter());
  }

  static void _registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter<T>(adapter);
    }
  }
}

///An offline class to deal with the `hivedb` package
///used to store offline data and stored values such as agenda events
///The "locked" boolean avoid database unwanted modifications on another thread
///Unlock it on another thread/isolate could `definitely break the user database, so please be cautious`.
class Offline {
  //Boxes name
  static final String offlineCacheBoxName = "offlineData";
  static final String doneHomeworkBoxName = "doneHomework";
  static final String homeworkBoxName = "homework";
  static final String pinnedHomeworkBoxName = "pinnedHomework";
  static final String agendaBoxName = "agenda";

  Box? offlineBox;
  Box? homeworkDoneBox;
  Box? pinnedHomeworkBox;
  Box? homeworkBox;
  Box? agendaBox;
/*
  //Imports
  late HomeworkOffline homework;
  late DoneHomeworkOffline doneHomework;
  late PinnedHomeworkOffline pinnedHomework;
  late AgendaEventsOffline agendaEvents;
  late RemindersOffline reminders;
  late LessonsOffline lessons;
  late SchoolLifeOffline schoolLife;
  late DisciplinesOffline disciplines;

  late PollsOffline polls;

  late RecipientsOffline recipients;
*/
  Offline();
  //Called on dispose
  clearAll() async {
    try {
      await offlineBox?.deleteFromDisk();
      await homeworkDoneBox?.deleteFromDisk();
      await pinnedHomeworkBox?.deleteFromDisk();
      await homeworkBox?.deleteFromDisk();
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
    //Register adapters once

    try {
      offlineBox = await safeBoxOpen(offlineCacheBoxName);
      homeworkDoneBox = await appSys.hiveBoxProvider.openBox(doneHomeworkBoxName);
      homeworkBox = await appSys.hiveBoxProvider.openBox(homeworkBoxName);
      pinnedHomeworkBox = await appSys.hiveBoxProvider.openBox(pinnedHomeworkBoxName);
      agendaBox = await appSys.hiveBoxProvider.openBox(agendaBoxName);
      print("All boxes opened");
    } catch (e) {
      print("Issue while opening boxes : " + e.toString());
    }
  }

  //Refresh lists when needed
  safeBoxOpen(String boxName) async {
    try {
      Box box = await appSys.hiveBoxProvider.openBox(boxName).catchError((e) async {
        await logFile("Error while opening $boxName");
        throw ("Something bad happened.");
      });
      print("Correctly opened $boxName");
      return box;
    } catch (e) {
      print("Error while opening $boxName");
      if (boxName.contains("offlineData")) {
        await appSys.hiveBoxProvider.deleteBox(boxName);
      }
      await this.init();

      throw ("Error while opening $boxName");
    }
  }
}
