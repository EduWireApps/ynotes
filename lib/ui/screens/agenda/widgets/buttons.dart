import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';

import '../agenda.dart';

String weekName = "";

class AgendaButtons extends StatefulWidget {
  final Function? getLessons;

  const AgendaButtons({Key? key, this.getLessons}) : super(key: key);

  @override
  _AgendaButtonsState createState() => _AgendaButtonsState();
}

class _AgendaButtonsState extends State<AgendaButtons> {
  @override
  Widget build(BuildContext context) {
    if (mounted) {
      getWeekName();
    }

    var screenSize = MediaQuery.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 500),
      child: Container(
        width: screenSize.size.width / 5 * 3.7,
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
        decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(
              weekName,
              style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: screenSize.size.height / 10 * 0.5,
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          setState(() {
                            agendaDate = CalendarTime(agendaDate).startOfDay.subtract(Duration(hours: 24));
                          });
                          await widget.getLessons!(agendaDate);
                        },
                        child: Icon(
                          MdiIcons.arrowLeftCircleOutline,
                          color: ThemeUtils.textColor(),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenSize.size.height / 10 * 0.5,
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          DateTime? someDate = await showDatePicker(
                            locale: Locale('fr', 'FR'),
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2018),
                            lastDate: DateTime(2030),
                            helpText: "",
                            builder: (BuildContext context, Widget? child) {
                              return FittedBox(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Theme(
                                    data: ThemeUtils.isThemeDark ? ThemeData.dark() : ThemeData.light(),
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
                            widget.getLessons!(agendaDate);
                          }
                        },
                        onLongPress: () {
                          setState(() {
                            agendaDate = CalendarTime().startOfToday;
                          });

                          widget.getLessons!(agendaDate);
                        },
                        child: Center(
                          child: AutoSizeText(
                            DateFormat("EEEE dd MMMM", "fr_FR").format(agendaDate!),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.textColor(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: screenSize.size.height / 10 * 0.5,
                    margin: EdgeInsets.only(left: 10),
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                        onTap: () async {
                          setState(() {
                            agendaDate = CalendarTime(agendaDate).startOfDay.add(Duration(hours: 25));
                          });
                          await widget.getLessons!(agendaDate);
                        },
                        child: Icon(
                          MdiIcons.arrowRightCircleOutline,
                          color: ThemeUtils.textColor(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  getWeekName() async {
    bool isEven = (await getWeek(agendaDate!)).isEven;
    bool reverse = appSys.settings.user.agendaPage.reverseWeekNames;

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

  void initState() {
    super.initState();
    getWeekName();
  }
}
