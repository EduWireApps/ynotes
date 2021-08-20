import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter/scheduler.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/screens/summary/widgets/administrative_data.dart';
import 'package:ynotes_packages/components.dart';
import 'widgets/average.dart';
import 'data/constants.dart';
import 'widgets/last_grades.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({
    Key? key,
  }) : super(key: key);
  State<StatefulWidget> createState() {
    return SummaryPageState();
  }
}

class SummaryPageState extends State<SummaryPage> with YPageMixin {
  bool firstStart = true;
  List<Widget> pages = [
    SummaryAverage(),
    SummaryLastGrades(),
    YVerticalSpacer(1.2.h),
    SummaryAdministrativeData()
  ];

  @override
  Widget build(BuildContext context) {
    return YPage(
        title: "Résumé",
        body: RefreshIndicator(
          onRefresh: () async {},
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: sidePadding),
              child: Container(
                height: 100.h,
                child: ReorderableList(
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        key: Key(index.toString()), leading: Text("test"));
                  },
                  onReorder: (startindex, newindex) {},
                ),
              )),
        ));
  }

  initLoginController() async {
    await appSys.loginController.init();
  }

  initState() {
    super.initState();

    //Init controllers
    SchedulerBinding.instance!.addPostFrameCallback((!mounted
        ? null
        : (_) {
            refreshControllers(force: false);
            if (this.firstStart) {
              initLoginController().then((var f) {
                if (this.firstStart) {
                  this.firstStart = false;
                }
                refreshControllers();
              });
            }
          })!);
  }

  Future<void> refreshControllers({force: true}) async {
    await appSys.gradesController.refresh(force: force);
    await appSys.homeworkController.refresh(force: force);
  }

  showUpdateNote() async {
    if ((appSys.settings.system.lastReadUpdateNote != "0.11.2")) {
      appSys.settings.system.lastReadUpdateNote = "0.11.2";
      appSys.saveSettings();
      await CustomDialogs.showUpdateNoteDialog(context);
    }
  }
}
