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
import '../../../apiManager.dart';
import '../../../usefulMethods.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/UI/screens/spacePageWidgets/agendaGrid.dart';

void agendaEventEdit(context, {AgendaReminder reminder}) {
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
        return agendaEventEditLayout(reminder, screenSize);
      });
}

class agendaEventEditLayout extends StatefulWidget {
  AgendaReminder reminder;
  agendaEventEditLayout(
    this.reminder,
    this.screenSize, {
    Key key,
  }) : super(key: key);

  final MediaQueryData screenSize;

  @override
  _agendaEventEditLayoutState createState() => _agendaEventEditLayoutState();
}

class _agendaEventEditLayoutState extends State<agendaEventEditLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.widget.reminder != null) {
      print("ezzeze");
      wholeDay = this.widget.reminder.wholeDay;
      title = this.widget.reminder.name;
      description = this.widget.reminder.description;
    }
  }

  String title;
  Color tagColor;
  DateTime start;
  DateTime end;
  String description;
  bool wholeDay = true;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
        height: screenSize.size.height / 10 * 8.5,
        width: screenSize.size.width / 5 * 4.8,
        padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: screenSize.size.width / 5 * 4.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2), height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75, width: screenSize.size.width / 5 * 2, child: Icon(MdiIcons.cancel, color:Colors.redAccent))),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2), height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75, width: screenSize.size.width / 5 * 2, child: Icon(MdiIcons.check, color: isDarkModeEnabled ? Colors.white : Colors.black))),
                ],
              ),
            ),
            SizedBox(height: screenSize.size.height / 10 * 0.2),
            Container(
              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
              child: TextField(
                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: screenSize.size.width / 5 * 0.35),
                decoration: new InputDecoration.collapsed(hintText: 'Ajouter un titre', hintStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8))),
              ),
            ),
            Divider(height: screenSize.size.height / 10 * 0.4),
            Container(
              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: screenSize.size.width / 5 * 0.3,
                    height: screenSize.size.width / 5 * 0.3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: screenSize.size.width / 5 * 0.1),
                  Text(
                    'Ajouter une couleur',
                    style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                  )
                ],
              ),
            ),
            Divider(height: screenSize.size.height / 10 * 0.4),
            Container(
              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Toute la journée',
                        style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                      ),
                      value: wholeDay,
                      onChanged: (nValue) {
                        setState(() {
                          wholeDay = nValue;
                        });
                      }),
                  if (!wholeDay)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: screenSize.size.width / 5 * 0.4,
                          height: screenSize.size.width / 5 * 0.4,
                          child: Icon(
                            MdiIcons.calendar,
                            size: screenSize.size.width / 5 * 0.4,
                            color: isDarkModeEnabled ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(width: screenSize.size.width / 5 * 0.1),
                        Text(
                          'Changer la date',
                          style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                        )
                      ],
                    ),
                ],
              ),
            ),
            Divider(height: screenSize.size.height / 10 * 0.4),
            Container(
              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: screenSize.size.width / 5 * 0.4,
                    height: screenSize.size.width / 5 * 0.4,
                    child: Icon(
                      MdiIcons.bell,
                      size: screenSize.size.width / 5 * 0.4,
                      color: isDarkModeEnabled ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(width: screenSize.size.width / 5 * 0.1),
                  Text(
                    'Aucune alarme',
                    style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8), fontSize: screenSize.size.width / 5 * 0.25),
                  )
                ],
              ),
            ),
            Divider(height: screenSize.size.height / 10 * 0.4),
            Container(
              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
              width: screenSize.size.width / 5 * 4.5,
              height: screenSize.size.height / 10 * 2.5,
              child: TextField(
                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: screenSize.size.width / 5 * 0.25),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: new InputDecoration.collapsed(hintText: 'Description', hintStyle: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8))),
              ),
            ),
            Divider(height: screenSize.size.height / 10 * 0.4),
          ],
        ));
  }
}
