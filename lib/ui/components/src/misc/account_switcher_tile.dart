part of components;

class AccountSwitcherTile extends StatelessWidget {
  const AccountSwitcherTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierConsumer<AuthModule>(
        controller: schoolApi.authModule,
        builder: (context, module, _) {
          return YSettingsTile(
              title: "Compte",
              subtitle: module.schoolAccount!.fullName,
              onTap: () async {
                final SchoolAccount? res = await YDialogs.getConfirmation<SchoolAccount>(
                    context,
                    YConfirmationDialog(
                        title: "Choisis un compte",
                        initialValue: module.schoolAccount!,
                        options: module.account!.accounts
                            .map((account) => YConfirmationDialogOption(value: account, label: account.fullName))
                            .toList()));
                if (res != null) {
                  final res0 = await YDialogs.getChoice(
                      context,
                      YChoiceDialog(
                          title: "Attention",
                          body:
                              Text("Changer de compte supprimera les données hors-ligne.", style: theme.texts.body1)));
                  if (res0) {
                    await module.update(res);
                    await schoolApi.reset();
                  }
                }
              });
        });
  }
}
