import 'dart:convert';
import 'dart:io';

import 'package:shake_flutter/models/shake_file.dart';
import 'package:shake_flutter/shake_flutter.dart';
import 'package:ynotes/config.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';

/// The class that handles the bug reporting process
class BugReportUtils {
  const BugReportUtils._();

  static Future<File> getLogsFile() async {
    final directory = await FolderAppUtil.getDirectory();
    return File('${directory.path}/logs/temp.json');
  }

  /// Initializes the bug report client
  static void init() {
    final config = AppConfig.shake;
    if (!config.isSupported) {
      return;
    }
    initShakeToReport();
    Shake.setShowFloatingReportButton(false);
    Shake.setInvokeShakeOnScreenshot(false);

    // Configure Shake
    Shake.start(config.clientID, config.clientSecret);
  }

  static void initShakeToReport() {
    if (!AppConfig.shake.isSupported) {
      return;
    }
    Shake.setInvokeShakeOnShakeDeviceEvent(appSys.settings.user.global.shakeToReport);
  }

  /// Saves and anonymizes the bug data to send it to the report platform
  static Future<void> packData() async {
    if (!AppConfig.shake.isSupported) {
      return;
    }
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
  static Future<void> report() async {
    if (AppConfig.shake.isSupported) {
      await packData();
      Shake.show();
    } else {
      YSnackbars.error(AppConfig.navigatorKey.currentContext!,
          title: "Oups !", message: "Indisponible sur ${Platform.operatingSystem.capitalize()}");
    }
  }

  static Future<void> _deleteLogsFile() async {
    final File file = await getLogsFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
