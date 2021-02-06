import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/hiddenSettings.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/quickGrades.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/quickHomework.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/summaryPageSettings.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/chart.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

///First page to access quickly to last grades, homework and
class SummaryPage extends StatefulWidget {
  final Function switchPage;

  const SummaryPage({Key key, this.switchPage}) : super(key: key);
  State<StatefulWidget> createState() {
    return SummaryPageState();
  }
}

Future donePercentFuture;
Future allGrades;
bool firstStart = true;

//Global keys used in showcase
GlobalKey _gradeChartGB = GlobalKey();
GlobalKey _quickGradeGB = GlobalKey();

class SummaryPageState extends State<SummaryPage> {
  double actualPage;
  PageController _pageControllerSummaryPage;
  PageController todoSettingsController;
  bool done2 = false;
  double offset;
  ExpandableController alertExpandableDialogController = ExpandableController();
  PageController summarySettingsController = PageController(initialPage: 1);

  initState() {
    super.initState();

    todoSettingsController = new PageController(initialPage: 0);
    initialIndexGradesOffset = 0;
    _pageControllerSummaryPage = PageController();
    _pageControllerSummaryPage.addListener(() {
      setState(() {
        actualPage = _pageControllerSummaryPage.page;
        offset = _pageControllerSummaryPage.offset;
      });
    });
    disciplinesListFuture = localApi.getGrades();

    SchedulerBinding.instance.addPostFrameCallback(!mounted
        ? null
        : (_) => {
              initLoginController().then((var f) {
                if (firstStart == true) {
                  refreshLocalGradesList();
                  firstStart = false;
                }
              })
            });
  }

