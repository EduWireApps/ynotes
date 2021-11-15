import 'dart:convert';
import 'dart:io';

import 'package:shake_flutter/models/shake_file.dart';
import 'package:shake_flutter/shake_flutter.dart';
import 'package:ynotes/config.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';

/// The class that handles the bug reporting process
class BugReportUtils {
  const BugReportUtils._();

  /// Initializes the bug report client
  static void init() {
    final config = AppConfig.shake;
    if (!config.isSupported) {
      return;
    }
    updateShakeFeatureStatus();
    Shake.setShowFloatingReportButton(false);
    Shake.setInvokeShakeOnScreenshot(false);
    Shake.start(config.clientID, config.clientSecret);
  }

  static void updateShakeFeatureStatus() {
    if (!AppConfig.shake.isSupported) {
      return;
    }
    Shake.setInvokeShakeOnShakeDeviceEvent(appSys.settings.user.global.shakeToReport);
  }

  /// Saves and anonymizes the bug data to send it to the report platform
  static Future<void> prepareReportData() async {
    if (!AppConfig.shake.isSupported) {
      return;
    }
    try {
      String json = jsonEncode(await LogsManager.getLogs());
      //create a temp file containing logs as json
      final directory = await FolderAppUtil.getDirectory();
      final File file = File('${directory.path}/logs/temp.json');
      if (await file.exists()) {
        await file.delete();
      }
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
      await prepareReportData();
      Shake.show();
    } else {
      YSnackbars.error(AppConfig.navigatorKey.currentContext!,
          title: "Oups !", message: "Indisponible sur ${Platform.operatingSystem.capitalize()}");
    }
  }
}
