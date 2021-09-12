import './utils/fonts.dart';
import './utils/texts.dart';
import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

final YTColor _primary = YTColor(
  foregroundColor: Colors.white,
  lightColor: Colors.indigo[700]!.withOpacity(.5),
  backgroundColor: Colors.indigo[500]!,
);

final YTColor _secondaryDark = YTColor(
  foregroundColor: Colors.grey[200]!,
  lightColor: Colors.grey[800]!.withOpacity(.5),
  backgroundColor: Colors.grey[600]!,
);

final YTColor _secondaryLight = YTColor(
  foregroundColor: Colors.grey[300]!,
  lightColor: Colors.grey[850]!.withOpacity(.2),
  backgroundColor: Colors.grey[850]!,
);

final YTColor _success = YTColor(
  foregroundColor: Colors.green[50]!,
  lightColor: Colors.green[700]!.withOpacity(.5),
  backgroundColor: Colors.green[500]!,
);

final YTColor _warning = YTColor(
  foregroundColor: Colors.white,
  lightColor: Colors.amber[800]!.withOpacity(.5),
  backgroundColor: Colors.amber[600]!,
);

final YTColor _danger = YTColor(
  foregroundColor: Colors.red[50]!,
  lightColor: Colors.red[700]!.withOpacity(.5),
  backgroundColor: Colors.red[500]!,
);

final YTColors _colors = YTColors(
    backgroundColor: Color(0xff121212),
    backgroundLightColor: Color(0xff27272A),
    foregroundColor: Colors.grey[50]!,
    foregroundLightColor: Colors.grey[500]!,
    primary: _primary,
    secondaryDark: _secondaryDark,
    secondaryLight: _secondaryLight,
    success: _success,
    warning: _warning,
    danger: _danger);

final YTheme darkTheme =
    YTheme("Sombre", id: 2, isDark: true, colors: _colors, fonts: themeFonts, texts: texts(_colors, themeFonts));
