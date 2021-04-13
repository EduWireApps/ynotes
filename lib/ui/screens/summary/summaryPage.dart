import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:ynotes/core/logic/appConfig/controller.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/hiddenSettings.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/chart.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/quickGrades.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/quickHomework.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/summaryPageSettings.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

///First page to access quickly to last grades, homework and
class SummaryPage extends StatefulWidget {
  final Function switchPage;

  const SummaryPage({
    Key key,
    this.switchPage,
  }) : super(key: key);
  State<StatefulWidget> createState() {
    return SummaryPageState();
  }
}

bool firstStart = true;
Future donePercentFuture;

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
    appSys.gradesController.refresh();
    appSys.homeworkController.refresh();

    SchedulerBinding.instance.addPostFrameCallback(!mounted
        ? null
        : (_) => {
              appSys.loginController.login().then((var f) async {
                if (firstStart == true) {
                  firstStart = false;
                  await refreshControllers();
                  setState(() {});
                }
              })
            });
  }

  void triggerSettings() {
    summarySettingsController.animateToPage(summarySettingsController.page == 1 ? 0 : 1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Future<void> refreshControllers() async {
    await appSys.gradesController.refresh(force: true);
    await appSys.homeworkController.refresh(force: true);
  }

  showDialog() async {
    await helpDialogs[0].showDialog(context);
    await showUpdateNote();
  }

  showUpdateNote() async {
    if ((await appSys.settings["system"]["lastReadUpdateNote"] != "0.9.2")) {
      await CustomDialogs.showUpdateNoteDialog(context);

      appSys.updateSetting(appSys.settings["system"], "lastReadUpdateNote", "0.9.2");
    }
  }

  Widget separator(BuildContext context, String text) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
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
            child: RefreshIndicator(
              onRefresh: refreshControllers,
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                    stops: [0.0, 0.0, 0.94, 1.0], // 10% purple, 80% transparent, 10% purple
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      separator(context, "Notes"),
                      QuickGrades(
                        switchPage: widget.switchPage,
                        gradesController: appSys.gradesController,
                      ),
                      separator(context, "Devoirs"),
                      QuickHomework(
                        switchPage: widget.switchPage,
                        hwcontroller: appSys.homeworkController,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
