import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/bugreport_utils.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.colors.backgroundColor,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Oups !",
              style: theme.texts.title.copyWith(fontSize: YFontSize.xl5),
            ),
            YVerticalSpacer(YScale.s2),
            Text(
              "Cette page n'existe pas...",
              style: theme.texts.body1.copyWith(fontSize: YFontSize.xl2),
            ),
            YVerticalSpacer(YScale.s6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                YButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, "/loading"),
                  text: "Revenir à l'accueil",
                ),
                YHorizontalSpacer(YScale.s2),
                YButton(onPressed: () => BugReportUtils.report(), text: "Signaler le bug", color: YColor.secondary)
              ],
            )
          ],
        )));
  }
}
