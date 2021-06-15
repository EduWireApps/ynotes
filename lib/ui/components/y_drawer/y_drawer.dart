import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/router.dart';
import 'package:ynotes/ui/components/y_drawer/widgets/account_header.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/screens/settings/settingsPage.dart';
import 'package:ynotes_components/ynotes_components.dart';

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

    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColorLight,
        child: SafeArea(
          child: YShadowScrollContainer(color: Theme.of(context).primaryColorLight, children: [
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
                  return Container(
                    color: ModalRoute.of(context)!.settings.name == route.path ? Theme.of(context).primaryColor : null,
                    child: ListTile(
                      leading: Icon(
                        route.icon,
                        color: ThemeUtils.isThemeDark ? Colors.white : Colors.black87,
                      ),
                      title: Text(route.title ?? "",
                          style:
                              TextStyle(color: ThemeUtils.isThemeDark ? Colors.white : Colors.black87, fontSize: 18)),
                      onTap: () {
                        print(ModalRoute.of(context)!.settings.name);
                        Navigator.pop(context);
                        if (ModalRoute.of(context)!.settings.name == route.path) {
                          return;
                        }
                        Navigator.pushNamed(context, route.path);
                      },
                    ),
                  );
                }),
            Divider(
              color: ThemeUtils.isThemeDark ? Colors.white : Colors.black87,
              thickness: 0.5,
              height: 0,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: specialRoutes.length,
                itemBuilder: (context, i) {
                  final _SpecialRoute route = specialRoutes[i];

                  return ListTile(
                    leading: Icon(
                      route.icon,
                      color: ThemeUtils.isThemeDark ? Colors.white : Colors.black87,
                    ),
                    title: Text(route.title,
                        style: TextStyle(color: ThemeUtils.isThemeDark ? Colors.white : Colors.black87, fontSize: 18)),
                    onTap: route.onTap,
                  );
                }),
            Divider(
              color: ThemeUtils.isThemeDark ? Colors.white : Colors.black87,
              thickness: 0.5,
              height: 0,
            ),
            Row(
              children: [
                for (final e in specialIcons)
                  Expanded(
                      child: IconButton(
                    icon: Icon(e.icon),
                    color: ThemeUtils.isThemeDark ? Colors.white : Colors.black87,
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
