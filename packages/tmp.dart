import 'dart:io';

// import 'ecole_directe_client/ecole_directe_client.dart';

import 'tests/ecole_directe/ecole_directe.dart';

const String username = 'aaa';
const String password = 'aaa';

Future<void> main() async {
  // final client = EcoleDirecteClient();
  // final res0 = await client.login(username: username, password: password);
  // print(res0.error);
  // print(client.account);
  // final res1 = await client.getGrades();
  // print(res1.data);
  final api = EcoleDirecteApi();
  print(api.metadata.name);
  final res0 = await api.authModule.login(username: username, password: password);
  print("Error: ${res0.error}");
  print(api.authModule.account);
  final res1 = await api.schoolLifeModule.fetch(); // TODO: check what's wrong
  print("Error: ${res1.error}");
  print(api.schoolLifeModule.tickets);
  for (var t in api.schoolLifeModule.tickets) {
    print("${t.reason} ${t.date}");
  }
}
