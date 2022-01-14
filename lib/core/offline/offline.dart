import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/legacy/file_utils.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/app/app.dart';

import 'data/example/example.dart';

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
      try {
        if (kIsWeb) {
          await Hive.initFlutter();
        } else {
          var dir = await FolderAppUtil.getDirectory();
          Hive.init("${dir.path}/offline");
        }
      } catch (e) {
        CustomLogger.log("OFFLINE", "An error occured while initiating Hive");
        CustomLogger.error(e, stackHint: "MTQ=");
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
    _registerAdapter(MailAdapter());
    _registerAdapter(PollChoiceAdapter());
    _registerAdapter(PollQuestionAdapter());
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
  static const String offlineCacheBoxName = "offlineData";
  static const String doneHomeworkBoxName = "doneHomework";
  static const String homeworkBoxName = "homework";
  static const String pinnedHomeworkBoxName = "pinnedHomework";
  static const String agendaBoxName = "agenda";
  static const String mailsBoxName = "mails";
  DateTime? dateOfOpening;
  //sample box for example.dart (do not delete)
  Box<Example>? exampleBox;

  //boxes
  Box? offlineBox;
  Box? homeworkDoneBox;
  Box? pinnedHomeworkBox;
  Box? homeworkBox;
  Box? agendaBox;
  Box<Mail>? mailsBox;

  Offline() {
    dateOfOpening = DateTime.now();
  }
  //Called on dispose
  clearAll() async {
    try {
      await offlineBox?.deleteFromDisk();
      await homeworkDoneBox?.deleteFromDisk();
      await pinnedHomeworkBox?.deleteFromDisk();
      await homeworkBox?.deleteFromDisk();
      await mailsBox?.deleteFromDisk();
      await homeworkBox?.deleteFromDisk();

      await init();
    } catch (e) {
      CustomLogger.log("OFFLINE", "Failed to clear all db");
      CustomLogger.error(e, stackHint: "MTU=");
    }
  }

  ///DIRTY FIX
  ///Deletes corrupted box
  deleteCorruptedBox(String boxName) async {
    await Hive.deleteBoxFromDisk(boxName);
    CustomLogger.log("OFFLINE", "Recovered $boxName");
  }

  //Called when instanciated
  void dispose() async {
    await Hive.close();
    CustomLogger.log("OFFLINE", "Disposed Hive");
  }

  init() async {
    CustomLogger.log("OFFLINE", "Init");
    //Register adapters once

    try {
      offlineBox = await safeBoxOpen(offlineCacheBoxName);
      homeworkDoneBox = await appSys.hiveBoxProvider.openBox(doneHomeworkBoxName);
      homeworkBox = await appSys.hiveBoxProvider.openBox(homeworkBoxName);
      pinnedHomeworkBox = await appSys.hiveBoxProvider.openBox(pinnedHomeworkBoxName);
      agendaBox = await appSys.hiveBoxProvider.openBox(agendaBoxName);
      mailsBox = await appSys.hiveBoxProvider.openBox<Mail>(mailsBoxName);

      CustomLogger.log("OFFLINE", "All boxes opened");
    } catch (e) {
      CustomLogger.log("OFFLINE", "An error occured while opening boxes");
      CustomLogger.error(e, stackHint: "MTY=");
    }
  }

  //Refresh lists when needed
  safeBoxOpen(String boxName) async {
    try {
      Box box = await appSys.hiveBoxProvider.openBox(boxName).catchError((e) async {
        final String errorMessage = "Error while opening $boxName";
        CustomLogger.error("OFFLINE: $errorMessage");
        throw (errorMessage);
      });
      CustomLogger.log("OFFLINE", "Correctly opened $boxName");
      return box;
    } catch (e) {
      CustomLogger.log("OFFLINE", "An error occurend while opening $boxName");
      CustomLogger.error(e, stackHint: "MTc=");
      if (boxName.contains("offlineData")) {
        await appSys.hiveBoxProvider.deleteBox(boxName);
      }
      await init();

      throw ("Error while opening $boxName");
    }
  }
}
