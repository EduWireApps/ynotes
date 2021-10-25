import 'dart:convert';

import 'package:shake_flutter/shake_flutter.dart';
import 'package:ynotes/core/utils/logging_utils.dart';

class BugReportUtils {
  static init() {
    Shake.setInvokeShakeOnShakeDeviceEvent(true);
    Shake.setShowFloatingReportButton(false);
    Shake.setInvokeShakeOnScreenshot(false);
    Shake.start('iGBaTEc4t0namXSCrwRJLihJPkMPnfco2z4Xoyi3', 'nfzb5JnoGoGVxEi75jejFhyTQL4MyyOC7yCMCYiOmKaykWdoh0kfbY8');
  }

  static packData() async {
    String json = jsonEncode(await CustomLogger.getAllLogs());
    Shake.setMetadata("packedLogs", json);
  }

  static report() async {
    await packData();
    Shake.show();
  }
}
