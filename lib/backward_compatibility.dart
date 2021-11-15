import 'dart:io';

import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

/// A function that migrates things from an implementation to another
Future<void> backwardCompatibility() async {
  // from 0.12 to 0.13 => change apiType values
  await _fromV12ToV13();
}

Future<void> _fromV12ToV13() async {
  CustomLogger.log("BACKWARD COMPATIBILITY", "Start process: v12 to v13");
  final String? appAccount = await KVS.read(key: "appAccount");
  if (appAccount != null && appAccount.isNotEmpty) {
    String? newAppAccount;
    if (appAccount.contains('"apiType":"Pronote"')) {
      newAppAccount = appAccount.replaceAll('"apiType":"Pronote"', '"apiType":"pronote"');
    } else if (appAccount.contains('"apiType":"EcoleDirecte"')) {
      newAppAccount = appAccount.replaceAll('"apiType":"EcoleDirecte"', '"apiType":"ecoleDirecte"');
    }
    if (newAppAccount != null) {
      await KVS.write(key: "appAccount", value: newAppAccount);
    }
  }
  final directory = await FolderAppUtil.getDirectory();
  final File file = File("${directory.path}/logs.txt");
  if (await file.exists()) {
    await file.delete();
  }
  CustomLogger.log("BACKWARD COMPATIBILITY", "End of process: v12 to v13");
}
