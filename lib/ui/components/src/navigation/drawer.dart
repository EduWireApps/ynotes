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
    final List<_SpecialRoute> specialRoutes = [
      _SpecialRoute(
          title: "Faire un retour",
          icon: MdiIcons.forum,
          onTap: () {
            Future.delayed(const Duration(milliseconds: 0), () {
              Scaffold.of(context).openEndDrawer();
            });
            BugReport.report();
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

    final NewVersion newVersion = NewVersion();

    return ChangeNotifierConsumer(
        controller: theme,
        builder: (context, _, __) {
          return Drawer(
              child: Container(
            decoration: BoxDecoration(
              color: theme.colors.backgroundColor,
              border: r<Border?>(
                  def: null,
                  md: Border(right: BorderSide(color: theme.colors.backgroundLightColor, width: YScale.spx))),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ChangeNotifierConsumer<AuthModule>(
                      controller: schoolApi.authModule,
                      builder: (context, module, _) {
                        final SchoolAccount? account = schoolApi.authModule.schoolAccount;
                        return account != null ? _AccountHeader(account: account) : Container();
                      }),
                  if (Platform.isAndroid || Platform.isIOS)
                    FutureBuilder(
                        future: newVersion.getVersionStatus(),
                        builder: (context, AsyncSnapshot<VersionStatus?> snapshot) {
                          if (snapshot.hasData) {
                            final VersionStatus status = snapshot.data!;
                            if (status.canUpdate) {
                              return Material(
                                color: theme.colors.backgroundColor,
                                child: InkWell(
                                  onTap: () => launch(status.appStoreLink),
                                  child: Ink(
                                    padding: YPadding.p(YScale.s4),
                                    color: theme.colors.primary.backgroundColor,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Version ${status.storeVersion} disponible !",
                                            style: theme.texts.body1
                                                .copyWith(color: theme.colors.primary.foregroundColor)),
                                        Icon(Icons.file_download_rounded, color: theme.colors.primary.foregroundColor)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          return Container();
                        }),
                  YVerticalSpacer(YScale.s6),
                  _RoutesList(AppRouter.routes.where((route) => route.show && (route.guard?.call() ?? true)).toList()),
                  YVerticalSpacer(YScale.s6),
                  _SpecialRoutesList(specialRoutes: specialRoutes),
                  YVerticalSpacer(YScale.s6),
                  _SpecialRoutesList(specialRoutes: contactRoutes),
                ],
              ),
            ),
          ));
        });
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
        padding: YPadding.p(0),
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
  final List<AppRoute> validRoutes;
  const _RoutesList(
    this.validRoutes, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: validRoutes.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: YPadding.p(0),
        itemBuilder: (context, i) {
          final AppRoute route = validRoutes[i];
          final bool current = ModalRoute.of(context)!.settings.name == route.path;
          return Material(
              color: theme.colors.backgroundColor,
              child: ListTile(
                leading: Icon(route.icon, color: theme.colors.foregroundLightColor),
                title: Text(route.title!, style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor)),
                tileColor: current ? theme.colors.backgroundLightColor.withOpacity(.5) : null,
                onTap: () => current ? null : Navigator.pushNamed(context, route.path),
              ));
        });
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({
    Key? key,
    required this.account,
  }) : super(key: key);

  final SchoolAccount account;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, "/settings/account"),
        child: Ink(
            color: theme.colors.backgroundLightColor,
            width: double.infinity,
            padding:
                EdgeInsets.fromLTRB(YScale.s4, YScale.s6 + MediaQuery.of(context).padding.top, YScale.s4, YScale.s6),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundColor: theme.colors.backgroundColor,
                    child: Text("${account.firstName[0]}${account.lastName[0]}", style: theme.texts.title)),
                YHorizontalSpacer(YScale.s4),
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${account.firstName} ${account.lastName}",
                        style: theme.texts.body1
                            .copyWith(color: theme.colors.foregroundColor, fontWeight: YFontWeight.medium)),
                    Text(account.school, style: theme.texts.body2)
                  ],
                ))
              ],
            )),
      ),
    );
  }
}
