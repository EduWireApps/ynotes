import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ynotes_packages/theme.dart';

import '../light/colors.dart' as lightColors;
import '../light/variable_styles.dart' as lightvariableStyles;
import '../dark/colors.dart' as darkColors;
import '../dark/variable_styles.dart' as darkvariableStyles;

var brightness = SchedulerBinding.instance?.window.platformBrightness ?? Brightness.light;
bool darkModeOn = brightness == Brightness.dark;

final YTColors colors = darkModeOn ? darkColors.colors : lightColors.colors;
final YTVariableStyles variableStyles =
    darkModeOn ? darkvariableStyles.variableStyles : lightvariableStyles.variableStyles;

final YTheme systemTheme = YTheme("Système", id: 0, isDark: darkModeOn, colors: colors, variableStyles: variableStyles);
