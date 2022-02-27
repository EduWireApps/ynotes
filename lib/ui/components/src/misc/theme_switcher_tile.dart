part of components;

class ThemeSwitcherTile extends StatelessWidget {
  const ThemeSwitcherTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierConsumer<YCurrentTheme>(
        controller: theme,
        builder: (context, theme, _) {
          final List<Color> colors = [
            theme.colors.primary.backgroundColor,
            theme.colors.foregroundColor,
            theme.colors.success.backgroundColor,
            theme.colors.warning.backgroundColor,
            theme.colors.danger.backgroundColor,
            theme.colors.info.backgroundColor,
          ];
          return YSettingsTile(
              title: "Thème",
              subtitle: theme.name,
              trailing: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: colors
                    .map((color) {
                      final int i = colors.indexOf(color);
                      final double? right = i == 0 ? null : i * YScale.s4;
                      return Positioned(
                        right: right,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: theme.colors.backgroundColor,
                          child: CircleAvatar(backgroundColor: color, radius: YScale.s4),
                        ),
                      );
                    })
                    .toList()
                    .reversed
                    .toList(),
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
