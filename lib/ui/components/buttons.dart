import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/theme_utils.dart';

class CustomButtons {
  static Widget materialButton(BuildContext context, double? width, double? height, VoidCallback? onTap,
      {IconData? icon,
      String? label,
      Color? backgroundColor,
      Color? textColor,
      Color? iconColor,
      VoidCallback? onLongPress,
      BorderRadius? borderRadius,
      EdgeInsets? margin,
      EdgeInsets? padding,
      TextStyle? textStyle}) {
    return Container(
      width: width,
      margin: margin ?? const EdgeInsets.only(left: 10),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        color: backgroundColor ?? Theme.of(context).primaryColorDark,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
              height: height,
              padding: padding ?? const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (icon != null)
                    Icon(
                      icon,
                      color: textColor ?? ThemeUtils.textColor(),
                    ),
                  if (label != null)
                    Text(
                      label,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle ??
                          TextStyle(
                            fontFamily: "Asap",
                            color: textColor ?? ThemeUtils.textColor(),
                          ),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
