import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/pronote.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/components/NEW/components.dart';
import 'package:ynotes/ui/screens/polls/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

const String routePath = "/polls";

class PollsPage extends StatefulWidget {
  const PollsPage({Key? key}) : super(key: key);

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  final APIPronote _api = appSys.api as APIPronote;
  bool loading = false;
  List<PollInfo>? polls;
  Future<void> refresh({bool force = false}) async {
    setState(() {
      loading = true;
    });
    final res = await _api.getPronotePolls(forceReload: force);
    setState(() {
      polls = res?..sort((a, b) => b.start!.compareTo(a.start!));
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      refresh();
    });
  }

  Future<void> forceRefresh() async {
    if (!loading) {
      await refresh(force: true);
    }
  }

  bool get noPolls => polls == null || polls!.isEmpty;

  @override
  Widget build(BuildContext context) {
    return ZApp(
        page: YPage(
            appBar: YAppBar(
              title: "Sondages",
              bottom: loading ? const YLinearProgressBar() : null,
              actions: [YIconButton(icon: Icons.settings_rounded, onPressed: () {})], // TODO: implement settings page
            ),
            onRefresh: forceRefresh,
            scrollable: !noPolls,
            body: noPolls
                ? Padding(
                    padding: YPadding.p(YScale.s2),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(routes.where((element) => element.path == routePath).first.icon,
                              color: theme.colors.foregroundColor, size: YScale.s32),
                          YVerticalSpacer(YScale.s4),
                          Text(
                            "Pas de sondage !",
                            style: theme.texts.body1,
                            textAlign: TextAlign.center,
                          ),
                          YVerticalSpacer(YScale.s6),
                          YButton(
                            onPressed: forceRefresh,
                            text: "Rafraîchir".toUpperCase(),
                            color: YColor.secondary,
                            isDisabled: loading,
                          )
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: polls!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) => Poll(poll: polls![i], api: _api))));
  }
}
