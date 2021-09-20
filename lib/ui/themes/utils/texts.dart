import './fonts.dart';
import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

YTTexts texts(YTColors colors, YTFonts fonts) => YTTexts(
      headline: YTextStyle(
          TextStyle(fontWeight: YFontWeight.bold, color: colors.foregroundColor, fontSize: YFontSize.xl2),
          primaryfontFamily: true,
          fonts: fonts),
      title: YTextStyle(
          TextStyle(
              fontWeight: YFontWeight.bold,
              fontSize: YFontSize.xl,
              letterSpacing: YLetterSpacing.wide,
              color: colors.foregroundColor),
          primaryfontFamily: true,
          fonts: fonts),
      body1: YTextStyle(
          TextStyle(
              fontWeight: YFontWeight.normal,
              fontSize: YFontSize.base,
              letterSpacing: YLetterSpacing.wide,
              height: 1.2,
              color: colors.foregroundLightColor),
          fonts: fonts),
      body2: YTextStyle(
          TextStyle(
              fontWeight: YFontWeight.normal,
              fontSize: YFontSize.xs,
              letterSpacing: YLetterSpacing.wide,
              height: 1.2,
              color: colors.foregroundLightColor),
          fonts: fonts),
      data1: const TextStyle(),
      data2: const TextStyle(),
      button: YTextStyle(
          TextStyle(fontWeight: YFontWeight.medium, fontSize: YFontSize.sm, letterSpacing: YLetterSpacing.wide),
          primaryfontFamily: true,
          fonts: fonts),
      link: YTextStyle(
          TextStyle(
              color: colors.primary.backgroundColor,
              fontWeight: FontWeight.w600,
              fontSize: YFontSize.sm,
              letterSpacing: .5),
          fonts: fonts),
    );
