part of components;

class _UserSupportMetadataDialog extends StatefulWidget {
  _UserSupportMetadataDialog({Key? key}) : super(key: key);

  @override
  State<_UserSupportMetadataDialog> createState() => _UserSupportMetadataDialogState();
}

class _UserSupportMetadataDialogState extends State<_UserSupportMetadataDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = List.from(AppColors.colors);
    return YDialogBase(
      title: "Vos coordonnées de support",
      body: ChangeNotifierConsumer<Settings>(
        controller: SettingsService.settings,
        builder: (context, settings, _) => Center(
          child: Wrap(runSpacing: YScale.s2, children: [
            Text(
              "Renseignez ces champs si vous souhaitez que l'on vous surnomme dans les conversations de support. ",
              style: theme.texts.body1,
            ),
            YVerticalSpacer(YScale.s11),
            YForm(
                formKey: _formKey,
                fields: [
                  YFormField(
                    type: YFormFieldInputType.text,
                    label: "Nom",
                    properties: YFormFieldProperties(),
                    defaultValue: settings.global.userFirstName,
                    onChanged: (value) async {
                      settings.global.userFirstName = value;
                      await SettingsService.update();
                    },
                  ),
                  YFormField(
                    type: YFormFieldInputType.text,
                    label: "Surnom",
                    properties: YFormFieldProperties(),
                    defaultValue: settings.global.userLastName,
                    onChanged: (value) async {
                      settings.global.userLastName = value;
                      await SettingsService.update();
                    },
                  ),
                ],
                onSubmit: (value) async {
                  Navigator.pop(context);
                }),
          ]),
        ),
      ),
    );
  }
}
