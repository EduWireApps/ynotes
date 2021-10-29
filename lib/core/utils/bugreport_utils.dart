import 'dart:convert';
import 'dart:io';

import 'package:shake_flutter/models/shake_file.dart';
import 'package:shake_flutter/shake_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/globals.dart';

/// The class that handles the bug reporting process
class BugReportUtils {
  const BugReportUtils._();

  static Future<File> getLogsFile() async {
    final directory = await FolderAppUtil.getDirectory();
    return File('${directory.path}/logs/temp.json');
  }

  /// Initializes the bug report client
  static init() {
    initShakeToReport();
    Shake.setShowFloatingReportButton(false);
    Shake.setInvokeShakeOnScreenshot(false);
    initUser();

    //Shake clients ids
    Shake.start('iGBaTEc4t0namXSCrwRJLihJPkMPnfco2z4Xoyi3', 'nfzb5JnoGoGVxEi75jejFhyTQL4MyyOC7yCMCYiOmKaykWdoh0kfbY8');
  }

  static initShakeToReport() {
    Shake.setInvokeShakeOnShakeDeviceEvent(appSys.settings.user.global.shakeToReport);
  }

  static Future<void> initUser() async {
    Shake.registerUser(await userId());
  }

  /// Saves and anonymizes the bug data to send it to the report platform
  static packData() async {
    try {
      String json = jsonEncode(await CustomLogger.getAllLogs());
      //create a temp file containing logs as json
      final File file = await getLogsFile();
      await _deleteLogsFile();
      file.create(recursive: true);
      await file.writeAsString(json);
      List<ShakeFile> shakeFiles = [];
      shakeFiles.add(ShakeFile.create(file.path, 'userLogs'));
      //set shake report files
      Shake.setShakeReportData(shakeFiles);
      //set api metadata
      Shake.setMetadata("schoolApi", appSys.api?.apiName ?? "{undefined}");
    } catch (e) {
      CustomLogger.error(e);
    }
  }

  /// Opens the report widget
  static report() async {
    await packData();
    Shake.show();
  }

  static Future<String> userId() async {
    if (await KVS.containsKey(key: "shakeUserID") && await KVS.read(key: "shakeUserID") != null) {
      return (await KVS.read(key: "shakeUserID"))!;
    } else {
      String id = const Uuid().v4();
      await KVS.write(key: "shakeUserID", value: id);
      return id;
    }
  }

  static Future<void> _deleteLogsFile() async {
    final File file = await getLogsFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
