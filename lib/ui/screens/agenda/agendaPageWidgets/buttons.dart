import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

import '../agendaPage.dart';

String weekName = "";

class AgendaButtons extends StatefulWidget {
  final Function getLessons;

  const AgendaButtons({Key key, this.getLessons}) : super(key: key);

  @override
  _AgendaButtonsState createState() => _AgendaButtonsState();
}

class _AgendaButtonsState extends State<AgendaButtons> {
  void initState() {
    super.initState();
    getWeekName();
  }

  getWeekName() async {
    bool isEven = (await get_week(agendaDate)).isEven;
    bool reverse = await getSetting("reverseWeekNames");
    if (isEven ^= reverse) {
      if (mounted) {
        setState(() {
          weekName = "Semaine A";
        });
      }
    } else {
      if (mounted) {
        setState(() {
          weekName = "Semaine B";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      getWeekName();
    }

    var screenSize = MediaQuery.of(context);
    return Container(
      width: screenSize.size.width / 5 * 3.7,
      padding: EdgeInsets.symmetric(
          vertical: screenSize.size.height / 10 * 0.005, horizontal: screenSize.size.width / 5 * 0.05),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15)),
      child: FittedBox(
        child: Column(
          children: [
            Text(
              weekName,
              style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.05),
                  child: Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                      onTap: () async {
                        setState(() {
                          agendaDate = CalendarTime(agendaDate).startOfDay.subtract(Duration(hours: 24));
                        });
                        await widget.getLessons(agendaDate);
                      },
                      child: Container(
                          height: screenSize.size.height / 10 * 0.45,
                          width: screenSize.size.width / 5 * 0.5,
                          padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  MdiIcons.arrowLeftCircleOutline,
                                  color: ThemeUtils.textColor(),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: (screenSize.size.height / 10 * 8.8) / 10 * 0.05),
                  padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.05),
                  child: Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                      onTap: () async {
                        DateTime someDate = await showDatePicker(
                          locale: Locale('fr', 'FR'),
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2018),
                          lastDate: DateTime(2030),
                          helpText: "",
                          builder: (BuildContext context, Widget child) {
                            return FittedBox(
                              child: Material(
                                color: Colors.transparent,
                                child: Theme(
                                  data: isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[SizedBox(child: child)],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                        if (someDate != null) {
                          setState(() {
                            agendaDate = someDate;
                          });
                          widget.getLessons(agendaDate);
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          agendaDate = CalendarTime().startOfToday;
                        });

                        widget.getLessons(agendaDate);
                      },
                      child: Container(
                          height: screenSize.size.height / 10 * 0.45,
                          width: screenSize.size.width / 5 * 2,
                          padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  DateFormat("EEEE dd MMMM", "fr_FR").format(agendaDate),
                                  style: TextStyle(
                                    fontFamily: "Asap",
                                    color: ThemeUtils.textColor(),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: (screenSize.size.height / 10 * 8.8) / 10 * 0.05),
                  padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.05),
                  child: Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                      onTap: () async {
                        setState(() {
                          agendaDate = CalendarTime(agendaDate).startOfDay.add(Duration(hours: 25));
                        });
                        await widget.getLessons(agendaDate);
                      },
                      child: Container(
                          height: screenSize.size.height / 10 * 0.45,
                          width: screenSize.size.width / 5 * 0.5,
                          padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  MdiIcons.arrowRightCircleOutline,
                                  color: ThemeUtils.textColor(),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
