import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/router.dart';
import 'package:ynotes/ui/components/y_drawer/widgets/account_header.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/screens/settings/settings.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

class YDrawer extends StatefulWidget {
  const YDrawer({Key? key}) : super(key: key);

  @override
  _YDrawerState createState() => _YDrawerState();
}

class _SpecialRoute {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _SpecialRoute({required this.title, required this.icon, required this.onTap});
}

class _YDrawerState extends State<YDrawer> with YPageMixin {
  Widget divider(BuildContext context) => Divider(
        color: theme.colors.neutral.shade400,
        thickness: 0.5,
        height: 0,
      );

  @override
  Widget build(BuildContext context) {
    bool availableRoute(CustomRoute route) {
      if (!route.show) return false;
      return (route.tab != null && appSys.currentSchoolAccount!.availableTabs.contains(route.tab) ||
          (route.relatedApi == -1 && !kReleaseMode));
    }

    final List<_SpecialRoute> specialRoutes = [
      _SpecialRoute(title: "Faire un retour", icon: MdiIcons.forum, onTap: () => Wiredash.of(context)!.show()),
      _SpecialRoute(
          title: "Paramètres",
          icon: Icons.settings,
          onTap: () => openLocalPage(YPageLocal(title: "Paramètres", child: SettingsPage()))),
    ];

    final List<_SpecialRoute> specialIcons = [
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

    final Color backgroundColor = theme.colors.neutral.shade200;

    return Drawer(
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: YShadowScrollContainer(color: backgroundColor, children: [
            AccountHeader(),
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: routes.length,
                itemBuilder: (context, i) {
                  final route = routes[i];

                  if (!availableRoute(route)) {
                    return Container();
                  }

                  final bool isCurrent = ModalRoute.of(context)!.settings.name == route.path;
                  final Color textColor = isCurrent ? theme.colors.neutral.shade500 : theme.colors.neutral.shade400;

                  return Container(
                    color: isCurrent ? theme.colors.neutral.shade300 : null,
                    child: ListTile(
                      leading: Icon(
                        route.icon,
                        color: textColor,
                      ),
                      title: Text(route.title ?? "", style: TextStyle(color: textColor, fontSize: 18)),
                      onTap: () {
                        if (ModalRoute.of(context)!.settings.name == route.path) {
                          return;
                        }
                        Navigator.pop(context);

                        Navigator.pushNamed(context, route.path);
                      },
                    ),
                  );
                }),
            divider(context),
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: specialRoutes.length,
                itemBuilder: (context, i) {
                  final _SpecialRoute route = specialRoutes[i];

                  return ListTile(
                    leading: Icon(
                      route.icon,
                      color: theme.colors.neutral.shade400,
                    ),
                    title: Text(route.title, style: TextStyle(color: theme.colors.neutral.shade400, fontSize: 18)),
                    onTap: route.onTap,
                  );
                }),
            divider(context),
            Row(
              children: [
                for (final e in specialIcons)
                  Expanded(
                      child: IconButton(
                    icon: Icon(e.icon),
                    color: theme.colors.neutral.shade400,
                    onPressed: e.onTap,
                  ))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
