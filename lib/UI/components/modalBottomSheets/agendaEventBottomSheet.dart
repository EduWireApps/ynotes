import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ynotes/UI/utils/themeUtils.dart';
import '../../../classes.dart';
import '../../../usefulMethods.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ynotes/main.dart';

import '../gradesChart.dart';

///Bottom windows with some infos on the discipline and the possibility to change the discipline color
void agendaEventBottomSheet(context) {
  Color colorGroup;

  MediaQueryData screenSize = MediaQuery.of(context);
  showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (BuildContext bc) {
        return Container(
            height: screenSize.size.height / 10 * 4,
            padding: EdgeInsets.all(2),
            child: FittedBox(
              child: new Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                      width: screenSize.size.width / 5 * 3.5,
                      child: AutoSizeText(
                        "Quel évènement voulez-vous créer ?",
                        style: TextStyle(fontFamily: "Asap", fontSize: 26, fontWeight: FontWeight.w400, color: isDarkModeEnabled ? Colors.white : Colors.black),
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(
                    height: screenSize.size.height / 10 * 0.1,
                  ),
                  _buildEventChoiceButton(context, "Récréation", Colors.green.shade200, MdiIcons.coffeeOutline),
                  _buildEventChoiceButton(context, "Activité extra scolaire", Colors.blue.shade200, MdiIcons.piano),
                ],
              ),
            ));
      });
}

_buildEventChoiceButton(BuildContext context, String content, Color color, IconData icon) {
  MediaQueryData screenSize = MediaQuery.of(context);
  return Container(
    margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
      boxShadow: [
        BoxShadow(
          color: darken(Theme.of(context).primaryColor).withOpacity(0.8),
          spreadRadius: 0.2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        child: InkWell(
          splashColor: darken(color),
          onTap: () async {},
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(1.4, 0.0), // 10% of the width, so there are ten blinds.
                  colors: [darken(color, forceAmount: 0.3), color], // whitish to gray
                  tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              width: screenSize.size.width / 5 * 4,
              height: screenSize.size.height / 10 * 1,
              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.25),
              child: Stack(
                children: [
                  Transform.rotate(
                    angle: -0.1,
                    child: Transform.translate(
                        offset: Offset(-screenSize.size.width / 5 * 0.5, -screenSize.size.height / 10 * 0.2),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              icon,
                              color: darken(color, forceAmount: 0.8).withOpacity(0.2),
                              size: screenSize.size.width / 5 * 1.2,
                            ))),
                  ),
                  Center(
                    child: AutoSizeText(content, style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w700, fontSize: 28), textAlign: TextAlign.center),
                  ),
                ],
              )),
        ),
      ),
    ),
  );
}
