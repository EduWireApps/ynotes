import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

final YTColor _primary = YTColor(
    shade100: Color(0xffECEEF8),
    shade200: Color(0xffCDD4F3),
    shade300: Color(0xff3f49a7),
    shade400: Color(0xff23295d),
    shade500: Color(0xff151838));

final YTColor _success = YTColor(
    shade100: Color(0xffecf8f0),
    shade200: Color(0xffa2dcb3),
    shade300: Color(0xff3fa75c),
    shade400: Color(0xff235d33),
    shade500: Color(0xff13331B));

final YTColor _warning = YTColor(
    shade100: Color(0xfffff9e6),
    shade200: Color(0xfffde082),
    shade300: Color(0xffe2ae04),
    shade400: Color(0xff7d6102),
    shade500: Color(0xff403000));

final YTColor _danger = YTColor(
    shade100: Color(0xfffef3f3),
    shade200: Color(0xfff98585),
    shade300: Color(0xffdb0b0b),
    shade400: Color(0xff7a0606),
    shade500: Color(0xff330202));

final YTColor _neutral = YTColor(
    shade100: Color(0xffC8C9CC),
    shade200: Color(0xffF2F3F5),
    shade300: Color(0xffE2E4E5),
    shade400: Color(0xff2E3338),
    shade500: Color(0xff060607));

final YTColors colors =
    YTColors(primary: _primary, success: _success, warning: _warning, danger: _danger, neutral: _neutral);
