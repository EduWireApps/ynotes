part of school_api;

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