  void triggerSettings() {
    summarySettingsController.animateToPage(summarySettingsController.page == 1 ? 0 : 1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  initLoginController() async {
    await tlogin.init();
  }

  Future<void> refreshLocalGradesList() async {
    print("refresh");
    setState(() {
      disciplinesListFuture = localApi.getGrades(forceReload: true);
    });
    var realGL = await disciplinesListFuture;
  }

  showDialog() async {
    await helpDialogs[0].showDialog(context);
    await showUpdateNote();
  }

  showUpdateNote() async {
    if ((!await getSetting("updateNote0.9+rev1"))) {
      await CustomDialogs.showUpdateNoteDialog(context);
      await setSetting("updateNote0.9+rev1", true);
    }
  }

  showShowCaseDialog(BuildContext _context) async {
    if ((!await getSetting("summaryShowCase"))) {
      ShowCaseWidget.of(_context).startShowCase([_gradeChartGB, _quickGradeGB]);
      await setSetting("summaryShowCase", true);
    }
  }

  Widget separator(BuildContext context, String text) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      height: screenSize.size.height / 10 * 0.35,
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
      child: Row(children: <Widget>[
        Container(
          width: screenSize.size.width / 5 * 0.4,
          height: screenSize.size.height / 10 * 0.05,
          decoration: BoxDecoration(color: ThemeUtils.textColor(), borderRadius: BorderRadius.circular(500)),
          margin: EdgeInsets.only(
            left: screenSize.size.width / 5 * 0.2,
            right: screenSize.size.width / 5 * 0.2,
          ),
        ),
        Text(
          text,
          style:
              TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap", fontSize: 18, fontWeight: FontWeight.w300),
        ),
        Expanded(
          child: Container(
            height: screenSize.size.height / 10 * 0.05,
            decoration: BoxDecoration(
                color: isDarkModeEnabled ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.circular(500)),
            margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2, right: screenSize.size.width / 5 * 0.2),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return VisibilityDetector(
      key: Key('sumpage'),
      onVisibilityChanged: (visibilityInfo) {
        //Ensure that page is visible
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage == 100) {
          showUpdateNote();
        }
      },
      child: HiddenSettings(
          controller: summarySettingsController,
          settingsWidget: SummaryPageSettings(),
          child: Container(
            color: Colors.transparent,
            height: screenSize.size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.size.height / 10 * 0.2,
                  ),
                  //Alert box
                  Container(
                    width: screenSize.size.width / 5 * 4.8,
                    child: ExpandablePanel(
                      hasIcon: false,
                      controller: alertExpandableDialogController,
                      header: Container(
                        width: screenSize.size.width / 5 * 4.8,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.01),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.orange),
                          borderRadius:
                              new BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: new Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              MdiIcons.alert,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: screenSize.size.width / 5 * 0.1,
                            ),
                            Text(
                              "Avertissement",
                              style: TextStyle(
                                  fontFamily: "Asap", color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: screenSize.size.width / 5 * 0.1,
                            ),
                            ValueListenableBuilder(
                                valueListenable: alertExpandableDialogController,
                                builder: (context, boolean, widget) {
                                  return Icon(
                                    alertExpandableDialogController.expanded
                                        ? MdiIcons.chevronUp
                                        : MdiIcons.chevronDown,
                                    color: Colors.white,
                                  );
                                }),
                          ],
                        ),
                      ),
                      collapsed: Container(
                          width: screenSize.size.width / 5 * 4.8,
                          height: screenSize.size.height / 10 * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                new BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10.0,
                                offset: new Offset(0.0, 10.0),
                              ),
                            ],
                          )),
                      expanded: Container(
                        width: screenSize.size.width / 5 * 4.8,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.1),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          border: Border.all(color: Colors.orange),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              new BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: new Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: screenSize.size.width / 5 * 4.8,
                              height: screenSize.size.height / 10 * 0.85,
                              child: AutoSizeText(
                                "Nous sommes en pleine résolution d'un bug important qui concerne l'application. Si votre application ne charge plus les devoirs et/ou les notes, merci de cliquer sur en savoir plus.",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: screenSize.size.height / 10 * 0.05,
                            ),
                            Container(
                              height: screenSize.size.height / 10 * 0.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                                    onPressed: () {
                                      alertExpandableDialogController.toggle();
                                    },
                                    child: Text(
                                      'Réduire',
                                      style: TextStyle(color: Colors.white, fontFamily: "Asap"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenSize.size.width / 5 * 0.1,
                                  ),
                                  RaisedButton(
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                                    onPressed: () async {
                                      await launchURL(
                                          "https://support.ynotes.fr/divers/mon-application-ne-fonctionne-plus");
                                    },
                                    child: Text(
                                      'En savoir plus',
                                      style: TextStyle(color: Colors.white, fontFamily: "Asap"),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  separator(context, "Notes"),
                  //First division (gauge)
                  Container(
                      decoration: BoxDecoration(
                          color: Color(0xff2c274c),
                          border: Border.all(width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(12)),
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                      child: Card(
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: Colors.transparent,
                          child: Container(
                            color: Colors.transparent,
                            width: screenSize.size.width / 5 * 4.5,
                            height: (screenSize.size.height / 10 * 8.8) / 10 * 2,
                            child: Row(
                              children: [
                                Container(
                                    color: Colors.transparent,
                                    width: screenSize.size.width / 5 * 4.5,
                                    child: FutureBuilder(
                                        future: disciplinesListFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return SummaryChart(
                                              getAllGrades(snapshot.data, overrideLimit: true),
                                            );
                                          } else {
                                            return SpinKitThreeBounce(
                                                color: Theme.of(context).primaryColorDark,
                                                size: screenSize.size.width / 5 * 0.4);
                                          }
                                        }))
                              ],
                            ),
                          ))),
                  //Second division (quick marks)
                  Container(
                    margin:
                        EdgeInsets.only(left: screenSize.size.width / 5 * 0.2, top: screenSize.size.height / 10 * 0.1),
                    child: FutureBuilder(
                        future: disciplinesListFuture,
                        initialData: null,
                        builder: (context, snapshot) {
                          List<Grade> grades = List();
                          try {
                            var temp = getAllGrades(snapshot.data);
                            grades = temp;
                          } catch (e) {
                            print(e.toString());
                          }
                          return QuickGrades(
                            grades: grades,
                            callback: widget.switchPage,
                            refreshCallback: refreshLocalGradesList,
                          );
                        }),
                  ),
                  separator(context, "Devoirs"),
                  QuickHomework(
                    switchPage: widget.switchPage,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
