import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/hiddenSettings.dart';
import 'package:ynotes/ui/screens/homework/homeworkPageWidgets/HWlistPage.dart';
import 'package:ynotes/ui/screens/homework/homeworkPageWidgets/HWsingleDayPage.dart';
import 'package:ynotes/ui/screens/summary/summaryPage.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

import 'homeworkPageWidgets/HWsettingsPage.dart';

List<Homework>? localListHomeworkDateToUse;

class HomeworkPage extends StatefulWidget {
  final HomeworkController? hwController;
  HomeworkPage({Key? key, required this.hwController}) : super(key: key);
  State<StatefulWidget> createState() {
    return HomeworkPageState();
  }
}

//The date the user want to see
DateTime? dateToUse;
bool firstStart = true;

bool? isPinnedDateToUse = false;
//Public list of dates to be easily deleted
List dates = [];
//Only use to add homework to database

class HomeworkPageState extends State<HomeworkPage> {
  PageController? _pageControllerHW;
  void initState() {
    super.initState();
    _pageControllerHW = PageController(initialPage: 0);
    //WidgetsFlutterBinding.ensureInitialized();
    //Test if it's the first start

    getPinnedStateDayToUse();
  }

  PageController agendaSettingsController = PageController(initialPage: 1);
  void triggerSettings() {
    agendaSettingsController.animateToPage(agendaSettingsController.page == 1 ? 0 : 1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  getPinnedStateDayToUse() async {
    print(dateToUse);
    var pinnedStatus = await appSys.offline!.pinnedHomework.getPinnedHomeworkSingleDate(dateToUse.toString());
    if (mounted) {
      setState(() {
        isPinnedDateToUse = pinnedStatus;
      });
    }
  }

  void callback() {
    setState(() {});
  }

  animateToPage(int index) {
    _pageControllerHW!.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
  }

  showDialog() async {
    await helpDialogs[2].showDialog(context);
  }

//Build the main widget container of the homeworkpage
  @override
  Widget build(BuildContext context) {
    //Show the pin dialog
    showDialog();
    MediaQueryData screenSize = MediaQuery.of(context);
    return HiddenSettings(
      controller: agendaSettingsController,
      settingsWidget: HomeworkSettingPage(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            margin: EdgeInsets.zero,
            color: Theme.of(context).backgroundColor,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //Homework list view
                  Container(
                      width: screenSize.size.width,
                      height: screenSize.size.height / 10 * 8.18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          border: Border.all(width: 0.00000, color: Colors.transparent),
                          color: Theme.of(context).backgroundColor),
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: PageView(
                              controller: _pageControllerHW,
                              physics: NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                //Second page with homework
                                HomeworkFirstPage(
                                  hwcontroller: this.widget.hwController,
                                ),

                                //Third page (with homework at a specific date)
                                HomeworkSecondPage(animateToPage)
                              ],
                            ),
                          ),
                        ],
                      )),

                  ///Button Bar
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Container(
                      width: screenSize.size.width / 5 * 4.7,
                      padding: EdgeInsets.only(
                          top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1,
                          bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          border: Border.all(width: 0.00000, color: Colors.transparent),
                          color: Theme.of(context).backgroundColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Material(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                              onTap: () {
                                CustomDialogs.showUnimplementedSnackBar(context);
                              },
                              child: Container(
                                  height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.swap_horiz_outlined,
                                          color: ThemeUtils.textColor(),
                                        ),
                                        Text(
                                          "Devoirs à faire",
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
                          Material(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
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
                                          data: appSys.theme!,
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
                                    dateToUse = someDate;
                                    setState() {
                                      localListHomeworkDateToUse = null;
                                    }

                                    getPinnedStateDayToUse();
                                  });

                                  _pageControllerHW!
                                      .animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                }
                              },
                              child: Container(
                                  height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        MdiIcons.calendar,
                                        color: ThemeUtils.textColor(),
                                      ),
                                      Text(
                                        "Choisir une date",
                                        style: TextStyle(
                                          fontFamily: "Asap",
                                          color: ThemeUtils.textColor(),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

getDates(List<Homework> list) {
  List<DateTime?> listtoReturn = [];
  list.forEach((element) {
    if (!listtoReturn.contains(element.date)) {
      listtoReturn.add(element.date);
    }
  });
  listtoReturn.sort();
  return listtoReturn;
}

//Function that returns string like "In two weeks" with time relation
getWeeksRelation(int index, List<Homework> list) {
  try {
    DateTime dateToUse = [];

    var now = new DateFormat("yyyy-MM-dd").format(DateTime.now());
    var difference = dateToUse.difference(DateTime.parse(now)).inDays;

//Next week tester
    if (difference >= 7 - (DateTime.now().weekday - 1) && difference <= 7) {
      if (index > 0) {
        int i = index;
        //This loop is used to prevent return a week difference if the previous item of the list already returned something
        while (i > 0) {
          i--;
          if (getWeeksRelation(i, list) == "La semaine prochaine") {
            break;
          }

          if (i == 0) {
            return "La semaine prochaine";
          }
        }
      } else if (index == 1) {
        if (getWeeksRelation(index - 1, list) != "La semaine prochaine") return "La semaine prochaine";
      } else {
        return "La semaine prochaine";
      }
    }
//In 2 weeks tester
    if (difference >= 14 - (DateTime.now().weekday - 1) && difference <= 14) {
      if (index > 1) {
        int i = index;
        while (i > 0) {
          i--;
          if (getWeeksRelation(i, list) == "Dans 2 semaines") {
            break;
          }

          if (i == 0) {
            return "Dans 2 semaines";
          }
        }
      } else if (index == 1) {
        if (getWeeksRelation(index - 1, list) != "Dans 2 semaines") return "Dans 2 semaines";
      } else {
        return "Dans 2 semaines";
      }
    }
    if (difference >= 21 - (DateTime.now().weekday - 1) && difference <= 14) {
      if (index > 1) {
        int i = index;
        while (i > 0) {
          i--;
          if (getWeeksRelation(i, list) == "Dans 3 semaines") {
            break;
          }

          if (i == 0) {
            return "Dans 3 semaines";
          }
        }
      } else if (index == 1) {
        if (getWeeksRelation(index - 1, list) != "Dans 3 semaines") return "Dans 3 semaines";
      } else {
        return "Dans 3 semaines";
      }
    }

    if (difference >= 28 - (DateTime.now().weekday - 1) && difference <= 28) {
      if (index > 1) {
        int i = index;
        while (i > 0) {
          i--;
          if (getWeeksRelation(i, list) == "Dans 4 semaines") {
            break;
          }

          if (i == 0) {
            return "Dans 4 semaines";
          }
        }
      } else if (index == 1) {
        if (getWeeksRelation(index - 1, list) != "Dans 4 semaines") return "Dans 4 semaines";
      } else {
        return "Dans 4 semaines";
      }
    }
    if (difference >= 28) {
      if (index > 1) {
        int i = index;
        while (i > 0) {
          i--;
          if (getWeeksRelation(i, list) == "Dans plus d'un mois") {
            break;
          }

          if (i == 0) {
            return "Dans plus d'un mois";
          }
        }
      } else if (index == 1) {
        if (getWeeksRelation(index - 1, list) != "Dans plus d'un mois") return "Dans plus d'un mois";
      } else {
        return "Dans plus d'un mois";
      }
    }
  } catch (error) {
    print(error);
  }
}
