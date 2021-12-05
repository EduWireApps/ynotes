// ignore_for_file: avoid_print
// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:ynotes/packages/apis/ecole_directe/ecole_directe.dart';

const String username = 'aaa';
const String password = 'aaa';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final api = EcoleDirecteApi();
  print(api.metadata.name);
  final res0 = await api.authModule.login(username: username, password: password);
  print("Error: ${res0.error}");
  print(api.authModule.account);
  final res1 = await api.schoolLifeModule.fetch(online: true);
  print("Error: ${res1.error}");
  print(api.schoolLifeModule.tickets);
  for (var s in api.schoolLifeModule.sanctions) {
    print("${s.reason} ${s.date}");
  }
  final res2 = await api.gradesModule.fetch();
  print("Error: ${res2.error}");
}
