part of logging_utils;

String? _secureLoggerKey;

/// A logger that encrypt logs to protect data.
class SecureLogger {
  const SecureLogger._();

  /// Deletes the log for a given [name].
  static Future<void> deleteLog(String name) async => await (await loadLog(name)).delete();

  /// Retrieves all categories.
  static Future<List<String>> getCategories() async {
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

  /// Retrieves the key.
  static Future<String?> getKey() async {
    if (_secureLoggerKey != null) {
      return _secureLoggerKey;
    }
    if (await KVS.containsKey(key: "loggingKey")) {
      _secureLoggerKey = await KVS.read(key: "loggingKey");
      return _secureLoggerKey;
    } else {
      _secureLoggerKey = conv.hex.encode(UuidUtil.cryptoRNG());
      if (_secureLoggerKey != null) {
        await KVS.write(key: "loggingKey", value: _secureLoggerKey!);
      }
      return _secureLoggerKey;
    }
  }

  /// Loads the log for a given [name].
  static Future<File> loadLog(String name) async {
    final directory = await FolderAppUtil.getDirectory();
    String fileName = (await _cipher(name)) ?? "";
    return File('${directory.path}/logs/$fileName.txt');
  }

  /// Reads the log for a given [name].
  static Future<String?> readLog(String name) async {
    File file = await loadLog(name);
    if ((await file.exists()) == false) {
      await file.create(recursive: true);
    }
    return _decipher(await file.readAsString());
  }

  /// Writes the log for a given [name].
  static Future<void> writeLog(List<YLog> logs) async {
    File file = await loadLog(logs.first.category);
    if ((await file.exists()) == false) {
      await file.create(recursive: true);
    }
    await file.writeAsString((await _cipher(jsonEncode(logs)) ?? ""), mode: FileMode.write);
  }

  /// Encrypts data
  static Future<String?> _cipher(String text) async {
    try {
      final _secureLoggerKey = crypto.Key.fromUtf8(await getKey() ?? "");

      crypto.IV iv = crypto.IV.fromLength(16);
      final encrypter = crypto.Encrypter(crypto.AES(_secureLoggerKey));
      return encrypter.encrypt(text, iv: iv).base16;
    } catch (e) {
      return null;
    }
  }

  /// Decrypts data
  static Future<String?> _decipher(String text) async {
    try {
      final _secureLoggerKey = crypto.Key.fromUtf8(await getKey() ?? "");
      crypto.IV iv = crypto.IV.fromLength(16);

      final encrypter = crypto.Encrypter(crypto.AES(_secureLoggerKey));
      return encrypter.decrypt16(text, iv: iv);
    } catch (e) {
      return null;
    }
  }
}
