import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart' as conv;
import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid_util.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/file_utils.dart';

// TODO: document and split the file in a small library

final SecureLogger _secureLogger = SecureLogger();

/// A custom logger to make debugging much easier. Use this instead of `print()` in production.
class CustomLogger {
  CustomLogger._();

  static void deleteLog(String category) async {
    await _secureLogger.deleteLog(category);
  }

  static void error(Object? e) => log("ERROR", e.toString());

  static Future<List<YLog>> getAllLogs() async {
    List<String> categories = await _secureLogger.getCategories();
    List<YLog> logs = [];
    for (String category in categories) {
      logs.addAll(await logsFromCategory(category));
    }
    return logs;
  }

  static void log(String object, dynamic text) => debugPrint('[${object.toUpperCase()}] ${text.toString()}');

  static Future<List<YLog>> logsFromCategory(String category) async {
    String? rawLog = await _secureLogger.readLog(logName: category);
    if (rawLog != null) {
      Iterable l = jsonDecode(rawLog);
      return List<YLog>.from(l.map((model) => YLog.fromJson(model)));
    } else {
      return [];
    }
  }

  static void logWrapped(String object, String description, String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    log(object, description);
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  static void saveLog(
      {required String object, required String text, String? stacktrace, bool overWrite = false}) async {
    YLog log = YLog(category: object, comment: text, date: DateTime.now());
    List<YLog> logs = overWrite ? [] : await logsFromCategory(object);
    logs.add(log);
    await _secureLogger.writeLog(logs: logs);
  }
}

class SecureLogger {
  String? _key;

  Future<void> deleteLog(String logName) async {
    File test = await loadLog(logName);
    await test.delete();
  }

  Future<List<String>> getCategories() async {
    final directory = await FolderAppUtil.getDirectory();
    List<FileInfo> files = await FileAppUtil.getFilesList("${directory.path}/logs");

    List<String> names = [];
    await Future.forEach(files, (FileInfo file) async {
      try {
        if (file.fileName != null &&
            await _decipher(file.fileName!.substring(00, (file.fileName?.length ?? 0) - 4)) != null) {
          names.add((await _decipher(file.fileName!.substring(00, (file.fileName?.length ?? 0) - 4)))!);
        }
      } catch (e) {
        CustomLogger.error(e);
      }
    });
    return names;
  }

  Future<String?> getKey() async {
    if (_key != null) {
      return _key;
    }
    if (await KVS.containsKey(key: "loggingKey")) {
      _key = await KVS.read(key: "loggingKey");
      return _key;
    } else {
      _key = conv.hex.encode(UuidUtil.cryptoRNG());
      if (_key != null) {
        await KVS.write(key: "loggingKey", value: _key!);
      }
      return _key;
    }
  }

  Future<File> loadLog(String logName) async {
    final directory = await FolderAppUtil.getDirectory();
    String name = (await _cipher(logName)) ?? "";
    final File file = File('${directory.path}/logs/$name.txt');
    return file;
  }

  Future<String?> readLog({required String logName}) async {
    File file = await loadLog(logName);
    if ((await file.exists()) == false) {
      await file.create(recursive: true);
    }
    return _decipher(await file.readAsString());
  }

  Future<void> writeLog({required List<YLog> logs}) async {
    File file = await loadLog(logs.first.category);
    if ((await file.exists()) == false) {
      await file.create(recursive: true);
    }
    await file.writeAsString((await _cipher(jsonEncode(logs)) ?? ""), mode: FileMode.write);
  }

  Future<String?> _cipher(String text) async {
    try {
      final _key = crypto.Key.fromUtf8(await getKey() ?? "");

      crypto.IV iv = crypto.IV.fromLength(16);
      final encrypter = crypto.Encrypter(crypto.AES(_key));
      return encrypter.encrypt(text, iv: iv).base16;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _decipher(String text) async {
    try {
      final _key = crypto.Key.fromUtf8(await getKey() ?? "");
      crypto.IV iv = crypto.IV.fromLength(16);

      final encrypter = crypto.Encrypter(crypto.AES(_key));
      return encrypter.decrypt16(text, iv: iv);
    } catch (e) {
      return null;
    }
  }
}

class YLog {
  /// Log category I.E : "notifications"
  final String category;

  /// Human readable comment
  final String comment;

  /// Log stacktrace
  final String? stacktrace;

  final DateTime date;

  YLog({
    required this.category,
    required this.comment,
    required this.date,
    this.stacktrace,
  });

  factory YLog.fromJson(Map<String, dynamic> json) => YLog(
        category: (json['category'] as String?) ?? "",
        comment: (json['comment'] as String?) ?? "",
        stacktrace: (json['stacktrace'] as String?),
        date: (DateTime.tryParse(json['date'])) ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'comment': comment.toString(),
      'stacktrace': stacktrace,
      'date': date.toString(),
    };
  }
}
