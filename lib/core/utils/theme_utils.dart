import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:ynotes/globals.dart';

ThemeData darkTheme = ThemeData(
    backgroundColor: const Color(0xff313131),
    primaryColor: const Color(0xff414141),
    primaryColorLight: const Color(0xff525252),
    //In reality that is primary ColorLighter
    primaryColorDark: const Color(0xff333333),
    indicatorColor: const Color(0xff525252),
    tabBarTheme: const TabBarTheme(labelColor: Colors.black));
ThemeData lightTheme = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: const Color(0xffF3F3F3),
    primaryColorDark: const Color(0xffDCDCDC),
    primaryColorLight: Colors.white,
    indicatorColor: const Color(0xffDCDCDC),
    tabBarTheme: const TabBarTheme(labelColor: Colors.black));

class ThemeUtils {
  static get isThemeDark => appSys.themeName!.contains("sombre");

  ///Make the selected color darker
  static Color darken(Color color, {double? forceAmount}) {
    double amount = 0.05;
    var colorTest = TinyColor(color);
    //Test if the color is not too light
    if (forceAmount == null) {
      if (colorTest.isLight()) {
        amount = 0.2;
      }
      //Test if the color is something like yellow
      if (colorTest.getLuminance() > 0.5) {
        amount = 0.2;
      }
      if (colorTest.getLuminance() < 0.5) {
        amount = 0.18;
      }
    } else {
      amount = forceAmount;
    }
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color getCheckBoxColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
// the color to return when button is in pressed, hovered, focused state
      return Colors.white;
    }
// the color to return when button is in it's normal/unfocused state
    return Colors.green;
  }

  static Color textColor({bool revert = false}) {
    if (revert) {
      return isThemeDark ? Colors.black : Colors.white;
    } else {
      return isThemeDark ? Colors.white : Colors.black;
    }
  }
}
