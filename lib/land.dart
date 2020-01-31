import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = new FlutterSecureStorage();
//Create a secure storage
void CreateStorage(String key, String data) async
{
  await storage.write(key: key, value: data);
}
