import './utils/fonts.dart';
import './utils/texts.dart';
import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

final YTColor _primary = YTColor(
  foregroundColor: Colors.white,
  lightColor: Colors.indigo[300]!.withOpacity(.5),
  backgroundColor: Colors.indigo[600]!,
);

final YTColor _secondary = YTColor(
  foregroundColor: Colors.grey[700]!,
  lightColor: Colors.grey[300]!.withOpacity(.2),
  backgroundColor: Colors.grey[300]!,
);

final YTColor _success = YTColor(
  foregroundColor: Colors.white,
  lightColor: Colors.green[300]!.withOpacity(.5),
  backgroundColor: Colors.green[600]!,
);

final YTColor _warning = YTColor(
  foregroundColor: Colors.white,
  lightColor: Colors.amber[300]!.withOpacity(.5),
  backgroundColor: Colors.amber[600]!,
);

final YTColor _danger = YTColor(
  foregroundColor: Colors.white,
  lightColor: Colors.red[300]!.withOpacity(.5),
  backgroundColor: Colors.red[600]!,
);

final YTColor _info = YTColor(
  foregroundColor: Colors.white,
  lightColor: Colors.blue[300]!.withOpacity(.5),
  backgroundColor: Colors.blue[600]!,
);

final YTColors _colors = YTColors(
    backgroundColor: Colors.white,
    backgroundLightColor: Colors.grey[200]!,
    foregroundColor: Colors.grey[850]!,
    foregroundLightColor: Colors.grey[700]!,
    primary: _primary,
    secondary: _secondary,
    success: _success,
    warning: _warning,
    danger: _danger,
    info: _info);

final YTheme lightTheme =
    YTheme("Clair", id: 1, isDark: false, colors: _colors, fonts: themeFonts, texts: texts(_colors, themeFonts));
