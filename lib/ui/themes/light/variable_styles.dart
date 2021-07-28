import 'package:ynotes_packages/theme.dart';

import 'colors.dart';

final YTVariableStyle _primary = YTVariableStyle(
    plain: YTVariableStyleColors(
        background: colors.primary.shade300,
        text: colors.primary.shade100,
        highlight: YThemeUtils.lighten(colors.primary.shade300)),
    reverse: YTVariableStyleColors(
        background: YThemeUtils.darken(colors.primary.shade100),
        text: colors.primary.shade300,
        highlight: colors.primary.shade100));

final YTVariableStyle _success = YTVariableStyle(
    plain: YTVariableStyleColors(
        background: colors.success.shade300,
        text: colors.success.shade100,
        highlight: YThemeUtils.lighten(colors.success.shade300)),
    reverse: YTVariableStyleColors(
        background: YThemeUtils.darken(colors.success.shade100),
        text: colors.success.shade300,
        highlight: colors.success.shade100));

final YTVariableStyle _warning = YTVariableStyle(
    plain: YTVariableStyleColors(
        background: colors.warning.shade300,
        text: colors.warning.shade100,
        highlight: YThemeUtils.lighten(colors.warning.shade300)),
    reverse: YTVariableStyleColors(
        background: YThemeUtils.darken(colors.warning.shade100),
        text: colors.warning.shade300,
        highlight: colors.warning.shade100));

final YTVariableStyle _danger = YTVariableStyle(
    plain: YTVariableStyleColors(
        background: colors.danger.shade300,
        text: colors.danger.shade100,
        highlight: YThemeUtils.lighten(colors.danger.shade300)),
    reverse: YTVariableStyleColors(
        background: YThemeUtils.darken(colors.danger.shade100),
        text: colors.danger.shade300,
        highlight: colors.danger.shade100));

final YTVariableStyle _neutral = YTVariableStyle(
    plain: YTVariableStyleColors(
        background: YThemeUtils.lighten(colors.neutral.shade400, .3),
        text: colors.neutral.shade200,
        highlight: YThemeUtils.lighten(colors.neutral.shade400, .4)),
    reverse: YTVariableStyleColors(
        background: YThemeUtils.darken(colors.neutral.shade200),
        text: colors.neutral.shade400,
        highlight: colors.neutral.shade100));

final List<YTVariableStyle> styles = [_primary];

final YTVariableStyles variableStyles = YTVariableStyles(
    primary: _primary, success: _success, warning: _warning, danger: _danger, neutral: _neutral, styles: styles);
