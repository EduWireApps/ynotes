import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/components/hiddenSettings.dart';
import 'package:ynotes/UI/screens/grades/gradesPage.dart';
import 'package:ynotes/UI/screens/summary/summaryPageWidgets/quickGrades.dart';
import 'package:ynotes/UI/screens/summary/summaryPageWidgets/quickHomework.dart';
import 'package:ynotes/UI/screens/summary/summaryPageWidgets/summaryPageSettings.dart';
import 'package:ynotes/UI/screens/summary/summaryPageWidgets/chart.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/models/homework/controller.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/utils/themeUtils.dart';

import '../../../classes.dart';

///First page to access quickly to last grades, homework and
class SummaryPage extends StatefulWidget {
  final Function switchPage;
  final HomeworkController hwcontroller;
  const SummaryPage({Key key, this.switchPage, @required this.hwcontroller}) : super(key: key);
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
              initTransparentLogin().then((var f) {
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

  initTransparentLogin() async {
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
      margin: EdgeInsets.only(
        top: screenSize.size.height / 10 * 0.1,
        left: screenSize.size.width / 5 * 0.25,
        bottom: screenSize.size.height / 10 * 0.1,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Text(
          text,
          style:
              TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap", fontSize: 25, fontWeight: FontWeight.w600),
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
                  separator(context, "Notes"),
                  //First division (chart)
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
                        EdgeInsets.only(left: screenSize.size.width / 5 * 0.25, top: screenSize.size.height / 10 * 0.1),
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
                    hwcontroller: this.widget.hwcontroller,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
