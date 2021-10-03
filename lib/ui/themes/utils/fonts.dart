import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

final YTFonts themeFonts = YTFonts(primary: "Asap", secondary: "Heebo");

// ignore: non_constant_identifier_names
TextStyle YTextStyle(TextStyle style, {bool primaryfontFamily = false, YTFonts? fonts}) =>
    style.copyWith(fontFamily: primaryfontFamily ? (fonts ?? theme.fonts).primary : (fonts ?? theme.fonts).secondary);
