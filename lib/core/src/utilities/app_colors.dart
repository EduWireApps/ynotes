import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

/// A class that contains default colors, ensuring great contrasts.
class AppColors {
  const AppColors._();

  static final red = YTColor(
      backgroundColor: Colors.red[600]!, foregroundColor: Colors.white, lightColor: Colors.red[300]!.withOpacity(.5));
  static final pink = YTColor(
      backgroundColor: Colors.pink[600]!, foregroundColor: Colors.white, lightColor: Colors.pink[300]!.withOpacity(.5));
  static final purple = YTColor(
      backgroundColor: Colors.purple[600]!,
      foregroundColor: Colors.white,
      lightColor: Colors.purple[300]!.withOpacity(.5));
  static final deepPurple = YTColor(
      backgroundColor: Colors.deepPurple[600]!,
      foregroundColor: Colors.white,
      lightColor: Colors.deepPurple[300]!.withOpacity(.5));
  static final indigo = YTColor(
      backgroundColor: Colors.indigo[600]!,
      foregroundColor: Colors.white,
      lightColor: Colors.indigo[300]!.withOpacity(.5));
  static final blue = YTColor(
      backgroundColor: Colors.blue[600]!, foregroundColor: Colors.white, lightColor: Colors.blue[300]!.withOpacity(.5));
  static final lightBlue = YTColor(
      backgroundColor: Colors.lightBlue[600]!,
      foregroundColor: Colors.white,
      lightColor: Colors.lightBlue[300]!.withOpacity(.5));
  static final cyan = YTColor(
      backgroundColor: Colors.cyan[600]!, foregroundColor: Colors.white, lightColor: Colors.cyan[300]!.withOpacity(.5));
  static final teal = YTColor(
      backgroundColor: Colors.teal[600]!, foregroundColor: Colors.white, lightColor: Colors.teal[300]!.withOpacity(.5));
  static final green = YTColor(
      backgroundColor: Colors.green[600]!,
      foregroundColor: Colors.white,
      lightColor: Colors.green[300]!.withOpacity(.5));
  static final lightGreen = YTColor(
      backgroundColor: Colors.lightGreen[600]!,
      foregroundColor: Colors.white,
      lightColor: Colors.lightGreen[300]!.withOpacity(.5));
  static final lime = YTColor(
      backgroundColor: Colors.lime[600]!, foregroundColor: Colors.white, lightColor: Colors.lime[300]!.withOpacity(.5));
  static final yellow = YTColor(
      backgroundColor: Colors.yellow[700]!,
      foregroundColor: Colors.white,
      lightColor: Colors.yellow[300]!.withOpacity(.5));
  static final amber = YTColor(
      backgroundColor: Colors.amber[600]!,
      foregroundColor: Colors.white,
      lightColor: Colors.amber[300]!.withOpacity(.5));
  static final orange = YTColor(
      backgroundColor: Colors.orange[600]!,
      foregroundColor: Colors.white,
      lightColor: Colors.orange[300]!.withOpacity(.5));
  static final deepOrange = YTColor(
      backgroundColor: Colors.deepOrange[600]!,
      foregroundColor: Colors.white,
      lightColor: Colors.deepOrange[300]!.withOpacity(.5));
  static final brown = YTColor(
      backgroundColor: Colors.brown[600]!,
      foregroundColor: Colors.white,
      lightColor: Colors.brown[300]!.withOpacity(.5));

  static final List<YTColor> colors = [
    red,
    pink,
    purple,
    deepPurple,
    indigo,
    blue,
    lightBlue,
    cyan,
    teal,
    green,
    lightGreen,
    lime,
    yellow,
    amber,
    orange,
    deepOrange,
    brown,
  ];
}
