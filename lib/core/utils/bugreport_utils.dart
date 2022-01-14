import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shake_flutter/models/shake_file.dart';
import 'package:shake_flutter/shake_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core_new/services.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/ui/components/NEW/components.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

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
    // Shake.setInvokeShakeOnShakeDeviceEvent(appSys.settings.user.global.shakeToReport);
    Shake.setInvokeShakeOnShakeDeviceEvent(SettingsService.settings.global.shakeToReport);
  }

  /// Saves and anonymizes the bug data to send it to the report platform
  static Future<void> prepareReportData() async {
    if (!AppConfig.shake.isSupported) {
      return;
    }
    try {
      final String json = jsonEncode(await LogsManager.getLogs());
      // create a temp file containing logs as json
      final directory = await FolderAppUtil.getDirectory();
      final File file = File('${directory.path}/logs/temp.json');
      if (await file.exists()) {
        await file.delete();
      }
      file.create(recursive: true);
      await file.writeAsString(json);
      final List<ShakeFile> shakeFiles = [];
      shakeFiles.add(ShakeFile.create(file.path, 'userLogs'));
      //set shake report files
      Shake.setShakeReportData(shakeFiles);
      //set api metadata
      Shake.setMetadata("schoolApi", appSys.api?.apiName ?? "{undefined}");
    } catch (e) {
      CustomLogger.error(e, stackHint:"ODQ=");
    }
  }

  /// Opens the report widget
  static Future<void> report() async {
    if (AppConfig.shake.isSupported) {
      final Future<void> future = prepareReportData();
      AppDialogs.showReportLoaderDialog<void>(AppConfig.navigatorKey.currentContext!, future: future);
      await future;
      Shake.show();
    } else {
      final bool res = await YDialogs.getChoice(
          AppConfig.navigatorKey.currentContext!,
          YChoiceDialog(
              title: "Oups !",
              body: Text(
                  "Cette fonctionnalité est indisponible sur ${Platform.operatingSystem.capitalize()}. Veux-tu aller sur la page \"Contact\" de notre site internet à la place ?",
                  style: theme.texts.body1),
              confirmLabel: "Oui",
              cancelLabel: "Non"));
      if (res) {
        launch("https://ynotes.fr/contact");
      }
    }
  }

  /// Retrieves the user id
  static Future<String> userId() async {
    if (await KVS.containsKey(key: "shakeUserID") && await KVS.read(key: "shakeUserID") != null) {
      return (await KVS.read(key: "shakeUserID"))!;
    } else {
      String id = const Uuid().v4();
      await KVS.write(key: "shakeUserID", value: id);
      return id;
    }
  }
}
