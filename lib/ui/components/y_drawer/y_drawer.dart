import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/router.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/test.dart';

class YDrawer extends StatefulWidget {
  const YDrawer({Key? key}) : super(key: key);

  @override
  _YDrawerState createState() => _YDrawerState();
}

class _YDrawerState extends State<YDrawer> with YPageMixin {
  @override
  Widget build(BuildContext context) {
    bool availableRoute(route) {
      if (route["show"] != null && !route["show"]) return false;
      return (route["tab"] != null && appSys.currentSchoolAccount!.availableTabs.contains(route["tab"]) ||
          (route["relatedApi"] == -1 && !kReleaseMode));
    }

    final List<Map<String, dynamic>> specialRoutes = [
      {
        "title": "Paramètres",
        "icon": Icons.settings,
        "onTap": () => openLocalPage(YPageLocal(child: Text("bla"), title: "Paramètres"))
      },
      {"title": "Faire un retour", "icon": MdiIcons.forum, "onTap": () => Wiredash.of(context)!.show()},
      {
        "title": "Discord",
        "icon": FontAwesomeIcons.discord,
        "onTap": () async => await launch("https://discord.gg/pRCBs22dNX")
      },
      {
        "title": "Github",
        "icon": FontAwesomeIcons.github,
        "onTap": () async => await launch("https://github.com/EduWireApps/ynotes")
      },
      {
        "title": "Nous contacter",
        "icon": Icons.mail,
        "onTap": () async => await launch("https://ynotes.fr/contact/"),
      },
      {"title": "Centre d'aide", "icon": Icons.help, "onTap": () async => await launch("https://support.ynotes.fr/")},
      {"title": "Centre d'aide", "icon": Icons.help, "onTap": () async => await launch("https://support.ynotes.fr/")},
      {"title": "Centre d'aide", "icon": Icons.help, "onTap": () async => await launch("https://support.ynotes.fr/")},
      {"title": "Centre d'aide", "icon": Icons.help, "onTap": () async => await launch("https://support.ynotes.fr/")},
      {"title": "Centre d'aide", "icon": Icons.help, "onTap": () async => await launch("https://support.ynotes.fr/")},
      {"title": "Centre d'aide", "icon": Icons.help, "onTap": () async => await launch("https://support.ynotes.fr/")},
      {"title": "Centre d'aide", "icon": Icons.help, "onTap": () async => await launch("https://support.ynotes.fr/")},
      {"title": "Centre d'aide", "icon": Icons.help, "onTap": () async => await launch("https://support.ynotes.fr/")},
    ];

    return Drawer(
      child: Container(
        color: ThemeUtils.isThemeDark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark,
        child: SafeArea(
          child: VerticalScrollShadow(children: [
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: routes.length,
                itemBuilder: (context, i) {
                  if (!availableRoute(routes[i])) {
                    return Container();
                  }
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      routes[i]["icon"],
                      color: ThemeUtils.isThemeDark ? Colors.white : Colors.black,
                    ),
                    title: Text(routes[i]["title"],
                        style: TextStyle(color: ThemeUtils.isThemeDark ? Colors.white : Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                      if (ModalRoute.of(context)!.settings.name == routes[i]["path"]) {
                        return;
                      }
                      Navigator.pushNamed(context, routes[i]["path"]);
                    },
                  );
                }),
            Divider(color: ThemeUtils.isThemeDark ? Colors.white : Colors.black),
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: specialRoutes.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      specialRoutes[i]["icon"],
                      color: ThemeUtils.isThemeDark ? Colors.white : Colors.black,
                    ),
                    title: Text(specialRoutes[i]["title"],
                        style: TextStyle(color: ThemeUtils.isThemeDark ? Colors.white : Colors.black)),
                    onTap: specialRoutes[i]["onTap"],
                  );
                }),
          ]),
        ),
      ),
    );
  }
}
