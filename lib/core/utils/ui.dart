import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes_packages/theme.dart';

class UIUtils {
  const UIUtils._();

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
  static Future<void> showPatchNotes(BuildContext context) async {
    const String version = "0.14.10";
    if ((appSys.settings.system.lastReadUpdateNote != version)) {
      appSys.settings.system.lastReadUpdateNote = version;
      await appSys.saveSettings();
      await CustomDialogs.showUpdateNoteDialog(context);
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
