import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/pronote.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'package:ynotes_packages/components.dart';

String dossier = "Reçus";

List<Mail> localList = [];
Future? mailsListFuture;
late Future<List<PollInfo>?> pollsFuture;
List<PollInfo>? pollsList = [];

class PollsPage extends StatefulWidget {
  const PollsPage({Key? key}) : super(key: key);

  @override
  _PollsPageState createState() => _PollsPageState();
}

enum sortValue { date, reversed_date, author }

class _PollsPageState extends State<PollsPage> with LayoutMixin {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return YPage(
        title: "Sondages",
        isScrollable: false,
        body: RefreshIndicator(
            onRefresh: () => refreshPolls(forced: true),
            child: FutureBuilder<List<PollInfo>?>(
                future: pollsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null && snapshot.data!.length != 0) {
                    SchedulerBinding.instance!.addPostFrameCallback((_) => mounted
                        ? setState(() {
                            pollsList = snapshot.data;
                          })
                        : null);

                    return YShadowScrollContainer(
                      color: Theme.of(context).backgroundColor,
                      children: [
                        ListView.builder(
                            itemCount: pollsList!.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: ExpansionTile(
                                      backgroundColor: Colors.transparent,
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            (snapshot.data?[index].title != null
                                                    ? (snapshot.data ?? [])[index].title ?? "" + " - "
                                                    : "") +
                                                (((snapshot.data ?? [])[index].start != null)
                                                    ? DateFormat("dd/MM/yyyy")
                                                        .format((snapshot.data ?? [])[index].start!)
                                                    : ""),
                                            style: TextStyle(
                                                fontFamily: "Asap",
                                                fontWeight: FontWeight.bold,
                                                color: ThemeUtils.textColor()),
                                          ),
                                          AutoSizeText(
                                            (snapshot.data ?? [])[index].author ?? "",
                                            style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Column(
                                          children: [
                                            _buildPollQuestion((snapshot.data ?? [])[index], screenSize),
                                            FittedBox(
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    side: BorderSide(width: 1, color: Colors.white),
                                                    fillColor:
                                                        MaterialStateColor.resolveWith(ThemeUtils.getCheckBoxColor),
                                                    shape: const CircleBorder(),
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        (snapshot.data ?? [])[index].read = value;
                                                      });
                                                      if ((await (appSys.api as APIPronote).setPronotePollRead(
                                                          (snapshot.data ?? [])[index],
                                                          ((snapshot.data ?? [])[index].questions ?? []).first))) {
                                                        CustomDialogs.showAnyDialog(
                                                            context, "Votre choix a été confirmé");
                                                        refreshPolls(forced: true);
                                                      } else {
                                                        setState(() {
                                                          (snapshot.data ?? [])[index].read = value!;
                                                        });
                                                      }
                                                      await refreshPolls(forced: true);
                                                    },
                                                    value: pollsList![index].read,
                                                  ),
                                                  AutoSizeText(
                                                    "J'ai pris connaissance de cette information",
                                                    style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                      ],
                    );
                  } else {
                    return SpinKitFadingFour(
                      color: Theme.of(context).primaryColorDark,
                    );
                  }
                })));
  }

  @override
  void initState() {
    super.initState();
    refreshPolls();
  }

  Future<void> refreshPolls({bool forced = false}) async {
    setState(() {
      pollsFuture = (appSys.api as APIPronote).getPronotePolls(forceReload: forced);
    });
    await pollsFuture;
  }

  Widget _buildPollChoices(PollInfo poll, PollQuestion question, screenSize) {
    //user info
    List<Widget> list = [];
    for (var i = 0; i < (question.choices ?? []).length; i++) {
      list.add(Container(
          padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
          child: Row(
            children: [
              Checkbox(
                side: BorderSide(width: 1, color: Colors.white),
                fillColor: MaterialStateColor.resolveWith(ThemeUtils.getCheckBoxColor),
                shape: const CircleBorder(),
                value: (question.answers ?? "").contains((question.choices ?? [])[i].rank.toString()),
                onChanged: (value) async {
                  if ((await (appSys.api as APIPronote).setPronotePolls(poll, question, (question.choices ?? [])[i]))) {
                    CustomDialogs.showAnyDialog(context, "Votre choix a été confirmé");
                    refreshPolls(forced: true);
                  }
                },
              ),
              Text((question.choices ?? [])[i].choiceName ?? "")
            ],
          )));
    }
    return new Column(children: list);
  }

  Widget _buildPollQuestion(PollInfo mainPoll, screenSize) {
    List<Widget> list = [];
    for (var i = 0; i < (mainPoll.questions ?? []).length; i++) {
      list.add(Container(
        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
        child: Column(
          children: [
            HtmlWidget(((mainPoll.questions ?? [])[i].question) ?? "",
                textStyle: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"), onTapUrl: (url) async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw "Unable to launch url";
              }
            }),
            _buildPollChoices(mainPoll, (mainPoll.questions ?? [])[i], screenSize)
          ],
        ),
      ));
    }
    return new Column(children: list);
  }
}
