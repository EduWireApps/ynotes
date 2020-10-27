import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/expandables.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/spaceAgenda.dart';
import 'package:ynotes/UI/screens/spacePageWidgets/agenda.dart';
import 'package:ynotes/usefulMethods.dart';

class AgendaPage extends StatefulWidget {
  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  double btPercents = 0;
  double topPercents = 100;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      height: screenSize.size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.3),
            child: Expandables(
              buildTopChild(),
              buildBottomChild(),
              minHeight: screenSize.size.height / 10 * 0.7,
              maxHeight: screenSize.size.height / 10 * 7.2,
              spaceBetween: screenSize.size.height / 10 * 0.2,
              width: screenSize.size.width / 5 * 4.7,
              bottomExpandableColor: Color(0xff282246),
              onDragUpdate: handleDragUpdate,
              animationDuration: 200,
              topExpandableBorderRadius: 11,
            ),
          ),
        ],
      ),
    );
  }

  buildTopChild() {
    var screenSize = MediaQuery.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, -(topPercents / 100) * screenSize.size.height / 10 * 0.7),
            child: Container(
              height: screenSize.size.height / 10 * 0.7,
              width: screenSize.size.width / 5 * 4.7,
              decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(11)),
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
      borderRadius: BorderRadius.circular(11),
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, -(btPercents / 100) * screenSize.size.height / 10 * 0.7),
            child: Container(
              height: screenSize.size.height / 10 * 0.7,
              width: screenSize.size.width / 5 * 4.7,
              decoration: BoxDecoration(color: Color(0xff100A30), borderRadius: BorderRadius.circular(11)),
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
