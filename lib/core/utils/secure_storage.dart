import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomSecureStorage {
  late FlutterSecureStorage secureStorage;

  CustomSecureStorage() {
    secureStorage = FlutterSecureStorage();
  }

  Future<String?> read({required key}) async {
    if (await secureStorage.containsKey(key: key)) {
      return await secureStorage.read(key: key);
    } else {
      return null;
    }
  }

  Future<void> write({required key, required value}) async {
    return await secureStorage.write(key: key, value: value);
  }

  Future<void> deleteAll() async {
    return await secureStorage.deleteAll();
  }
}
