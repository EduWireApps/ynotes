import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/ui/components/day_night_switch-master/lib/day_night_switch.dart';
import 'package:ynotes/ui/screens/drawer/drawerBuilder.dart';
import 'package:ynotes/ui/screens/settings/settingsPage.dart';
import 'package:ynotes/ui/screens/summary/summaryPage.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

class CustomDrawer extends StatefulWidget {
  final List entries;
  const CustomDrawer(
    this.entries, {
    Key key,
    @required ValueNotifier<int> notifier,
    @required this.drawerPageViewController,
  })  : _notifier = notifier,
        super(key: key);

  final ValueNotifier<int> _notifier;
  final PageController drawerPageViewController;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  //Settings
  var boolSettings = {
    "autoCloseDrawer": false,
  };
  void getSettings() async {
    await Future.forEach(boolSettings.keys, (key) async {
      var value = await getSetting(key);
      setState(() {
        boolSettings[key] = value;
      });
    });
  }

  void initState() {
    super.initState();
    getSettings();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Stack(
      children: [
        ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
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
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                            child: Transform.rotate(
                                angle: 0,
                                child: Image(
                                  image: AssetImage('assets/images/LogoYNotes.png'),
                                  width: screenSize.size.width / 5 * 0.4,
                                )),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Transform.scale(
                            scale: 0.4,
                            child: DayNightSwitch(
                              height: screenSize.size.height / 10 * 0.2,
                              value: isDarkModeEnabled,
                              dragStartBehavior: DragStartBehavior.start,
                              onChanged: (val) async {
                                print(val);
                                setState(() {
                                  isDarkModeEnabled = val;
                                });
                                Provider.of<AppStateNotifier>(context, listen: false).updateTheme(val);
                                await setSetting("nightmode", val);
                              },
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
                if (entry["relatedApi"] == null ||
                    entry["relatedApi"] == chosenParser ||
                    (entry["relatedApi"] == -1 && !kReleaseMode))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: widget._notifier,
                          builder: (context, value, child) {
                            return Material(
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
                              color: (this.widget.entries.indexOf(entry) == value)
                                  ? Theme.of(context).backgroundColor
                                  : Colors.transparent,
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                onTap: () {
                                  //Close drawer
                                  if (boolSettings["autoCloseDrawer"]) {
                                    Navigator.of(context).pop();
                                  }
                                  widget.drawerPageViewController.jumpToPage(this.widget.entries.indexOf(entry));
                                },
                                borderRadius:
                                    BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
                                child: Container(
                                  margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                  width: screenSize.size.width / 5 * 3.4,
                                  height: screenSize.size.height / 10 * 0.6,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenSize.size.width / 5 * 0.1),
                                      Icon(
                                        entry["icon"],
                                        size: screenSize.size.width / 5 * 0.3,
                                        color: ThemeUtils.textColor(),
                                      ),
                                      SizedBox(
                                        width: screenSize.size.width / 5 * 0.1,
                                      ),
                                      Text(entry["menuName"],
                                          style: TextStyle(
                                              fontFamily: "Asap",
                                              color: ThemeUtils.textColor(),
                                              fontSize: screenSize.size.width / 5 * 0.3)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      SizedBox(
                        height: screenSize.size.height / 10 * 0.1,
                      ),
                    ],
                  ),
            ]),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: screenSize.size.width / 5 * 0.8),
            child: Material(
              borderRadius: BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
              color: Colors.transparent,
              child: InkWell(
                splashFactory: InkRipple.splashFactory,
                onTap: () {
                  Wiredash.of(context).show();
                },
                borderRadius: BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
                child: Container(
                  margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                  width: screenSize.size.width / 5 * 3.4,
                  height: screenSize.size.height / 10 * 0.6,
                  child: Row(
                    children: [
                      SizedBox(width: screenSize.size.width / 5 * 0.1),
                      Icon(
                        MdiIcons.forum,
                        size: screenSize.size.width / 5 * 0.3,
                        color: ThemeUtils.textColor(),
                      ),
                      SizedBox(
                        width: screenSize.size.width / 5 * 0.1,
                      ),
                      Text("Faire un retour",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.textColor(),
                              fontSize: screenSize.size.width / 5 * 0.3)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: screenSize.size.width / 5 * 0.1),
            child: Material(
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
                      SizedBox(width: screenSize.size.width / 5 * 0.1),
                      Icon(
                        Icons.settings,
                        size: screenSize.size.width / 5 * 0.3,
                        color: ThemeUtils.textColor(),
                      ),
                      SizedBox(
                        width: screenSize.size.width / 5 * 0.1,
                      ),
                      Text("Préférences",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.textColor(),
                              fontSize: screenSize.size.width / 5 * 0.3)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
