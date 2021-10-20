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
