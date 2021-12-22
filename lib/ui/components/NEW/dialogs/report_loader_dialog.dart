import 'package:flutter/material.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class ReportLoaderDialog<T> extends StatefulWidget {
  final Future<T> future;
  const ReportLoaderDialog({Key? key, required this.future}) : super(key: key);

  @override
  State<ReportLoaderDialog<T>> createState() => _ReportLoaderDialogState<T>();
}

class _ReportLoaderDialogState<T> extends State<ReportLoaderDialog<T>> {
  @override
  void initState() {
    super.initState();
    widget.future.whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return YDialogBase(
      title: "Chargement",
      body: Column(
        children: [
          Center(
              child: Text(
            "L'écran de signalement va bientôt s'ouvrir...",
            style: theme.texts.body1,
            textAlign: TextAlign.center,
          )),
          YVerticalSpacer(YScale.s2),
          const YLinearProgressBar(),
        ],
      ),
      actions: [
        YButton(
          text: "Annuler",
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
