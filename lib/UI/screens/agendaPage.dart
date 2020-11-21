import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/expandables.dart';
import 'package:ynotes/UI/screens/drawerBuilder.dart';
import 'package:ynotes/UI/components/hiddenSettings.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/agenda.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/spaceAgenda.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/agendaSettings.dart';
import 'package:ynotes/usefulMethods.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage({Key key}) : super(key: key);

  @override
  AgendaPageState createState() => AgendaPageState();
}

DateTime agendaDate;

class AgendaPageState extends State<AgendaPage> {
  PageController agendaPageSettingsController = PageController(initialPage: 1);
  double btPercents = 0;
  double topPercents = 100;

  void triggerSettings() {
    agendaPageSettingsController.animateToPage(agendaPageSettingsController.page == 1 ? 0 : 1, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return HiddenSettings(
      controller: agendaPageSettingsController,
      settingsWidget: AgendaSettings(),
      child: Container(
        margin: EdgeInsets.zero,
        width: screenSize.size.width,
        height: screenSize.size.height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: screenSize.size.width,
                      child: Expandables(
                        buildTopChild(),
                        buildBottomChild(),
                        minHeight: screenSize.size.height / 10 * 0.7,
                        maxHeight: screenSize.size.height / 10 * 8,
                        spaceBetween: screenSize.size.height / 10 * 0.3,
                        width: screenSize.size.width,
                        bottomExpandableColor: Color(0xff282246),
                        onDragUpdate: handleDragUpdate,
                        animationDuration: 200,
                        topExpandableBorderRadius: 0,
                        bottomExpandableBorderRadius: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildTopChild() {
    var screenSize = MediaQuery.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, -(topPercents / 100) * screenSize.size.height / 10 * 0.7),
            child: Container(
              height: screenSize.size.height / 10 * 0.7,
              width: screenSize.size.width,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(0)),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                        child: AutoSizeText(
                          "Agenda",
                          style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.1),
                      child: Transform.rotate(
                        angle: pi * (topPercents / 100),
                        child: Icon(
                          MdiIcons.arrowDownThick,
                          color: isDarkModeEnabled ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: (btPercents / 100) * screenSize.size.height / 10 * 0.7,
            child: Agenda(),
          )
        ],
      ),
    );
  }

  buildBottomChild() {
    var screenSize = MediaQuery.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, -(btPercents / 100) * screenSize.size.height / 10 * 0.7),
            child: Container(
              height: screenSize.size.height / 10 * 0.7,
              width: screenSize.size.width,
              decoration: BoxDecoration(color: Color(0xff100A30), borderRadius: BorderRadius.circular(0)),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                        child: AutoSizeText(
                          "Organisation extra-scolaire",
                          style: TextStyle(fontFamily: "Asap", color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.1),
                      child: Transform.rotate(
                        angle: pi * (btPercents / 100),
                        child: Icon(
                          MdiIcons.arrowUpThick,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: (topPercents / 100) * screenSize.size.height / 10 * 0.7,
            child: SpaceAgenda(),
          )
        ],
      ),
    );
  }

  handleDragUpdate(top, bottom) {
    setState(() {
      btPercents = bottom;
      topPercents = top;
    });
  }
}
