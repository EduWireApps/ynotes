import 'dart:io';

import 'package:convert/convert.dart' as conv;
import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid_util.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/extensions.dart';

import 'file_utils.dart';

class CustomLogger {
  CustomLogger._();

  static void deleteLog() async {
    final File f = await loadLog();
    await f.writeAsString("");
  }

  static void error(Object? e) => log("ERROR", e.toString());

  static Future<File> loadLog() async {
    final directory = await FolderAppUtil.getDirectory();
    final File file = File('${directory.path}/logs.txt');
    return file;
  }

  static Future<String> loadLogAsString() async {
    final File file = await loadLog();
    return file.readAsString();
  }

  static void log(String object, dynamic text) => debugPrint('[${object.toUpperCase()}] ${text.toString()}');

  static void logWrapped(String object, String description, String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    log(object, description);
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  static void saveLog({required String object, required String text}) async {
    log(object, text);
    final File f = await loadLog();
    await _writeLog(object: object, text: text, file: f);
  }

  static Future<void> _writeLog({required String object, required String text, required File file}) async {
    const String locale = "fr_FR";
    final String date = DateFormat.yMEd(locale).format(DateTime.now()).capitalize() +
        " à " +
        DateFormat.jms(locale).format(DateTime.now());
    const n = "\n";
    if ((await file.exists()) == false) {
      await file.create();
    }
    final String currentText = await file.readAsString();

    await file.writeAsString(date + n + '[${object.toUpperCase()}] $text' + n + n + currentText, mode: FileMode.write);
  }
}

class SecureLogger {
  String? key;

  Future<String> cipher(String text) async {
    final _key = crypto.Key.fromUtf8(await getKey() ?? "");
    final encrypter = crypto.Encrypter(crypto.AES(_key));
    return encrypter.encrypt(text).base16;
  }

  Future<String> decipher(String text) async {
    final _key = crypto.Key.fromUtf8(await getKey() ?? "");
    final encrypter = crypto.Encrypter(crypto.AES(_key));
    return encrypter.decrypt(crypto.Encrypted.fromBase16(text));
  }

  Future<String?> getKey() async {
    if (key != null) {
      return key;
    }
    if (await KVS.containsKey(key: "loggingKey")) {
      key = await KVS.read(key: "loggingKey");
      return key;
    } else {
      key = conv.hex.encode(UuidUtil.cryptoRNG());
      if (key != null) {
        await KVS.write(key: "loggingKey", value: key!);
      }
      return key;
    }
  }

  Future<File> loadLog(String logName) async {
    final directory = await FolderAppUtil.getDirectory();
    String name = await cipher(logName);
    final File file = File('${directory.path}/logs/$name.txt');
    return file;
  }

  Future<String?> readLog({required String logName}) async {
    File file = await loadLog(logName);
    if ((await file.exists()) == false) {
      await file.create();
    }
    return decipher(await file.readAsString());
  }

  Future<void> writeLog({required String logName, required String text}) async {
    File file = await loadLog(logName);
    if ((await file.exists()) == false) {
      await file.create();
    }

    await file.writeAsString(await cipher(text), mode: FileMode.write);
  }
}
