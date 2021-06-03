import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:ynotes/globals.dart';

ThemeData darkTheme = ThemeData(
    backgroundColor: Color(0xff313131),
    primaryColor: Color(0xff414141),
    primaryColorLight: Color(0xff525252),
    //In reality that is primary ColorLighter
    primaryColorDark: Color(0xff333333),
    indicatorColor: Color(0xff525252),
    tabBarTheme: TabBarTheme(labelColor: Colors.black));
ThemeData lightTheme = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: Color(0xffF3F3F3),
    primaryColorDark: Color(0xffDCDCDC),
    primaryColorLight: Colors.white,
    indicatorColor: Color(0xffDCDCDC),
    tabBarTheme: TabBarTheme(labelColor: Colors.black));

class ThemeUtils {
  static get isThemeDark => appSys.themeName!.contains("sombre");

  Map themeColors = {
    "light": {"primaryColor": Colors.red},
    "dark": {"primaryColor": Colors.red}
  };
//Theme utils colors
  primaryColor() => themeColors["light"]["primaryColor"];

  Color test() => Colors.blue;

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

  static Color spaceColor() => Color(0xff282246);

  static Color textColor({bool revert = false}) {
    if (revert) {
      return isThemeDark ? Colors.black : Colors.white;
    } else {
      return isThemeDark ? Colors.white : Colors.black;
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toCSSColor({bool leadingHashSign = true}) => '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
