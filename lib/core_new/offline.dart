library offline;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core_new/utilities.dart';
import 'package:ynotes/core_new/api.dart';

/// The class that handles [Offline]'s state, mostly about configuration.
///
/// It's kept as a private class because:
/// - It has to be used only by the [Offline] class
/// - [Offline] can be used as a static class
class _OfflineStore {
  ///  Has [Offline] been initialized, to avoid multiple initializations.
  bool initialized = false;

  /// The [Offline] encryption cipher, used by [Hive].
  HiveAesCipher? cipher;
}

/// The class that handles any offline operations using [Hive]. It can only be used as a static class.
///
/// Storage is encrypted, its encryption key is stored with [KVS].
///
/// Before using [Offline], you must call [init] to initialize the class. Please note that calling
/// [OfflineModel.init] also calls [init] internally so it is not necessary to call it manually.
///
/// Hive files are stored in `/files/offline` directory in the app's storage,
/// depending of the platform.
///
/// When using some custom adapter, don't forget to import it and add it to
/// [_registerAdapters].
///
/// To access the offline storage, always extend [OfflineModel].
class Offline {
  Offline._();

  /// The class' state.
  static final store = _OfflineStore();

  /// The encryption key name, used to store the [Hive] encryption key with [KVS].
  static const String _encryptionKeyName = 'hiveEncryptionKey';

  /// This method must be called before using [Offline]. Please note that calling
  /// [OfflineModel.init] also calls [init] internally so it is not necessary to call it manually.
  ///
  /// It can be called multiple times without any issues since it will check if
  /// [Offline] has already been initialized usng [store.initialized].
  static Future<void> init() async {
    // Don't initialize if already initialized
    if (store.initialized) {
      return;
    }
    // Encryption part, following the [Hive] documentation.
    // If the [store.cipher] is null, we need to generate one.
    if (store.cipher == null) {
      final bool containsEncryptionKey = await KVS.containsKey(key: _encryptionKeyName);
      // Generate a new key if it doesn't exist
      if (!containsEncryptionKey) {
        final List<int> key = Hive.generateSecureKey();
        await KVS.write(key: _encryptionKeyName, value: base64UrlEncode(key));
      }
      // We set the cipher in order to manage data encryption
      final List<int> encryptionKey = base64Url.decode((await KVS.read(key: _encryptionKeyName))!);
      store.cipher = HiveAesCipher(encryptionKey);
    }
    // We init [Hive]
    if (kIsWeb) {
      // Not sure about this, was already done in the legacy codebase
      await Hive.initFlutter();
    } else {
      // We initialize Hive on the device. Hive files are stored in `/files/offline`
      //directory in the app's storage, depending of the platform.
      final dir = await FolderAppUtil.getDirectory();
      Hive.init("${dir.path}/offlineTest"); // TODO: change offline path
    }
    // We register custom adapters
    _registerAdapters();
    store.initialized = true;
  }

  /// Close offline boxes.
  static Future<void> close() async {
    await Hive.close();
    store.initialized = false;
  }

  /// Private method called during [init] to register custom adapters.
  static void _registerAdapters() {
    Hive.registerAdapter(SchoolLifeTicketAdapter());
    Hive.registerAdapter(SchoolLifeSanctionAdapter());
    Hive.registerAdapter(GradeAdapter());
    Hive.registerAdapter(SubjectsFilterAdapter());
    Hive.registerAdapter(PeriodAdapter());
    Hive.registerAdapter(SubjectAdapter());
    Hive.registerAdapter(ColorAdapter());
    Hive.registerAdapter(YTColorAdapter());
    Hive.registerAdapter(EmailAdapter());
    Hive.registerAdapter(RecipientAdapter());
    Hive.registerAdapter(HomeworkAdapter());
    Hive.registerAdapter(DocumentAdapter());
    Hive.registerAdapter(AppAccountAdapter());
    Hive.registerAdapter(SchoolAccountAdapter());
  }
}

/// The class to extend to access [Offline] storage.
abstract class OfflineModel {
  /// The [Hive]'s box key.
  final String key;

  /// The [Hive]'s box. Kept as [protected] and not private since it
  /// needs to be used by child classes but not outside of the class.
  @protected
  Box? box;

  OfflineModel(this.key);

  /// The method to initialize the [OfflineModel] class.
  Future<void> init() async {
    if (!Offline.store.initialized) {
      await Offline.init();
    }
    box = Hive.isBoxOpen(key) ? Hive.box(key) : await Hive.openBox(key, encryptionCipher: Offline.store.cipher);
    debugPrint("[HIVE BOX] Init $key");
  }

  /// Deletes the [box]'s content.
  Future<void> delete(String key) async {
    await box?.delete(key);
  }

  /// Resets the [OfflineModel]. Internally, deletes the corresponding files
  /// and reintializes the [OfflineModel].
  Future<void> reset() async {
    await box?.deleteFromDisk();
    await init();
  }
}
