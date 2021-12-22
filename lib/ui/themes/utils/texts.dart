import './fonts.dart';
import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

YTTexts texts(YTColors colors, YTFonts fonts) => YTTexts(
      headline:
          getTextStyle(TextStyle(fontWeight: YFontWeight.bold, color: colors.foregroundColor, fontSize: YFontSize.xl2),
              // primaryfontFamily: true,
              primaryFontFamily: true,
              fonts: fonts),
      title: getTextStyle(
          TextStyle(
            color: colors.foregroundColor,
            fontWeight: YFontWeight.semibold,
            fontSize: YFontSize.xl,
          ),
          primaryFontFamily: true,
          fonts: fonts),
      body1: getTextStyle(
          TextStyle(
              fontWeight: YFontWeight.normal,
              fontSize: YFontSize.base,
              letterSpacing: YLetterSpacing.wide,
              height: 1.2,
              color: colors.foregroundLightColor),
          fonts: fonts),
      body2: getTextStyle(
          TextStyle(
              fontWeight: YFontWeight.normal,
              fontSize: YFontSize.xs,
              letterSpacing: YLetterSpacing.wide,
              height: 1.2,
              color: colors.foregroundLightColor),
          fonts: fonts),
      data1: const TextStyle(),
      data2: const TextStyle(),
      button: getTextStyle(
          TextStyle(fontWeight: YFontWeight.medium, fontSize: YFontSize.sm, letterSpacing: YLetterSpacing.wide),
          primaryFontFamily: true,
          fonts: fonts),
      link: getTextStyle(
          TextStyle(
              color: colors.primary.backgroundColor,
              fontWeight: FontWeight.w600,
              fontSize: YFontSize.sm,
              letterSpacing: .5),
          fonts: fonts),
    );
