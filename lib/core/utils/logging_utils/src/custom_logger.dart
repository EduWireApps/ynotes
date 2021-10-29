part of logging_utils;

/// A custom logger to make debugging much easier. Use this instead of `print()` in production.
class CustomLogger {
  CustomLogger._();

  /// Deletes all logs in a given [category].
  static void deleteLog(String category) async {
    await SecureLogger.deleteLog(category);
  }

  /// Makes error logging much easier.
  static void error(Object? e) => log("ERROR", e.toString());

  /// Retrieves all logs.
  static Future<List<YLog>> getAllLogs() async {
    List<String> categories = await SecureLogger.getCategories();
    List<YLog> logs = [];
    for (String category in categories) {
      logs.addAll(await logsFromCategory(category));
    }
    return logs;
  }

  /// Logs a title and a message.
  static void log(String object, dynamic text) => debugPrint('[${object.toUpperCase()}] ${text.toString()}');

  /// Retrieves all logs from a given [category].
  static Future<List<YLog>> logsFromCategory(String category) async {
    String? rawLog = await SecureLogger.readLog(category);
    if (rawLog != null) {
      Iterable l = jsonDecode(rawLog);
      return List<YLog>.from(l.map((model) => YLog.fromJson(model)));
    } else {
      return [];
    }
  }

  /// Same as [log], but on multiple lines. Useful when there is a huge amount of text.
  static void logWrapped(String object, String description, String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    log(object, description);
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  /// Saves a log.
  static void saveLog(
      {required String object, required String text, String? stacktrace, bool overWrite = false}) async {
    YLog log = YLog(category: object, comment: text, date: DateTime.now());
    List<YLog> logs = overWrite ? [] : await logsFromCategory(object);
    logs.add(log);
    await SecureLogger.writeLog(logs);
  }
}
