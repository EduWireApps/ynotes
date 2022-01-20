part of logging_utils;

/// A custom logger to make debugging much easier. Use this instead of `print()` in production.
class Logger {
  Logger._();

  /// Makes error logging much easier.
  static void error(Object? e, {String? stackHint}) => log("ERROR", e.toString(),
      stackTrace: ((stackHint != null)
          ? stackList[stackHint]["file_path"] + ":" + stackList[stackHint]["line"].toString()
          : ""));

  /// Logs a title and a message.
  static void log(String object, dynamic text, {String? stackTrace, bool save = true}) {
    if (save) {
      LogsManager.add([Log(category: object, stacktrace: stackTrace, comment: text.toString())]);
    }
    debugPrint('[${object.toUpperCase()}' + (stackTrace != null ? ' ' + stackTrace : "") + '] ' + text.toString());
  }

  /// Same as [log], but on multiple lines. Useful when there is a huge amount of text.
  static void logWrapped(String object, String description, String text, {bool save = true}) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    if (save) {
      LogsManager.add([Log(category: object, comment: "$description: $text")]);
    }
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }
}
