part of app;

// v12tov13 and v13tov14 functions are kept even if unused
// to remember what have been done before without going
// through the git history. DO NOT DELETE THEM.

/// A function that migrates things from an implementation to another
Future<void> migrations() async {
  // await _fromV12ToV13();
  // await _fromV13ToV14();
  await _fromV14ToV15();
}

// ignore: unused_element
Future<void> _fromV12ToV13() async {
  Logger.log("BACKWARD COMPATIBILITY", "Start process: v12 to v13");
  // API_TYPE enum values has been changed to respect the naming conventions.
  // Because this value is json encoded in the local storage, it can't be interpreted directly.
  //
  // Example: "API_TYPE.Pronote" is now "API_TYPE.pronote" so there would be issue
  // while interpreted.
  final String? appAccount = await KVS.read(key: "appAccount");
  if (appAccount != null && appAccount.isNotEmpty) {
    String? newAppAccount;
    if (appAccount.contains('"apiType":"Pronote"')) {
      newAppAccount =
          appAccount.replaceAll('"apiType":"Pronote"', '"apiType":"pronote"');
    } else if (appAccount.contains('"apiType":"EcoleDirecte"')) {
      newAppAccount = appAccount.replaceAll(
          '"apiType":"EcoleDirecte"', '"apiType":"ecoleDirecte"');
    }
    if (newAppAccount != null) {
      await KVS.write(key: "appAccount", value: newAppAccount);
    }
  }

  // As the logging system changed, the `logs.txt` file is no longer useful.
  final directory = await FileStorage.getAppDirectory();
  final File file = File("${directory.path}/logs.txt");
  if (await file.exists()) {
    try {
      await file.delete();
    } catch (e) {
      Logger.error(e);
    }
  }
  // There was an issue with new logs that can be corrupted.
  // In order to get the new system working, the old `logs` folder
  // is deleted.
  final bool logsReset0 = (await KVS.read(key: "logsReset0")) == "true";
  if (!logsReset0) {
    final Directory logsDirectory = Directory("${directory.path}/logs");
    try {
      if (await logsDirectory.exists()) {
        await logsDirectory.delete(recursive: true);
      }
      await KVS.write(key: "logsReset0", value: "true");
    } catch (e) {
      Logger.log(
          "BACKWARD COMPATIBILITY", "Error while deleting logs folder: $e");
    }
  }
  // Logging is done in another check because the logs would have been removed
  // more or less at the same time otherwise, and would cause application crash.
  if (!logsReset0) {
    Logger.log("BACKWARD COMPATIBILITY", "Reset logs (0)");
  }
  Logger.log("BACKWARD COMPATIBILITY", "End of process: v12 to v13");
}

// ignore: unused_element
Future<void> _fromV13ToV14() async {
  Logger.log("BACKWARD COMPATIBILITY", "Start process: v13 to v14");
  // We still try to reset the logs. We don't use `logsReset1` because already used in 0.14.
  final bool logsReset2 = (await KVS.read(key: "logsReset2")) == "true";
  if (!logsReset2) {
    try {
      // This method doesn't exist anymore, replaced by [reset].
      //
      // await LogsManager.deleteLogs();
      await KVS.write(key: "logsReset2", value: "true");
    } catch (e) {
      Logger.log(
          "BACKWARD COMPATIBILITY", "Error while deleting logs folder: $e");
    }
  }
  // Logging is done in another check because the logs would have been removed
  // more or less at the same time otherwise, and would cause application crash.
  if (!logsReset2) {
    Logger.log("BACKWARD COMPATIBILITY", "Reset logs (2)");
  }
  Logger.log("BACKWARD COMPATIBILITY", "End of process: v13 to v14");
}

Future<void> _fromV14ToV15() async {
  // Reset evrything: shared preferences as well as all files in the app directory.
  // We don't deal with files located in the Android downloads folder.
  final bool fullReset0 = (await KVS.read(key: "fullReset0")) == "true";
  if (!fullReset0) {
    await KVS.deleteAll();
    try {
      final Directory dir = await FileStorage.getAppDirectory();
      dir.deleteSync(recursive: true);
      await KVS.write(key: "fullReset0", value: "true");
    } catch (e) {
      Logger.error(e);
    }
  }
}
