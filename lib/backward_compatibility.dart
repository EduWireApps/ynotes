import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

/// A function that migrates things from an implementation to another
Future<void> backwardCompatibility() async {
  await _fromV12ToV13();
  await _fromV13ToV14();
  await _extRemovalMigration();
}

Future<void> _extRemovalMigration() async {
  if (Platform.isAndroid) {
    try {
      final bool migratedOldExtFiles0 = (await KVS.read(key: "migratedOldExtFiles0")) == "true";
      if (migratedOldExtFiles0) {
        ///Olds download directory
        Directory oldDownloadsDirectory = Directory(
            (await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS))! + "/yNotesDownloads");

        List<FileSystemEntity>? files = await oldDownloadsDirectory.list().toList();

        if ((files).isNotEmpty) {
          String path = (await FolderAppUtil.getDirectory(downloads: true)).path;
          Future.forEach(files, (FileSystemEntity element) async {
            String? fileName = await FileAppUtil.getFileNameWithExtension(element);
            var result = await Process.run('cp', ['-r', element.path, path + "/"]);
          });
        }
        await KVS.write(key: "migratedOldExtFiles0", value: "true");
      }
    } catch (e) {
      CustomLogger.log("BACKWARD COMPATIBILITY NO EXT MIGRATION", "Error while moving files: $e");
    }
  }
}

Future<void> _fromV12ToV13() async {
  CustomLogger.log("BACKWARD COMPATIBILITY", "Start process: v12 to v13");
  // API_TYPE enum values has been changed to respect the naming conventions.
  // Because this value is json encoded in the local storage, it can't be interpreted directly.
  //
  // Example: "API_TYPE.Pronote" is now "API_TYPE.pronote" so there would be issue
  // while interpreted.
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
  // As the logging system changed, the `logs.txt` file is no longer useful.
  final directory = await FolderAppUtil.getDirectory();
  final File file = File("${directory.path}/logs.txt");
  if (await file.exists()) {
    await file.delete();
  }
  // There was an issue with new logs that can be corrupted.
  // In order to get the new system working, the old `logs` folder
  // is deleted.
  final bool logsReset0 = (await KVS.read(key: "logsReset0")) == "true";
  if (!logsReset0) {
    final Directory dir = await FolderAppUtil.getDirectory();
    final Directory logsDirectory = Directory("${dir.path}/logs");
    try {
      if (await logsDirectory.exists()) {
        await logsDirectory.delete(recursive: true);
      }
      await KVS.write(key: "logsReset0", value: "true");
    } catch (e) {
      CustomLogger.log("BACKWARD COMPATIBILITY", "Error while deleting logs folder: $e");
    }
  }
  // Logging is done in another check because the logs would have been removed
  // more or less at the same time otherwise, and would cause application crash.
  if (!logsReset0) {
    CustomLogger.log("BACKWARD COMPATIBILITY", "Reset logs (0)");
  }
  CustomLogger.log("BACKWARD COMPATIBILITY", "End of process: v12 to v13");
}

Future<void> _fromV13ToV14() async {
  CustomLogger.log("BACKWARD COMPATIBILITY", "Start process: v13 to v14");
  // We still try to reset the logs. We don't use `logsReset1` because already used in 0.14.
  final bool logsReset2 = (await KVS.read(key: "logsReset2")) == "true";
  if (!logsReset2) {
    try {
      await LogsManager.deleteLogs();
      await KVS.write(key: "logsReset2", value: "true");
    } catch (e) {
      CustomLogger.log("BACKWARD COMPATIBILITY", "Error while deleting logs folder: $e");
    }
  }
  // Logging is done in another check because the logs would have been removed
  // more or less at the same time otherwise, and would cause application crash.
  if (!logsReset2) {
    CustomLogger.log("BACKWARD COMPATIBILITY", "Reset logs (2)");
  }
  CustomLogger.log("BACKWARD COMPATIBILITY", "End of process: v13 to v14");
}
