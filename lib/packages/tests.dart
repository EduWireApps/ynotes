import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ynotes/core/utils/file_utils.dart';

import 'school_api/school_api.dart';

class _OfflineStore {
  bool initialized = false;
}

class Offline {
  Offline._();

  static final store = _OfflineStore();

  static Future<void> init() async {
    if (store.initialized) {
      return;
    }
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      var dir = await FolderAppUtil.getDirectory();
      Hive.init("${dir.path}/offlineTest"); // TODO: change this
    }
    _registerAdapters();
    store.initialized = true;
  }

  static void _registerAdapters() {
    Hive.registerAdapter(SchoolLifeTicketAdapter());
  }
}

abstract class OfflineModel {
  final String key;
  Box? box;
  OfflineModel(this.key);

  Future<void> init() async {
    if (!Offline.store.initialized) {
      await Offline.init();
    }
    box = Hive.isBoxOpen(key) ? Hive.box(key) : await Hive.openBox(key);
    print("init $key");
  }

  Future<void> delete(String key) async {
    await box?.delete(key);
  }

  Future<void> reset() async {
    await box?.deleteFromDisk();
    await init();
  }
}

class OfflineSchoolLife extends OfflineModel {
  OfflineSchoolLife() : super('schoolLife');

  static const String ticketsKey = "tickets";
  static const String sanctionsKey = "sanctions";

  Future<List<SchoolLifeTicket>> getTickets() async {
    return (box?.get(ticketsKey) as List<dynamic>?)?.map<SchoolLifeTicket>((e) => e).toList() ?? [];
  }

  Future<void> setTickets(List<SchoolLifeTicket> tickets) async {
    await box?.put(ticketsKey, tickets);
  }

  Future<List<SchoolLifeSanction>> getSanctions() async {
    return box?.get(sanctionsKey) as List<SchoolLifeSanction>? ?? [];
  }

  Future<void> setSanctions(List<SchoolLifeSanction> sanctions) async {
    await box?.put(sanctionsKey, sanctions);
  }
}

class OfflineAuth extends OfflineModel {
  OfflineAuth() : super('auth');
}

class OfflineGrades extends OfflineModel {
  OfflineGrades() : super('grades');
}
