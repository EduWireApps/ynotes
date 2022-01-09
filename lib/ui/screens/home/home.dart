import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core_new/api.dart';
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
    await schoolApi.fetch(online: true);
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
                // if (schoolApi.emailsModule.isEnabled)
                //   ControllerConsumer<EmailsModule>(
                //       controller: schoolApi.emailsModule,
                //       builder: (context, module, _) {
                //         final List<Email> emailsUnread = module.emailsReceived.where((email) => !email.read).toList();
                //         return Stack(alignment: Alignment.center, children: [
                //           YIconButton(
                //               icon: Icons.mail_rounded, onPressed: () => Navigator.pushNamed(context, "/mailbox")),
                //           if (emailsUnread.isNotEmpty)
                //             Positioned(
                //                 child: Container(
                //                     alignment: Alignment.center,
                //                     width: YScale.s4,
                //                     height: YScale.s4,
                //                     decoration: BoxDecoration(
                //                         color: theme.colors.danger.backgroundColor, borderRadius: YBorderRadius.full),
                //                     child: Text(emailsUnread.length.toString(),
                //                         style: theme.texts.body2.copyWith(color: theme.colors.danger.foregroundColor))),
                //                 top: YScale.s3,
                //                 right: YScale.s1)
                //         ]);
                //       }),
                // if (schoolApi.schoolLifeModule.isEnabled)
                //   ControllerConsumer<SchoolLifeModule>(
                //       controller: schoolApi.schoolLifeModule,
                //       builder: (context, module, _) {
                //         final List<SchoolLifeTicket> unjustifiedTickets =
                //             module.tickets.where((ticket) => !ticket.isJustified).toList();
                //         return Stack(alignment: Alignment.center, children: [
                //           YIconButton(
                //               icon: MdiIcons.stamper, onPressed: () => Navigator.pushNamed(context, "/school_life")),
                //           if (unjustifiedTickets.isNotEmpty)
                //             Positioned(
                //                 child: Container(
                //                     alignment: Alignment.center,
                //                     width: YScale.s4,
                //                     height: YScale.s4,
                //                     decoration: BoxDecoration(
                //                         color: theme.colors.danger.backgroundColor, borderRadius: YBorderRadius.full),
                //                     child: Text(unjustifiedTickets.length.toString(),
                //                         style: theme.texts.body2.copyWith(color: theme.colors.danger.foregroundColor))),
                //                 top: YScale.s3,
                //                 right: YScale.s1)
                //         ]);
                //       }),
              ],
            ),
            onRefresh: onRefresh,
            body: Column(mainAxisSize: MainAxisSize.max, children: [
              /*CountDown(),*/
              if (schoolApi.gradesModule.isEnabled) const GradesSection(),
              // if (schoolApi.homeworkModule.isEnabled) const HomeworkSection()
            ])));
  }
}
