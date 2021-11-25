part of logging_utils;

String? _encryptionKey;
bool _editingFile = false;

/// Manages logs storage and encryption
class LogsManager {
  /// Manages logs storage and encryption
  const LogsManager._();

  /// Returns the log file for a given [category].
  static Future<File> _readLogFile(String category) async {
    final directory = await FolderAppUtil.getDirectory();
    final String fileName = await _encrypt(category);
    return File("${directory.path}/logs/$fileName.txt");
  }

  /// Saves [logs] of a [category] to the right log file.
  static Future<void> saveLogs({required List<YLog> logs, required String category, bool? overwrite}) async {
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
    List<YLog> existingLogs = [];
    if (fileContent.isNotEmpty) {
      final String content = await _decrypt(fileContent);
      final List<dynamic> decoded = json.decode(content);
      existingLogs = decoded.map((dynamic log) => YLog.fromJson(log)).toList();
    }
    final String content = await _encrypt(jsonEncode(overwrite == true ? logs : <YLog>[...existingLogs, ...logs]));
    await file.writeAsString(content, mode: FileMode.write);
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
      final File file = await _readLogFile(category);
      await file.delete();
    }
  }

  /// Returns all logs or from one [category].
  static Future<List<YLog>> getLogs({String? category}) async {
    if (category == null) {
      final List<String> categories = await getCategories();
      final List<YLog> logs = [];
      for (var category in categories) {
        final List<YLog> logsFromCategory = await getLogs(category: category);
        logs.addAll(logsFromCategory);
      }
      return logs..sort((YLog a, YLog b) => b.date.compareTo(a.date));
    } else {
      final File file = await _readLogFile(category);
      if (!(await file.exists())) {
        return [];
      }
      final String content = await file.readAsString();
      final List<dynamic> decoded = jsonDecode(await _decrypt(content));
      return decoded.map((dynamic log) => YLog.fromJson(log)).toList()
        ..sort((YLog a, YLog b) => b.date.compareTo(a.date));
    }
  }

  /// Returns all categories.
  static Future<List<String>> getCategories() async {
    final directory = await FolderAppUtil.getDirectory();
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
