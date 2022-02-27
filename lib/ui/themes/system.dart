import 'dark.dart';
import 'light.dart';
import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

YTheme systemTheme(Brightness brightness) {
  final bool darkModeOn = brightness == Brightness.dark;
  // Based on the brightness, we take the right theme
  final YTheme t = darkModeOn ? darkTheme : lightTheme;
  final YTheme theme = YTheme("Système",
      id: 0, isDark: t.isDark, colors: t.colors, splashColor: t.splashColor, fonts: t.fonts, texts: t.texts);
  return theme;
}
