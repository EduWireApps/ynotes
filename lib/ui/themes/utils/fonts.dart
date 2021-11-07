import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:google_fonts/google_fonts.dart';

final YTFonts themeFonts = YTFonts(primary: "Asap", secondary: "Asap");

TextStyle getTextStyle(TextStyle style, {bool primaryFontFamily = false, YTFonts? fonts}) =>
    GoogleFonts.getFont(primaryFontFamily ? (fonts ?? theme.fonts).primary : (fonts ?? theme.fonts).secondary,
        textStyle: style);

final TextTheme temporaryTextTheme = GoogleFonts.asapTextTheme();
