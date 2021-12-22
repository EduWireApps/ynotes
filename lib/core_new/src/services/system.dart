library system_service;

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utils/bugreport_utils.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core_new/services.dart';
import 'package:ynotes_packages/theme.dart';

class SystemService {
  const SystemService._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await backwardCompatibility();
    BugReportUtils.init();
    await SettingsService.init();
    schoolApi = schoolApiManager(SettingsService.settings.global.api);
    await schoolApi.init();
    await BackgroundService.init();
  }

  static Future<void> exit(BuildContext context) async {
    await schoolApi.reset(auth: true);
    await KVS.deleteAll();
    theme.updateCurrentTheme(0);
    LogsManager.deleteLogs();
    await SettingsService.reset();
    Phoenix.rebirth(context);
  }
}
