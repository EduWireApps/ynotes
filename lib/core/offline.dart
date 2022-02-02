library offline;

import 'package:isar/isar.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/utilities.dart';

/// The class that handles any offline operations using [Isar]. It can only be used as a static class.
///
/// Storage is encrypted, its encryption key is stored with [KVS].
///
/// Before using [Offline], you must call [init] to initialize the class. Please note that calling
/// [OfflineModel.init] also calls [init] internally so it is not necessary to call it manually.
///
/// Isar files are stored in `/files/offline` directory in the app's storage,
/// depending of the platform.
///
/// To access the offline storage, always extend [OfflineModel].
abstract class Offline {
  /// The class' state.
  static final store = _OfflineStore();

  static late Isar isar;

  Offline._();

  /// Close offline boxes.
  static Future<void> close() async {
    await isar.close();
    store.initialized = false;
  }

  static final List<CollectionSchema<dynamic>> schemas = [
    AppAccountSchema,
    DocumentSchema,
    EmailSchema,
    GradeSchema,
    HomeworkSchema,
    PeriodSchema,
    RecipientSchema,
    SchoolAccountSchema,
    SchoolLifeSanctionSchema,
    SchoolLifeTicketSchema,
    SubjectSchema,
    SubjectsFilterSchema,
    LogSchema
  ];

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
    final dir = await FileStorage.getAppDirectory();

    isar = await Isar.open(
      name: "data",
      schemas: schemas,
      directory: '${dir.path}/offline',
    );
    store.initialized = true;
  }

  /// Close offline boxes.
  static Future<void> reset() async {
    await isar.clear();
    store.initialized = false;
  }
}

/// The class that handles [Offline]'s state, mostly about configuration.
///
/// It's kept as a private class because:
/// - It has to be used only by the [Offline] class
/// - [Offline] can be used as a static class
class _OfflineStore {
  ///  Has [Offline] been initialized, to avoid multiple initializations.
  bool initialized = false;
}
