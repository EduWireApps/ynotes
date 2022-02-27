import 'package:flutter/material.dart';
import 'package:ynotes/ui/themes/system.dart';
import 'package:ynotes_packages/theme.dart';
import 'light.dart';
import 'dark.dart';

List<YTheme> themes(Brightness brightness) => [systemTheme(brightness), lightTheme, darkTheme];
