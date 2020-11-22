import 'package:flutter/material.dart';
import 'package:ynotes/usefulMethods.dart';

class ThemeUtils {
  static Color spaceColor() => Color(0xff282246);
  static Color textColor({bool revert = false}) => (isDarkModeEnabled ^= revert) ? Colors.white : Colors.black;
}

ThemeData darkTheme = ThemeData(
    backgroundColor: Color(0xff313131),
    primaryColor: Color(0xff414141),
    //In reality that is primary ColorLighter
    primaryColorDark: Color(0xff525252),
    indicatorColor: Color(0xff525252),
    tabBarTheme: TabBarTheme(labelColor: Colors.black));

ThemeData lightTheme = ThemeData(backgroundColor: Colors.white, primaryColor: Color(0xffF3F3F3), primaryColorDark: Color(0xffDCDCDC), indicatorColor: Color(0xffDCDCDC), tabBarTheme: TabBarTheme(labelColor: Colors.black));
