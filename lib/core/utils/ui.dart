import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ynotes_packages/theme.dart';

class UIUtils {
  const UIUtils._();

  static void setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: theme.colors.backgroundColor,
        statusBarBrightness: theme.isDark ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: theme.isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: theme.isDark ? Brightness.light : Brightness.dark));
  }
}
