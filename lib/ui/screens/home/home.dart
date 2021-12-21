import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/mails/controller.dart';
import 'package:ynotes/core/logic/school_life/controller.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/components/NEW/components.dart';
import 'package:ynotes/ui/screens/home/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> onRefresh() async {
    await Future.wait([
      appSys.api!.getEvents(DateTime.now(), forceReload: false),
      appSys.gradesController.refresh(force: true),
      appSys.homeworkController.refresh(force: true),
      if (appSys.settings.system.chosenParser == 0) appSys.mailsController.refresh(force: true),
      if (appSys.settings.system.chosenParser == 0) appSys.schoolLifeController.refresh(force: true),
    ]);
  }

  @override
  void initState() {
    super.initState();
    UIUtils.showPatchNotes(context);
  }

  @override
  Widget build(BuildContext context) {
    return ZApp(
        page: YPage(
            appBar: YAppBar(
              title: "Accueil",
              actions: [
                if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                  YIconButton(icon: Icons.refresh_rounded, onPressed: onRefresh),
                if (appSys.settings.system.chosenParser == 0)
                  ControllerConsumer<MailsController>(
                      controller: appSys.mailsController,
                      builder: (context, controller, _) {
                        return Stack(alignment: Alignment.center, children: [
                          YIconButton(
                              icon: Icons.mail_rounded, onPressed: () => Navigator.pushNamed(context, "/mailbox")),
                          if ((controller.mails ?? []).where((mail) => !mail.read!).isNotEmpty)
                            Positioned(
                                child: Container(
                                    alignment: Alignment.center,
                                    width: YScale.s4,
                                    height: YScale.s4,
                                    decoration: BoxDecoration(
                                        color: theme.colors.danger.backgroundColor, borderRadius: YBorderRadius.full),
                                    child: Text((controller.mails ?? []).where((mail) => !mail.read!).length.toString(),
                                        style: theme.texts.body2.copyWith(color: theme.colors.danger.foregroundColor))),
                                top: YScale.s3,
                                right: YScale.s1)
                        ]);
                      }),
                if (appSys.settings.system.chosenParser == 0)
                  ControllerConsumer<SchoolLifeController>(
                      controller: appSys.schoolLifeController,
                      builder: (context, controller, _) {
                        return Stack(alignment: Alignment.center, children: [
                          YIconButton(
                              icon: MdiIcons.stamper, onPressed: () => Navigator.pushNamed(context, "/school_life")),
                          if ((controller.tickets ?? []).where((ticket) => !ticket.isJustified!).isNotEmpty)
                            Positioned(
                                child: Container(
                                    alignment: Alignment.center,
                                    width: YScale.s4,
                                    height: YScale.s4,
                                    decoration: BoxDecoration(
                                        color: theme.colors.danger.backgroundColor, borderRadius: YBorderRadius.full),
                                    child: Text(
                                        (controller.tickets ?? [])
                                            .where((ticket) => !ticket.isJustified!)
                                            .length
                                            .toString(),
                                        style: theme.texts.body2.copyWith(color: theme.colors.danger.foregroundColor))),
                                top: YScale.s3,
                                right: YScale.s1)
                        ]);
                      }),
                YHorizontalSpacer(YScale.s2)
              ],
            ),
            onRefresh: onRefresh,
            body: Column(
                mainAxisSize: MainAxisSize.max, children: const [CountDown(), GradesSection(), HomeworkSection()])));
  }
}
