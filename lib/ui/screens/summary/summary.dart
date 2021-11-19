import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'package:ynotes/ui/screens/grades/grades.dart';
import 'package:ynotes/ui/screens/summary/widgets/quick_grades.dart';
import 'package:ynotes/ui/screens/summary/widgets/quick_homework.dart';
import 'package:ynotes/ui/screens/summary/widgets/quick_school_life.dart';
import 'package:ynotes/ui/screens/summary/widgets/summary_page_settings.dart';

Future? donePercentFuture;

bool firstStart = true;

///First page to access quickly to last grades, homework and
class SummaryPage extends StatefulWidget {
  const SummaryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SummaryPageState();
  }
}

class SummaryPageState extends State<SummaryPage> with LayoutMixin, YPageMixin {
  double? actualPage;
  PageController? todoSettingsController;
  bool done2 = false;
  double? offset;

  @override
  Widget build(BuildContext context) {
    return YPage(
        title: "Résumé",
        actions: [
          IconButton(
              onPressed: () => openLocalPage(const YPageLocal(title: "Options", child: SummaryPageSettings())),
              icon: const Icon(MdiIcons.wrench))
        ],
        isScrollable: false,
        body: VisibilityDetector(
          key: const Key('sumpage'),
          onVisibilityChanged: (visibilityInfo) async {
            if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
              await Permission.notification.request();
            }
            //Ensure that page is visible
            var visiblePercentage = visibilityInfo.visibleFraction * 100;
            if (visiblePercentage == 100) {
              await showUpdateNote();
            }
          },
          child: RefreshIndicator(
            onRefresh: refreshControllers,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  separator(context, "Notes", "/grades"),
                  const QuickGrades(),
                  separator(context, "Devoirs", "/homework"),
                  const QuickHomework(),
                  if (appSys.settings.system.chosenParser == 0) separator(context, "Vie scolaire", "/school_life"),
                  if (appSys.settings.system.chosenParser == 0) const QuickSchoolLife(),
                ],
              ),
            ),
          ),
        ));
  }

  initLoginController() async {
    await appSys.loginController.init();
  }

  @override
  initState() {
    super.initState();
    todoSettingsController = PageController(initialPage: 0);
    initialIndexGradesOffset = 0;

    //Init controllers
    SchedulerBinding.instance!.addPostFrameCallback((!mounted
        ? null
        : (_) {
            refreshControllers(force: false);
            if (firstStart) {
              initLoginController().then((var f) {
                if (firstStart) {
                  firstStart = false;
                }
                refreshControllers();
              });
            }
          })!);
  }

  Future<void> refreshControllers({force = true}) async {
    await appSys.gradesController.refresh(force: force);
    await appSys.homeworkController.refresh(force: force);
  }

  Widget separator(BuildContext context, String text, String routeName) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.only(
        top: screenSize.size.height / 10 * 0.1,
        left: screenSize.size.width / 5 * 0.25,
        bottom: screenSize.size.height / 10 * 0.1,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Text(
          text,
          style:
              TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap", fontSize: 25, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: screenSize.size.width / 5 * 0.25,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, routeName),
            child: Row(
              children: [
                Text(
                  "Accéder à la page",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: ThemeUtils.textColor(), fontFamily: "Asap", fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Icon(Icons.chevron_right, color: ThemeUtils.textColor()),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  showUpdateNote() async {
    const String version = "0.13.7";
    if ((appSys.settings.system.lastReadUpdateNote != version)) {
      appSys.settings.system.lastReadUpdateNote = version;
      appSys.saveSettings();
      await CustomDialogs.showUpdateNoteDialog(context);
    }
  }
}
