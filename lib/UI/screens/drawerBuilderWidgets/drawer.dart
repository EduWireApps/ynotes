
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/UI/components/day_night_switch-master/lib/day_night_switch.dart';
import 'package:ynotes/UI/screens/drawerBuilder.dart';
import 'package:ynotes/UI/screens/settingsPage.dart';

import '../../../usefulMethods.dart';

///Apps
///`relatedApi` should be set to null if both APIs can use it
List<Map> entries = [
  {
    "menuName": "Agenda",
    "icon": MdiIcons.calendar,
  },
  {
    "menuName": "Résumé",
    "icon": MdiIcons.home,
  },
  {
    "menuName": "Notes",
    "icon": MdiIcons.trophy,
  },
  {
    "menuName": "Devoirs",
    "icon": MdiIcons.calendarCheck,
  },
  {"menuName": "Cloud", "icon": MdiIcons.cloud, "relatedApi": 0},
  {"menuName": "Messagerie", "icon": MdiIcons.mail, "relatedApi": 0},
  {"menuName": "Fichiers", "icon": MdiIcons.file, "relatedApi": 0}
];

class CustomDrawer extends StatefulWidget {
  Animation<Offset> buttonOffsetAnimation;
  Animation<double> buttonScaleAnimation;
  final int actualPage;
  @override
  CustomDrawer(this.buttonOffsetAnimation, this.buttonScaleAnimation, this.actualPage);
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int selected = 1;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.actualPage != null) {
      selected = this.widget.actualPage;
    }
    var screenSize = MediaQuery.of(context);
    return Positioned(
      left: screenSize.size.width / 5 * 0.2,
      child: Container(
        height: screenSize.size.height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: screenSize.size.width,
                margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                child: Stack(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(11),
                      color: Theme.of(context).backgroundColor,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(router(SettingsPage()));
                        },
                        borderRadius: BorderRadius.circular(11),
                        child: Container(
                          width: screenSize.size.width / 5 * 2.5,
                          height: screenSize.size.height / 10 * 0.6,
                          child: Row(
                            children: [
                              SizedBox(width: screenSize.size.width / 5 * 0.1),
                              Icon(
                                MdiIcons.cog,
                                size: screenSize.size.width / 5 * 0.3,
                                color: isDarkModeEnabled ? Colors.white : Colors.black,
                              ),
                              SizedBox(
                                width: screenSize.size.width / 5 * 0.1,
                              ),
                              Text("Préférences", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: screenSize.size.width / 5 * 0.3)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
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
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                entries.length,
                (index) {
                  if (entries[index]["relatedApi"] == null || entries[index]["relatedApi"] == chosenParser) {
                    return Column(
                      children: [
                        SlideTransition(
                          position: widget.buttonOffsetAnimation,
                          child: Material(
                            borderRadius: BorderRadius.circular(11),
                            color: (index == selected) ? Theme.of(context).backgroundColor : Colors.transparent,
                            child: InkWell(
                              splashFactory: InkRipple.splashFactory,
                              onTap: () {
                                  drawerPageViewController.jumpToPage(index);
                               /* setState(() {
                                  selected = index;
                                });*/
                              },
                              borderRadius: BorderRadius.circular(11),
                              child: Container(
                                width: screenSize.size.width / 5 * 2.5,
                                height: screenSize.size.height / 10 * 0.6,
                                child: Row(
                                  children: [
                                    SizedBox(width: screenSize.size.width / 5 * 0.1),
                                    Icon(
                                      entries[index]["icon"],
                                      size: screenSize.size.width / 5 * 0.3,
                                      color: isDarkModeEnabled ? Colors.white : Colors.black,
                                    ),
                                    SizedBox(
                                      width: screenSize.size.width / 5 * 0.1,
                                    ),
                                    Text(entries[index]["menuName"], style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: screenSize.size.width / 5 * 0.3)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.size.height / 10 * 0.1,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
