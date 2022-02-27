import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shake_flutter/models/shake_file.dart';
import 'package:shake_flutter/shake_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utilities.dart';

import 'package:ynotes/core/services.dart';
import 'package:ynotes/core/extensions.dart';
import 'package:ynotes/ui/components/components.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

/// The class that handles the bug reporting process.
class BugReport {
  const BugReport._();

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
      final String json = generateCleanJson(LogsManager.logs);
      // create a temp file containing logs as json
      final directory = await FileStorage.getAppDirectory();
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
      await file.delete();
      //set api metadata
      Shake.setMetadata("schoolApi", schoolApi.metadata.name);
    } catch (e) {
      Logger.error(e, stackHint: "Nzg=");
    }
  }

  static String generateCleanJson(List<Log> logs) {
    Map finalMap = {};
    for (Log element in logs) {
      if (finalMap.containsKey(element.category)) {
        finalMap[element.category].add(element);
      } else {
        finalMap[element.category] = [element];
      }
    }
    return jsonEncode(finalMap);
  }

  /// Opens the report widget
  static Future<void> report() async {
    if (AppConfig.shake.isSupported) {
      final Future<void> future = prepareReportData();
      AppDialogs.showReportLoaderDialog(AppConfig.navigatorKey.currentContext!, future: future);
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
