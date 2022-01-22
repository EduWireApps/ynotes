part of logger;

String? _encryptionKey;
File? _file;
Queue _queue = Queue();

/// Manages logs storage and encryption
class LogsManager {
  /// Manages logs storage and encryption
  const LogsManager._();

  /// All the logs of the app. There are kept for only 2 weeks.
  static final List<Log> logs = [];

  static Future<File> _getFile() async {
    if (_file == null) {
      final directory = await FileStorage.getAppDirectory();
      _file = File("${directory.path}/logs.txt");
    }
    if (!_file!.existsSync()) {
      await _file!.create(recursive: true);
      final String encrypted = await _encrypt(json.encode([]));
      await _file!.writeAsString(encrypted);
    }
    return _file!;
  }

  /// Initializes the logs manager.
  static Future<void> init() async {
    final File file = await _getFile();
    final String data = file.readAsStringSync();
    final String decrypted = await _decrypt(data);
    try {
      final List<Log> loadedLogs = json
          .decode(decrypted)
          .map<Log>((dynamic log) => Log.fromJson(log))
          .toList();
      // We only keep logs for 2 weeks.
      final DateTime limitDate =
          DateTime.now().subtract(const Duration(days: 14));
      logs.clear();
      logs.addAll(loadedLogs.where((log) => log.date.isAfter(limitDate)));
    } catch (e) {
      debugPrint("Error loading logs: $e");
      await reset();
      return;
    }
  }

  /// Resets the logs manager.
  static Future<void> reset() async {
    _queue.dispose();
    _queue = Queue();
    logs.clear();
    final File file = await _getFile();
    file.deleteSync();
    await init();
  }

  /// Adds logs to the logs manager.
  static Future<void> add(List<Log> _logs) async {
    for (final l in _logs) {
      try {
        await _queue.add(() async => await _add(l));
      } catch (e) {
        debugPrint("Error adding log: $e");
      }
    }
  }

  static Future<void> _add(Log log) async {
    logs.add(log);
    final String encrypted = await _encrypt(json.encode(logs));
    final File file = await _getFile();
    file.writeAsStringSync(encrypted);
  }

  /// Get the categories.
  static List<String> categories() {
    final List<String> categories =
        logs.map((Log log) => log.category).toSet().toList();
    categories.sort();
    return categories;
  }

  /// Retrieves the encryption key.
  static Future<String> _getEncryptionKey() async {
    // The key is not set
    if (_encryptionKey == null) {
      // The key is stored in the shared preferences
      if (await KVS.containsKey(key: "loggingKey")) {
        _encryptionKey = await KVS.read(key: "loggingKey");
        if (_encryptionKey == null) {
          _encryptionKey = conv.hex.encode(UuidUtil.cryptoRNG());
          await KVS.write(key: "loggingKey", value: _encryptionKey!);
        }
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
