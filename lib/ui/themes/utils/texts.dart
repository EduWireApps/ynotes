import './fonts.dart';
import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

YTTexts texts(YTColors colors, YTFonts fonts) {
  final TextStyle headline = getTextStyle(
      TextStyle(fontWeight: YFontWeight.bold, color: colors.foregroundColor, fontSize: YFontSize.xl2),
      primaryFontFamily: true,
      fonts: fonts);
  final TextStyle title = getTextStyle(
      TextStyle(
        color: colors.foregroundColor,
        fontWeight: YFontWeight.semibold,
        fontSize: YFontSize.xl,
      ),
      primaryFontFamily: true,
      fonts: fonts);
  final TextStyle body1 = getTextStyle(
      TextStyle(
          fontWeight: YFontWeight.normal,
          fontSize: YFontSize.base,
          letterSpacing: YLetterSpacing.wide,
          height: 1.2,
          color: colors.foregroundLightColor),
      fonts: fonts);
  final TextStyle body2 = getTextStyle(
      TextStyle(
          fontWeight: YFontWeight.normal,
          fontSize: YFontSize.xs,
          letterSpacing: YLetterSpacing.wide,
          height: 1.2,
          color: colors.foregroundLightColor),
      fonts: fonts);
  final TextStyle data1 = title.copyWith(fontWeight: YFontWeight.extrabold);
  const TextStyle data2 = TextStyle();
  final TextStyle button = getTextStyle(
      TextStyle(fontWeight: YFontWeight.medium, fontSize: YFontSize.sm, letterSpacing: YLetterSpacing.wide),
      primaryFontFamily: true,
      fonts: fonts);
  final TextStyle link = getTextStyle(
      TextStyle(
          color: colors.primary.backgroundColor,
          fontWeight: FontWeight.w600,
          fontSize: YFontSize.sm,
          letterSpacing: .5),
      fonts: fonts);

  return YTTexts(
    headline: headline,
    title: title,
    body1: body1,
    body2: body2,
    data1: data1,
    data2: data2,
    button: button,
    link: link,
  );
}
