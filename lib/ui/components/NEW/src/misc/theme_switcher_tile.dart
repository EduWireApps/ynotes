part of components;

class ThemeSwitcherTile extends StatelessWidget {
  const ThemeSwitcherTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<YCurrentTheme>(
        controller: theme,
        builder: (context, theme, _) {
          return YSettingsTile(
              title: "Thème",
              subtitle: theme.name,
              trailing: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                      right: YScale.s4,
                      child: CircleAvatar(backgroundColor: theme.colors.foregroundColor, radius: YScale.s4)),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colors.backgroundColor,
                    child: CircleAvatar(backgroundColor: theme.colors.primary.backgroundColor, radius: YScale.s4),
                  ),
                ],
              ),
              onTap: () async {
                final int? res = await YDialogs.getConfirmation<int>(
                    context,
                    YConfirmationDialog(
                        title: "Choisis un thème",
                        options:
                            theme.themes.map((e) => YConfirmationDialogOption(value: e.id, label: e.name)).toList(),
                        initialValue: theme.currentTheme));
                if (res != null) {
                  await SettingsService.updateTheme(res);
                }
              });
        });
  }
}
