import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stands for Key Value Store. Uses [FlutterSecureStorage] under the hood.
class KVS {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Stands for Key Value Store. Uses [FlutterSecureStorage] under the hood.
  const KVS._();

  static Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  static Future<void> write({required String key, required String value}) async {
    return await _storage.write(key: key, value: value);
  }

  static Future<void> delete({required String key}) async {
    if (await containsKey(key: key)) {
      return await _storage.delete(key: key);
    }
  }

  static Future<bool> containsKey({required String key}) async {
    return (await _storage.containsKey(key: key) && await read(key: key) != null);
  }

  static Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  static Future<void> deleteAll() async {
    final Map<String, String> store = await _storage.readAll();
    if (store.isNotEmpty) {
      return await _storage.deleteAll();
    }
  }
}
