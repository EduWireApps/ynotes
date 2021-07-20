import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

final YTColor _primary = YTColor(
    shade100: Color(0xff151838),
    shade200: Color(0xff23295d),
    shade300: Color(0xff3f49a7),
    shade400: Color(0xffCDD4F3),
    shade500: Color(0xffECEEF8));

final YTColor _success = YTColor(
    shade100: Color(0xff13331B),
    shade200: Color(0xff1D4D2A),
    shade300: Color(0xff308046),
    shade400: Color(0xffa2dcb3),
    shade500: Color(0xffecf8f0));

final YTColor _warning = YTColor(
    shade100: Color(0xff403000),
    shade200: Color(0xff7d6102),
    shade300: Color(0xffBF9303),
    shade400: Color(0xfffde082),
    shade500: Color(0xfffff9e6));

final YTColor _danger = YTColor(
    shade100: Color(0xff330202),
    shade200: Color(0xff7a0606),
    shade300: Color(0xffB20909),
    shade400: Color(0xfff98585),
    shade500: Color(0xffFEE7E7));

final YTColor _neutral = YTColor(
    shade100: Color(0xff202225),
    shade200: Color(0xff2F3136),
    shade300: Color(0xff40444B),
    shade400: Color(0xffDCDDDE),
    shade500: Color(0xffFFFFFF));

final YTColors colors =
    YTColors(primary: _primary, success: _success, warning: _warning, danger: _danger, neutral: _neutral);
