import 'package:flutter/material.dart';

Map appThemes = {
  "sombre": ThemeData(
      backgroundColor: Color(0xff313131),
      primaryColor: Color(0xff414141),
      primaryColorLight: Color(0xff525252),
      //In reality that is primary ColorLighter
      primaryColorDark: Color(0xff333333),
      indicatorColor: Color(0xff525252),
      tabBarTheme: TabBarTheme(labelColor: Colors.black)),
  "clair": ThemeData(
      backgroundColor: Colors.white,
      primaryColor: Color(0xffF3F3F3),
      primaryColorDark: Color(0xffDCDCDC),
      primaryColorLight: Colors.white,
      indicatorColor: Color(0xffDCDCDC),
      tabBarTheme: TabBarTheme(labelColor: Colors.black)),
};
