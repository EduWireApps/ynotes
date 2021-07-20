import 'package:ynotes_packages/theme.dart';

import 'colors.dart';

final YTVariableStyle _primary = YTVariableStyle(
    plain: YTVariableStyleColors(
        background: colors.primary.shade300,
        text: colors.primary.shade500,
        highlight: YThemeUtils.lighten(colors.primary.shade300)),
    reverse: YTVariableStyleColors(
        background: colors.primary.shade200,
        text: colors.primary.shade500,
        highlight: YThemeUtils.lighten(colors.primary.shade200)));

final YTVariableStyle _success = YTVariableStyle(
    plain: YTVariableStyleColors(
        background: colors.success.shade300,
        text: colors.success.shade500,
        highlight: YThemeUtils.lighten(colors.success.shade300)),
    reverse: YTVariableStyleColors(
        background: colors.success.shade200,
        text: colors.success.shade500,
        highlight: YThemeUtils.lighten(colors.success.shade200)));

final YTVariableStyle _warning = YTVariableStyle(
    plain: YTVariableStyleColors(
        background: colors.warning.shade300,
        text: colors.warning.shade500,
        highlight: YThemeUtils.lighten(colors.warning.shade300)),
    reverse: YTVariableStyleColors(
        background: colors.warning.shade200,
        text: colors.warning.shade500,
        highlight: YThemeUtils.lighten(colors.warning.shade200)));

final YTVariableStyle _danger = YTVariableStyle(
    plain: YTVariableStyleColors(
        background: colors.danger.shade300,
        text: colors.danger.shade500,
        highlight: YThemeUtils.lighten(colors.danger.shade300)),
    reverse: YTVariableStyleColors(
        background: colors.danger.shade200,
        text: colors.danger.shade500,
        highlight: YThemeUtils.lighten(colors.danger.shade200)));

final YTVariableStyle _neutral = YTVariableStyle(
  plain: YTVariableStyleColors(
      background: colors.neutral.shade300,
      text: colors.neutral.shade500,
      highlight: YThemeUtils.lighten(colors.neutral.shade300)),
  reverse: YTVariableStyleColors(
      background: colors.neutral.shade100,
      text: colors.neutral.shade500,
      highlight: YThemeUtils.lighten(colors.neutral.shade100)),
);

final List<YTVariableStyle> styles = [_primary];

final YTVariableStyles variableStyles = YTVariableStyles(
    primary: _primary, success: _success, warning: _warning, danger: _danger, neutral: _neutral, styles: styles);
