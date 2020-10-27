
import 'package:flutter/material.dart';

class ThemeUtils {
  static textColor(context) => Theme.of(context).toString();
}

ThemeData darkTheme = ThemeData(
    backgroundColor: Color(0xff313131),
    primaryColor: Color(0xff414141),
    //In reality that is primary ColorLighter
    primaryColorDark: Color(0xff525252),
    indicatorColor: Color(0xff525252),
    tabBarTheme: TabBarTheme(labelColor: Colors.black));

ThemeData lightTheme = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: Color(0xffF3F3F3),
    primaryColorDark: Color(0xffDCDCDC),
    indicatorColor: Color(0xffDCDCDC),
    tabBarTheme: TabBarTheme(labelColor: Colors.black));