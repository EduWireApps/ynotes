import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'fileUtils.dart';
import 'package:ynotes/extensions.dart';

class CustomLogger {
  CustomLogger._();

  static Future<File> loadLog() async {
    final directory = await FolderAppUtil.getDirectory();
    final File file = File('${directory.path}/logs.txt');
    return file;
  }

  static Future<String> loadLogAsString() async {
    final File file = await loadLog();
    return file.readAsString();
  }

  static Future<void> _writeLog({required String object, required String text, required File file}) async {
    final String locale = "fr_FR";
    final String date = DateFormat.yMEd(locale).format(DateTime.now()).capitalize() +
        " à " +
        DateFormat.jms(locale).format(DateTime.now());
    final n = "\n";
    final String currentText = await file.readAsString();

    await file.writeAsString(date + n + '[${object.toUpperCase()}] $text' + n + n + currentText, mode: FileMode.write);
  }

  static void saveLog({required String object, required String text}) async {
    log(object, text);
    final File f = await loadLog();
    await _writeLog(object: object, text: text, file: f);
  }

  static void deleteLog() async {
    final File f = await loadLog();
    await f.writeAsString("");
  }

  static void log(String object, String text) => debugPrint('[${object.toUpperCase()}] $text');

  static void error(Object? e) => log("ERROR", e.toString());

  static void logWrapped(String object, String description, String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    log(object, description);
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }
}
