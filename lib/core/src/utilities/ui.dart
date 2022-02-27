import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ynotes/core/services.dart';
import 'package:ynotes_packages/theme.dart';

/// A class that manages ui related actions. UIU stands for User Interface Utilities.
class UIU {
  const UIU._();

  /// Sets the status bar and navigation bar styles.
  static void setSystemUIOverlayStyle({Color? systemNavigationBarColor, bool? isDark}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: systemNavigationBarColor ?? theme.colors.backgroundColor,
        statusBarBrightness: (isDark ?? theme.isDark) ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: (isDark ?? theme.isDark) ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: (isDark ?? theme.isDark) ? Brightness.light : Brightness.dark));
  }

  /// Show a dialog containing the patch notes.
  static Future<void> showPatchNotes(BuildContext context, {bool force = false}) async {
    final info = await PackageInfo.fromPlatform();
    final String version = info.version;
    if (force || (SettingsService.settings.global.lastReadPatchNotes != version)) {
      SettingsService.settings.global.lastReadPatchNotes = version;
      await SettingsService.update();
      Navigator.pushNamed(context, "/settings/patch-notes");
    }
  }
}

class DragScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
      };
}
