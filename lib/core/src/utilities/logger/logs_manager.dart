part of logger;

Isar? _isar;

/// Manages logs storage and encryption
class LogsManager {
  /// All the logs of the app. There are kept for only 2 weeks.
  static List<Log> get logs => _isar?.logs.where().findAllSync() ?? [];

  /// Manages logs storage and encryption
  const LogsManager._();

  /// Adds logs to the logs manager.
  static Future<void> add(List<Log> _logs) async {
    await _isar?.writeTxn((isar) async {
      isar.logs.putAll(_logs);
    });
  }

  /// Get the categories.
  static List<String> categories() {
    final List<String> categories = logs.map((Log log) => log.category).toSet().toList();
    categories.sort();
    return categories;
  }

  /// Initializes the logs manager.
  static Future<void> init() async {
    final dir = await FileStorage.getAppDirectory();
    _isar = await Isar.open(
      name: "logger",
      schemas: Offline.schemas,
      directory: '${dir.path}/offline',
    );
    final List<Log> oldLogs =
        await _isar!.logs.filter().dateGreaterThan(DateTime.now().subtract(const Duration(days: 7))).findAll();
    _isar!.writeTxnSync((isar) => _isar!.logs.deleteAllSync(oldLogs.map((e) => e.id!).toList()));
  }

  /// Resets the logs manager.
  static Future<void> reset() async {
    await _isar?.writeTxn((isar) async {
      await isar.clear();
    });
    await _isar?.close();
    await init();
  }
}
