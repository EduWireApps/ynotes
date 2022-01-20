part of logging_utils;

String? _encryptionKey;
bool _editingFile = false;
bool _busy = false;

/// Manages logs storage and encryption
class LogsManager {
  /// Manages logs storage and encryption
  const LogsManager._();

  static const String _logKey = "logs";

  static final List<Log> logs = [];

  static Future<void> load() async {
    if (_busy) {
      await Future.delayed(const Duration(milliseconds: 100));
      load();
      return;
    }
    _busy = true;
    final String? data = await KVS.read(key: _logKey);
    if (data == null) {
      final String encrypted = await _encrypt(json.encode([]));
      await KVS.write(key: _logKey, value: encrypted);
    } else {
      final String decrypted = await _decrypt(data);
      final List<Log> loadedLogs = json.decode(decrypted).map((dynamic log) => Log.fromJson(log)).toList();
      logs.clear();
      logs.addAll(loadedLogs);
    }
    _busy = false;
  }

  static Future<void> reset() async {
    if (_busy) {
      await Future.delayed(const Duration(milliseconds: 100));
      reset();
      return;
    }
    // Don't set [_busy] there since [load] already does it
    await KVS.delete(key: _logKey);
    await load();
  }

  static Future<void> add(List<Log> _logs) async {
    if (_busy) {
      await Future.delayed(const Duration(milliseconds: 100));
      add(_logs);
      return;
    }
    _busy = true;
    logs.addAll(_logs);
    final String encrypted = await _encrypt(json.encode(logs));
    await KVS.write(key: _logKey, value: encrypted);
    _busy = false;
  }

  static Future<List<String>> categories() async {
    final List<String> categories = logs.map((Log log) => log.category).toSet().toList();
    categories.sort();
    return categories;
  }

/*
  /// Returns the log file for a given [category].
  static Future<File> _readLogFile(String category) async {
    final directory = await FileStorage.getAppDirectory();
    final String fileName = await _encrypt(category);
    return File("${directory.path}/logs/$fileName.txt");
  }

  /// Saves [logs] of a [category] to the right log file.
  static Future<void> saveLogs({required List<Log> logs, required String category, bool? overwrite}) async {
    if (_editingFile) {
      await Future.delayed(const Duration(milliseconds: 100));
      saveLogs(logs: logs, category: category, overwrite: overwrite);
      return;
    }
    _editingFile = true;
    final File file = await _readLogFile(category);
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
    final String fileContent = await file.readAsString();
    List<Log> existingLogs = [];
    if (fileContent.isNotEmpty) {
      final String content = await _decrypt(fileContent);
      final List<dynamic> decoded = json.decode(content);
      existingLogs = decoded.map((dynamic log) => Log.fromJson(log)).toList();
    }
    final String content = await _encrypt(jsonEncode(overwrite == true ? logs : <Log>[...existingLogs, ...logs]));
    try {
      await file.writeAsString(content, mode: FileMode.write);
    } catch (e) {
      Logger.error(e, stackHint: "NDk=");
    }
    _editingFile = false;
  }

  /// Deletes all logs or from one [category].
  static Future<void> deleteLogs({String? category}) async {
    if (category == null) {
      final List<String> categories = await getCategories();
      for (var category in categories) {
        final log = await _readLogFile(category);
        await log.delete();
      }
    } else {
      final File log = await _readLogFile(category);
      await log.delete();
      final Directory appDir = await FileStorage.getAppDirectory();
      final Directory dir = Directory("${appDir.path}/logs");
      if (!dir.existsSync()) {
        dir.createSync();
      }
    }
  }

  /// Returns all logs or from one [category].
  static Future<List<Log>> getLogs({String? category}) async {
    if (category == null) {
      final List<String> categories = await getCategories();
      final List<Log> logs = [];
      for (var category in categories) {
        final List<Log> logsFromCategory = await getLogs(category: category);
        logs.addAll(logsFromCategory);
      }
      return logs..sort((Log a, Log b) => b.date.compareTo(a.date));
    } else {
      final File file = await _readLogFile(category);
      if (!(await file.exists())) {
        return [];
      }
      final String content = await file.readAsString();
      final List<dynamic> decoded = jsonDecode(await _decrypt(content));
      return decoded.map((dynamic log) => Log.fromJson(log)).toList()..sort((Log a, Log b) => b.date.compareTo(a.date));
    }
  }

  /// Returns all categories.
  static Future<List<String>> getCategories() async {
    final directory = await FileStorage.getAppDirectory();
    final List<FileInfo> files = await FileAppUtil.getFilesList("${directory.path}/logs");
    final List<String> categories =
        await Future.wait(files.where((file) => file.fileName?.endsWith(".txt") ?? false).map((file) async {
      final String fileName = file.fileName!;
      return await _decrypt(fileName.substring(
        0,
        fileName.length - 4,
      ));
    }));
    return categories;
  }
 */

  /// Retrieves the encryption key.
  static Future<String> _getEncryptionKey() async {
    // The key is not set
    if (_encryptionKey == null) {
      // The key is stored in the shared preferences
      if (await KVS.containsKey(key: "loggingKey")) {
        _encryptionKey = await KVS.read(key: "loggingKey");
        // The key doesn't exist yet
      } else {
        _encryptionKey = conv.hex.encode(UuidUtil.cryptoRNG());
        await KVS.write(key: "loggingKey", value: _encryptionKey!);
      }
    }
    return _encryptionKey!;
  }

  /// Encrypts [data] with the encryption key.
  static Future<String> _encrypt(String data) async {
    final key = crypto.Key.fromUtf8(await _getEncryptionKey());
    final iv = crypto.IV.fromLength(16);
    final aes = crypto.AES(key, padding: null);
    final encrypter = crypto.Encrypter(aes);
    return encrypter.encrypt(data, iv: iv).base16;
  }

  /// Decrypts [data] with the encryption key.
  static Future<String> _decrypt(String data) async {
    final key = crypto.Key.fromUtf8(await _getEncryptionKey());
    final iv = crypto.IV.fromLength(16);
    final aes = crypto.AES(key, padding: null);
    final encrypter = crypto.Encrypter(aes);
    return encrypter.decrypt16(data, iv: iv);
  }
}
