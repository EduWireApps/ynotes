import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/pronote.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/ui/screens/polls/sub_pages/details.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class Poll extends StatelessWidget {
  final PollInfo poll;
  final APIPronote api;
  const Poll({Key? key, required this.poll, required this.api}) : super(key: key);

  String get date {
    final date = poll.start!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (date == today) {
      return "Aujourd'hui";
    } else if (date == yesterday) {
      return "Hier";
    } else {
      return DateFormat("EEEE dd MMMM", "fr_FR").format(poll.start!).capitalize();
    }
  }

  Widget get _leading {
    final IconData icon = poll.isInformation! ? Icons.info_rounded : Icons.poll_rounded;

    return Container(
        decoration: BoxDecoration(color: theme.colors.backgroundLightColor, borderRadius: YBorderRadius.lg),
        padding: YPadding.p(YScale.s2),
        child: Icon(icon, color: theme.colors.foregroundColor, size: YScale.s6));
  }

  Widget get _trailing {
    final YTColor color = poll.read! ? theme.colors.success : theme.colors.warning;
    return Container(
      decoration: BoxDecoration(color: color.lightColor, borderRadius: YBorderRadius.full),
      margin: YPadding.p(YScale.s2),
      padding: YPadding.p(YScale.s1),
      child: Icon(poll.read! ? Icons.check_rounded : Icons.error_outline_rounded,
          color: color.backgroundColor, size: YScale.s5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _leading,
      title: Text(
        poll.title!,
        style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(date, style: theme.texts.body2),
      trailing: _trailing,
      onTap: () =>
          Navigator.pushNamed(context, "/polls/details", arguments: PollsDetailsPageArguments(poll: poll, api: api)),
    );
  }
}
