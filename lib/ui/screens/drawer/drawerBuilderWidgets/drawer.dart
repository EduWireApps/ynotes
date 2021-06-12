import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/settings/settingsPage.dart';
import 'package:ynotes/usefulMethods.dart';

class CustomDrawer extends StatefulWidget {
  final List entries;
  final ValueNotifier<int> _notifier;

  final PageController? drawerPageViewController;
  const CustomDrawer(
    this.entries, {
    Key? key,
    required ValueNotifier<int> notifier,
    required this.drawerPageViewController,
  })  : _notifier = notifier,
        super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      height: screenSize.size.height,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
          width: screenSize.size.width / 5 * 3.6,
          height: screenSize.size.height / 10 * 0.9,
          child: DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              width: screenSize.size.width / 5 * 3.6,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.1),
                      child: SizedBox(
                        width: 70,
                        height: screenSize.size.height / 10 * 0.7,
                        child: DayNightSwitcher(
                          isDarkModeEnabled: ThemeUtils.isThemeDark,
                          onStateChanged: (value) {
                            appSys.updateTheme(value ? "sombre" : "clair");
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: ThemeUtils.spaceColor(),
            ),
          ),
        ),
        for (var entry in this.widget.entries)
          if ((entry["tabName"] != null && appSys.currentSchoolAccount!.availableTabs.contains(entry["tabName"])) ||
              (entry["relatedApi"] == -1 && !kReleaseMode))
            ValueListenableBuilder(
                valueListenable: widget._notifier,
                builder: (context, dynamic value, child) {
                  return Material(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
                    color: (this.widget.entries.indexOf(entry) == value)
                        ? Theme.of(context).backgroundColor
                        : Colors.transparent,
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      onTap: () {
                        //Close drawer
                        if (appSys.settings!["user"]["global"]["autoCloseDrawer"]) {
                          Navigator.of(context).pop();
                        }
                        widget.drawerPageViewController!.jumpToPage(this.widget.entries.indexOf(entry));
                      },
                      borderRadius: BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 380),
                        child: Container(
                          margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                          width: screenSize.size.width / 5 * 3.1,
                          height: screenSize.size.height / 10 * 0.6,
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(
                                entry["icon"],
                                size: 25,
                                color: ThemeUtils.textColor(),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(entry["menuName"],
                                    style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 17)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
        Expanded(
          child: SizedBox(),
        ),
        Material(
          borderRadius: BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
          color: Colors.transparent,
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: () {
              Wiredash.of(context)!.show();
            },
            borderRadius: BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
            child: Container(
              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
              width: screenSize.size.width / 5 * 3.4,
              height: screenSize.size.height / 10 * 0.6,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    MdiIcons.forum,
                    size: 25,
                    color: ThemeUtils.textColor(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Faire un retour",
                      style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 17)),
                ],
              ),
            ),
          ),
        ),
        Material(
          borderRadius: BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
          color: Colors.transparent,
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            onTap: () {
              Navigator.of(context).push(router(SettingsPage()));
            },
            borderRadius: BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
            child: Container(
              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
              width: screenSize.size.width / 5 * 3.4,
              height: screenSize.size.height / 10 * 0.6,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    Icons.settings,
                    size: 25,
                    color: ThemeUtils.textColor(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Préférences",
                      style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 17)),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  void initState() {
    super.initState();
  }
}
