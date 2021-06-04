import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool availableRoute(route) {
      if (route["show"] != null && !route["show"]) return false;
      return (route["tab"] != null &&
              appSys.currentSchoolAccount!.availableTabs
                  .contains(route["tab"]) ||
          (route["relatedApi"] == -1 && !kReleaseMode));
    }

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Container(
        color: ThemeUtils.isThemeDark
            ? Theme.of(context).primaryColorLight
            : Theme.of(context).primaryColorDark,
        child: SafeArea(
            child: ListView.builder(
                itemCount: routes.length,
                itemBuilder: (context, i) {
                  print(routes[i]["title"]);
                  if (!availableRoute(routes[i])) {
                    return Container();
                  }
                  return ListTile(
                    leading: Icon(
                      routes[i]["icon"],
                      color:
                          ThemeUtils.isThemeDark ? Colors.white : Colors.black,
                    ),
                    title: Text(routes[i]["title"],
                        style: TextStyle(
                            color: ThemeUtils.isThemeDark
                                ? Colors.white
                                : Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                      if (ModalRoute.of(context)!.settings.name ==
                          routes[i]["path"]) {
                        return;
                      }
                      Navigator.pushReplacementNamed(
                          context, routes[i]["path"]);
                    },
                  );
                })),
      ),
    );
  }
}
