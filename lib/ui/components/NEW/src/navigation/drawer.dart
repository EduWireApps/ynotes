part of components;

class _SpecialRoute {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _SpecialRoute({required this.title, required this.icon, required this.onTap});
}

class _Drawer extends StatelessWidget {
  const _Drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = appSys.currentSchoolAccount;

    final List<_SpecialRoute> specialRoutes = [
      _SpecialRoute(
          title: "Faire un retour",
          icon: MdiIcons.forum,
          onTap: () {
            Future.delayed(const Duration(milliseconds: 0), () {
              Scaffold.of(context).openEndDrawer();
            });
            BugReportUtils.report();
          }),
      _SpecialRoute(title: "Paramètres", icon: Icons.settings, onTap: () => Navigator.pushNamed(context, "/settings")),
    ];

    final List<_SpecialRoute> contactRoutes = [
      _SpecialRoute(
          title: "Discord",
          icon: FontAwesomeIcons.discord,
          onTap: () async => await launch("https://discord.gg/pRCBs22dNX")),
      _SpecialRoute(
          title: "Github",
          icon: FontAwesomeIcons.github,
          onTap: () async => await launch("https://github.com/EduWireApps/ynotes")),
      _SpecialRoute(
          title: "Nous contacter", icon: Icons.mail, onTap: () async => await launch("https://ynotes.fr/contact/")),
      _SpecialRoute(
          title: "Centre d'aide", icon: Icons.help, onTap: () async => await launch("https://support.ynotes.fr/")),
    ];

    return Drawer(
        child: Container(
      color: theme.colors.backgroundColor,
      child: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            _AccountHeader(account: account),
            YVerticalSpacer(YScale.s6),
            const _RoutesList(),
            YVerticalSpacer(YScale.s6),
            _SpecialRoutesList(specialRoutes: specialRoutes),
            YVerticalSpacer(YScale.s6),
            _SpecialRoutesList(specialRoutes: contactRoutes),
          ],
        ),
      )),
    ));
  }
}

class _SpecialRoutesList extends StatelessWidget {
  const _SpecialRoutesList({
    Key? key,
    required this.specialRoutes,
  }) : super(key: key);

  final List<_SpecialRoute> specialRoutes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: specialRoutes.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          final _SpecialRoute route = specialRoutes[i];
          return Material(
              color: theme.colors.backgroundColor,
              child: ListTile(
                leading: Icon(route.icon, color: theme.colors.foregroundLightColor),
                title: Text(route.title, style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor)),
                onTap: route.onTap,
              ));
        });
  }
}

class _RoutesList extends StatelessWidget {
  const _RoutesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: appRoutes.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          final AppRoute route = appRoutes[i];
          final bool valid = route.show && (appRoutes[i].guard?.call() ?? true);
          final bool current = ModalRoute.of(context)!.settings.name == route.path;
          if (valid) {
            return Material(
                color: theme.colors.backgroundColor,
                child: ListTile(
                  leading: Icon(route.icon, color: theme.colors.foregroundLightColor),
                  title: Text(route.title!, style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor)),
                  tileColor: current ? theme.colors.backgroundLightColor.withOpacity(.5) : null,
                  onTap: () => Navigator.pushNamed(context, route.path),
                ));
          } else {
            return Container();
          }
        });
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({
    Key? key,
    required this.account,
  }) : super(key: key);

  final SchoolAccount? account;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, "/settings/account"),
        child: Ink(
            color: theme.colors.backgroundLightColor,
            width: double.infinity,
            padding: YPadding.p(YScale.s4),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundColor: theme.colors.backgroundColor,
                    child: Text("${account?.name?[0] ?? ''}${account?.surname?[0] ?? ''}", style: theme.texts.title)),
                YHorizontalSpacer(YScale.s4),
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${account?.name ?? ''} ${account?.surname ?? ''}",
                        style: theme.texts.body1
                            .copyWith(color: theme.colors.foregroundColor, fontWeight: YFontWeight.medium)),
                    Text(account?.schoolName ?? '', style: theme.texts.body2)
                  ],
                ))
              ],
            )),
      ),
    );
  }
}
