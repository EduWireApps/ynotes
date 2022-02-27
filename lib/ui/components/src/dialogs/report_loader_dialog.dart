part of components;

class _ReportLoaderDialog extends StatefulWidget {
  final Future future;
  const _ReportLoaderDialog({Key? key, required this.future}) : super(key: key);

  @override
  State<_ReportLoaderDialog> createState() => __ReportLoaderDialogState();
}

class __ReportLoaderDialogState extends State<_ReportLoaderDialog> {
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
