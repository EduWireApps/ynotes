import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/pronote.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class PollsDetailsPageArguments {
  final PollInfo poll;
  final APIPronote api;

  const PollsDetailsPageArguments({required this.poll, required this.api});
}

class PollsDetailsPage extends StatefulWidget {
  const PollsDetailsPage({Key? key}) : super(key: key);

  @override
  State<PollsDetailsPage> createState() => _PollsDetailsPageState();
}

class _PollsDetailsPageState extends State<PollsDetailsPage> {
  PollInfo? poll;
  APIPronote? api;
  bool loading = false;

  Future<void> updatePoll({PollQuestion? question, PollChoice? choice}) async {
    if (loading || poll!.read!) return;
    setState(() {
      loading = true;
    });
    if (question == null && choice == null) {
      if (poll!.questions!.length > 1) {
        await YDialogs.showInfo(
            context,
            YInfoDialog(
              title: "Oups",
              body: Text("Tu ne peux pas marquer ceci comme lu car tu n'as pas répondu à toutes les questions.",
                  style: theme.texts.body1),
              confirmLabel: "OK",
            ));
        setState(() {
          loading = false;
        });
        return;
      }
      setState(() {
        loading = false;
      });
      await api!.setPronotePollRead(poll!, poll!.questions!.first);
      setState(() {
        poll!.read = true;
      });
      await api!.getPronotePolls(forceReload: true);
      return;
    }
    // TODO: implement check if questions have been answered
  }

  String get date {
    final date = poll!.start!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (date == today) {
      return "Aujourd'hui";
    } else if (date == yesterday) {
      return "Hier";
    } else {
      return DateFormat("EEEE dd MMMM", "fr_FR").format(poll!.start!).capitalize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = AppRouter.getArgs<PollsDetailsPageArguments>(context);
    poll ??= arguments.poll;
    api ??= arguments.api;

    for (var q in poll!.questions!) {
      print(q.id);
      print(q.answerID);
      print(q.questionName);
      print(q.rank);
      print(q.answers);
      print("---CHOICES---");
      for (var c in q.choices!) {
        print(c.id);
        print(c.choiceName);
        print(c.rank);
        print("\n");
      }
    }
    return YPage(
        appBar: YAppBar(title: poll!.isInformation! ? "Information" : "Sondage"),
        floatingButtons: [
          YFloatingButton(
              icon: Icons.check_rounded,
              onPressed: () async => await updatePoll(),
              color: poll!.read! ? YColor.success : YColor.secondary)
        ],
        body: Column(
          children: [
            _Header(poll: poll!, date: date),
            YVerticalSpacer(YScale.s4),
            _Content(poll: poll!),
          ],
        ));
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.poll,
  }) : super(key: key);

  final PollInfo poll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: YPadding.p(YScale.s4),
      child: Column(
          children: poll.questions!
              .map((question) => HtmlWidget(
                    question.question!,
                    textStyle: theme.texts.body1,
                    onTapUrl: (String url) => launch(url),
                  ))
              .toList()),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.poll,
    required this.date,
  }) : super(key: key);

  final PollInfo poll;
  final String date;

  Widget get _leading {
    final IconData icon = poll.isInformation! ? Icons.info_rounded : Icons.poll_rounded;

    return Container(
        decoration: BoxDecoration(color: theme.colors.foregroundColor, borderRadius: YBorderRadius.lg),
        padding: YPadding.p(YScale.s2),
        child: Icon(icon, color: theme.colors.backgroundLightColor, size: YScale.s6));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: theme.colors.backgroundLightColor,
      leading: _leading,
      title: Text(
        poll.title!,
        style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(poll.anonymous! ? "Anonyme" : poll.author!, style: theme.texts.body2),
          YVerticalSpacer(YScale.s1),
          Text(date, style: theme.texts.body2),
        ],
      ),
      isThreeLine: true,
      minVerticalPadding: YScale.s2,
    );
  }
}
