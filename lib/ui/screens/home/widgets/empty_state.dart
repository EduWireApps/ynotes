import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class EmptyState extends StatelessWidget {
  final String iconRoutePath;
  final VoidCallback onPressed;
  final String text;
  final bool loading;

  const EmptyState(
      {Key? key, required this.iconRoutePath, required this.onPressed, required this.text, required this.loading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: YPadding.p(r<double>(def: YScale.s4, sm: YScale.s6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(appRoutes.firstWhere((element) => element.path == iconRoutePath).icon,
                color: theme.colors.backgroundLightColor,
                size: r<double>(def: YScale.s16, sm: YScale.s24, md: YScale.s32)),
            YHorizontalSpacer(YScale.s6),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: theme.texts.body1,
                    textAlign: TextAlign.start,
                  ),
                  YVerticalSpacer(YScale.s2),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: YScale.s32),
                    child: YButton(
                      onPressed: onPressed,
                      text: "Rafraîchir".toUpperCase(),
                      color: YColor.secondary,
                      isLoading: loading,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
