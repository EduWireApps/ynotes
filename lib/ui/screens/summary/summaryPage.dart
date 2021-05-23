import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/hiddenSettings.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/quickGrades.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/quickHomework.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/summaryPageSettings.dart';

Future? donePercentFuture;

bool firstStart = true;
GlobalKey _gradeChartGB = GlobalKey();

//Global keys used in showcase
GlobalKey _quickGradeGB = GlobalKey();

///First page to access quickly to last grades, homework and
class SummaryPage extends StatefulWidget {
  final Function? switchPage;
  final GlobalKey<ScaffoldState> parentScaffoldState;
  const SummaryPage({
    Key? key,
    this.switchPage,
    required this.parentScaffoldState,
  }) : super(key: key);
  State<StatefulWidget> createState() {
    return SummaryPageState();
  }
}

class SummaryPageState extends State<SummaryPage> {
  double? actualPage;
  late PageController _pageControllerSummaryPage;
  PageController? todoSettingsController;
  bool done2 = false;
  double? offset;
  ExpandableController alertExpandableDialogController = ExpandableController();
  PageController summarySettingsController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Scaffold(
      appBar: new AppBar(
          title: new Text(
            "Résumé",
            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
          ),
          leading: FlatButton(
            color: Colors.transparent,
            child: Icon(MdiIcons.menu, color: ThemeUtils.textColor()),
            onPressed: () async {
              widget.parentScaffoldState.currentState?.openDrawer();
            },
          ),
          actions: [
            FlatButton(
              color: Colors.transparent,
              child: Icon(MdiIcons.tuneVariant, color: ThemeUtils.textColor()),
              onPressed: () async {
                triggerSettings();
              },
            )
          ],
          backgroundColor: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).backgroundColor,
      body: VisibilityDetector(
        key: Key('sumpage'),
        onVisibilityChanged: (visibilityInfo) async {
          await Permission.notification.request();
          //Ensure that page is visible
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (visiblePercentage == 100) {
            await showUpdateNote();
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
                        ),
                        separator(context, "Devoirs"),
                        QuickHomework(
                          switchPage: widget.switchPage,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  initLoginController() async {
    await appSys.loginController.init();
  }

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
    //Init controllers
    appSys.gradesController.refresh(force: false);
    appSys.homeworkController.refresh(force: false);
    SchedulerBinding.instance!.addPostFrameCallback((!mounted
        ? null
        : (_) => {
              if (firstStart)
                {
                  initLoginController().then((var f) {
                    if (firstStart) {
                      firstStart = false;
                    }
                    appSys.gradesController.refresh(force: true);
                    appSys.homeworkController.refresh(force: true);
                  })
                }
            })!);
  }

  Future<void> refreshControllers() async {
    await appSys.gradesController.refresh(force: true);
    await appSys.homeworkController.refresh(force: true);
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
        Text(
          "Accéder à la page",
          style:
              TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap", fontSize: 25, fontWeight: FontWeight.w400),
        ),
      ]),
    );
  }

  showDialog() async {
    await helpDialogs[0].showDialog(context);
    await showUpdateNote();
  }

  showUpdateNote() async {
    if ((appSys.settings!["system"]["lastReadUpdateNote"] != "0.11.2")) {
      appSys.updateSetting(appSys.settings!["system"], "lastReadUpdateNote", "0.11.2");
      await CustomDialogs.showUpdateNoteDialog(context);
    }
  }

  void triggerSettings() {
    summarySettingsController.animateToPage(summarySettingsController.page == 1 ? 0 : 1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
}
