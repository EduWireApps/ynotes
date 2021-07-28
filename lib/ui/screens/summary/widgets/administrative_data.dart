import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/mails/controller.dart';
import 'package:ynotes/core/logic/mails/models.dart';
import 'package:ynotes/core/logic/school_life/controller.dart';
import 'package:ynotes/core/logic/school_life/models.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/components.dart';

import '../data/constants.dart';
import '../data/texts.dart';
import 'card.dart';

class SummaryAdministrativeData extends StatefulWidget {
  const SummaryAdministrativeData({Key? key}) : super(key: key);

  @override
  _SummaryAdministrativeDataState createState() => _SummaryAdministrativeDataState();
}

class _SummaryAdministrativeDataState extends State<SummaryAdministrativeData> {
  final TextStyle lightTextStyle =
      TextStyle(color: theme.colors.neutral.shade400, fontSize: 11.sp.clamp(0, 18), fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [
      ChangeNotifierProvider<HomeworkController>.value(
          value: appSys.homeworkController,
          child: Consumer<HomeworkController>(builder: (context, model, child) {
            if (model.weekCount == 0) return noData(context, SummaryTexts.noHomework);
            return card(context,
                data: model.doneThisWeek.toString(),
                subData: model.weekCount.toString(),
                text1: model.weekCount == 1 ? SummaryTexts.homeworkDone : SummaryTexts.homeworkDonePlural,
                text2: SummaryTexts.thisWeek,
                routePath: "/homework");
          })),
      ChangeNotifierProvider<HomeworkController>.value(
          value: appSys.homeworkController,
          child: Consumer<HomeworkController>(builder: (context, model, child) {
            if (model.weekCount == 0) return noData(context, SummaryTexts.noExam);
            return card(context,
                data: model.examsCount.toString(),
                text1: model.examsCount == 1 ? SummaryTexts.exam : SummaryTexts.examPlural,
                text2: model.examsCount == 1 ? SummaryTexts.isPlanned : SummaryTexts.isPlannedPlural,
                routePath: "/homework");
          })),
      if (appSys.settings.system.chosenParser == 0)
        ChangeNotifierProvider<SchoolLifeController>.value(
            value: appSys.schoolLifeController,
            child: Consumer<SchoolLifeController>(builder: (context, model, child) {
              final List<SchoolLifeTicket> unjustifiedTickets =
                  model.tickets?.where((t) => t.isJustified == false).toList() ?? [];
              if (unjustifiedTickets.length == 0) return noData(context, SummaryTexts.noTickets);
              return card(context,
                  data: unjustifiedTickets.length.toString(),
                  text1: unjustifiedTickets.length == 1 ? SummaryTexts.ticket : SummaryTexts.ticketPlural,
                  text2: unjustifiedTickets.length == 1 ? SummaryTexts.unjustified : SummaryTexts.unjustifiedPlural,
                  routePath: "/school_life");
            })),
      if (appSys.settings.system.chosenParser == 0)
        ChangeNotifierProvider<MailsController>.value(
            value: appSys.mailsController,
            child: Consumer<MailsController>(builder: (context, model, child) {
              final List<Mail> unreadMails = model.mails?.where((m) => m.read == false).toList() ?? [];
              if (unreadMails.length == 0) return noData(context, SummaryTexts.noMails);
              return card(context,
                  data: unreadMails.length.toString(),
                  text1: unreadMails.length == 1 ? SummaryTexts.mail : SummaryTexts.mailPlural,
                  text2: unreadMails.length == 1 ? SummaryTexts.unread : SummaryTexts.unreadPlural,
                  routePath: "/mailbox");
            })),
    ];

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: sidePadding),
        child: StaggeredGridView.countBuilder(
          primary: false,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          crossAxisSpacing: sidePadding,
          mainAxisSpacing: sidePadding,
          crossAxisCount: 4,
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int i) => cards[i],
          staggeredTileBuilder: (int i) => StaggeredTile.fit(2),
        ));
  }

  Widget card(BuildContext context,
      {required String data,
      String? subData,
      required String text1,
      required String text2,
      required String routePath}) {
    final TextStyle gradeStyle =
        TextStyle(fontSize: 35.sp.clamp(0, 35), fontWeight: FontWeight.w600, color: theme.colors.neutral.shade500);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 60.w, maxHeight: 120),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, routePath),
        child: SummaryCard(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(data, style: gradeStyle),
                      if (subData != null)
                        Text('/' + subData,
                            style: TextStyle(
                                color: theme.colors.neutral.shade400,
                                fontSize: 15.sp.clamp(0, 18),
                                fontWeight: FontWeight.w400)),
                    ],
                  ),
                  Expanded(child: Container()),
                  Icon(Icons.arrow_forward_outlined, color: theme.colors.neutral.shade400)
                ]),
            YVerticalSpacer(5),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: text1,
                      style: TextStyle(
                          color: theme.colors.neutral.shade500,
                          fontSize: 15.sp.clamp(0, 18),
                          fontWeight: FontWeight.w600)),
                  TextSpan(
                    text: " " + text2,
                    style: lightTextStyle,
                  )
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ],
        )),
      ),
    );
  }

  Widget noData(BuildContext context, String text) => SummaryCard(child: Text(text, style: lightTextStyle));
}
