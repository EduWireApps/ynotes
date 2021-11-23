import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ynotes_packages/theme.dart';

class UIUtils {
  const UIUtils._();

  static void setSystemUIOverlayStyle({Color? systemNavigationBarColor, bool? isDark}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: systemNavigationBarColor ?? theme.colors.backgroundColor,
        statusBarBrightness: (isDark ?? theme.isDark) ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: (isDark ?? theme.isDark) ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: (isDark ?? theme.isDark) ? Brightness.light : Brightness.dark));
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
