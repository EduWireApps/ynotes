import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/expandables.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/screens/agenda/agendaPageWidgets/agenda.dart';
import 'package:ynotes/ui/screens/agenda/agendaPageWidgets/agendaSettings.dart';
import 'package:ynotes/ui/screens/agenda/agendaPageWidgets/spaceAgenda.dart';

DateTime? agendaDate;

class AgendaPage extends StatefulWidget {
  AgendaPage({Key? key}) : super(key: key);

  @override
  AgendaPageState createState() => AgendaPageState();
}

class AgendaPageState extends State<AgendaPage> with YPageMixin {
  PageController agendaPageSettingsController = PageController(initialPage: 1);
  double btPercents = 0;
  double topPercents = 100;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return YPage(
      title: "Agenda",
      body: Expandables(
        buildTopChild(),
        buildBottomChild(),
        width: screenSize.size.width,
        maxHeight: screenSize.size.height / 10 * 7.2,
        minHeight: screenSize.size.height / 10 * 0.7,
        bottomExpandableColor: ThemeUtils.spaceColor(),
        onDragUpdate: handleDragUpdate,
        animationDuration: 200,
        topExpandableBorderRadius: 11,
        bottomExpandableBorderRadius: 11,
      ),
      actions: [
        IconButton(
            onPressed: () => openLocalPage(YPageLocal(title: "Options", child: AgendaSettings())),
            icon: Icon(MdiIcons.wrench))
      ],
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
                          style:
                              TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold),
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
                          color: ThemeUtils.textColor(),
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

  handleDragUpdate(top, bottom) {
    setState(() {
      btPercents = bottom;
      topPercents = top;
    });
  }

  void triggerSettings() {
    agendaPageSettingsController.animateToPage(agendaPageSettingsController.page == 1 ? 0 : 1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
}
