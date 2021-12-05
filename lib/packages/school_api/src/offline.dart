part of school_api;

class _OfflineStore {
  bool initialized = false;
  HiveAesCipher? cipher;
}

class Offline {
  Offline._();

  static final store = _OfflineStore();
  static const String _encryptionKeyName = 'hiveEncryptionKey';

  static Future<void> init() async {
    if (store.initialized) {
      return;
    }
    // Encryption
    if (store.cipher == null) {
      final bool containsEncryptionKey = await KVS.containsKey(key: _encryptionKeyName);
      if (!containsEncryptionKey) {
        final List<int> key = Hive.generateSecureKey();
        await KVS.write(key: _encryptionKeyName, value: base64UrlEncode(key));
      }
      final List<int> encryptionKey = base64Url.decode((await KVS.read(key: _encryptionKeyName))!);
      store.cipher = HiveAesCipher(encryptionKey);
    }
    // Init Hive
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      var dir = await FolderAppUtil.getDirectory();
      Hive.init("${dir.path}/offlineTest"); // TODO: change offline path
    }
    _registerAdapters();
    store.initialized = true;
  }

  static void _registerAdapters() {
    Hive.registerAdapter(SchoolLifeTicketAdapter());
    Hive.registerAdapter(SchoolLifeSanctionAdapter());
    Hive.registerAdapter(GradeAdapter());
    Hive.registerAdapter(SubjectsFilterAdapter());
    Hive.registerAdapter(PeriodAdapter());
    Hive.registerAdapter(SubjectAdapter());
    Hive.registerAdapter(ColorAdapter());
    Hive.registerAdapter(YTColorAdapter());
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
    box = Hive.isBoxOpen(key) ? Hive.box(key) : await Hive.openBox(key, encryptionCipher: Offline.store.cipher);
    debugPrint("[HIVE BOX] Init $key");
  }

  Future<void> delete(String key) async {
    await box?.delete(key);
  }

  Future<void> reset() async {
    await box?.deleteFromDisk();
    await init();
  }
}
