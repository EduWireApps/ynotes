import 'package:flutter/material.dart';

Map appThemes = {
  "sombre": ThemeData(
      fontFamily: "Asap",
      backgroundColor: const Color(0xff313131),
      primaryColor: const Color(0xff414141),
      primaryColorLight: const Color(0xff525252),
      //In reality that is primary ColorLighter
      primaryColorDark: const Color(0xff333333),
      indicatorColor: const Color(0xff525252),
      tabBarTheme: const TabBarTheme(labelColor: Colors.black)),
  "clair": ThemeData(
      fontFamily: "Asap",
      backgroundColor: Colors.white,
      primaryColor: const Color(0xffF3F3F3),
      primaryColorDark: const Color(0xffDCDCDC),
      primaryColorLight: Colors.white,
      indicatorColor: const Color(0xffDCDCDC),
      tabBarTheme: const TabBarTheme(labelColor: Colors.black)),
};
