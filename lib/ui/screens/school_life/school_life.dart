import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/school_life/controller.dart';
import 'package:ynotes/core/utils/controller.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/router.dart';
import 'package:ynotes/ui/components/NEW/navigation/navigation.dart';
import 'package:ynotes/ui/screens/school_life/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

const String routePath = "/school_life";

class SchoolLifePage extends StatefulWidget {
  const SchoolLifePage({Key? key}) : super(key: key);

  @override
  _SchoolLifePageState createState() => _SchoolLifePageState();
}

class _SchoolLifePageState extends State<SchoolLifePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      appSys.schoolLifeController.refresh();
    });
  }

  Future<void> forceRefresh() async {
    if (!appSys.schoolLifeController.loading) {
      await appSys.schoolLifeController.refresh(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<SchoolLifeController>(
        controller: appSys.schoolLifeController,
        builder: (context, controller, _) {
          final bool noTickets = controller.tickets == null || controller.tickets!.isEmpty;
          return ZApp(
              page: YPage(
                  appBar: YAppBar(
                    title: "Vie scolaire",
                    bottom: controller.loading ? const YLinearProgressBar() : null,
                  ),
                  onRefresh: forceRefresh,
                  scrollable: !noTickets,
                  body: noTickets
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
                                  "Aucun ticket, rien à déclarer !",
                                  style: theme.texts.body1,
                                  textAlign: TextAlign.center,
                                ),
                                YVerticalSpacer(YScale.s6),
                                YButton(
                                  onPressed: forceRefresh,
                                  text: "Rafraîchir".toUpperCase(),
                                  color: YColor.secondary,
                                  isDisabled: controller.loading,
                                )
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: controller.tickets!.map((ticket) => _Ticket(ticket: ticket)).toList(),
                        )));
        });
  }
}

class _Ticket extends StatelessWidget {
  final SchoolLifeTicket ticket;

  const _Ticket({Key? key, required this.ticket}) : super(key: key);

  bool get justified => ticket.isJustified ?? false;

  Widget get _leading {
    late final IconData? icon;
    switch (ticket.type) {
      case "Absence":
        icon = Icons.warning_rounded;
        break;
      case "Retard":
        icon = MdiIcons.clockAlertOutline;
        break;
      case "Repas":
        icon = MdiIcons.foodOff;
        break;
      default:
        icon = Icons.warning_rounded;
        break;
    }
    return Container(
        decoration: BoxDecoration(color: theme.colors.backgroundLightColor, borderRadius: YBorderRadius.lg),
        padding: YPadding.p(YScale.s2),
        child: Icon(icon, color: theme.colors.foregroundColor, size: YScale.s6));
  }

  Widget get _trailing {
    final YTColor color = justified ? theme.colors.success : theme.colors.danger;
    return Container(
      decoration: BoxDecoration(color: color.lightColor, borderRadius: YBorderRadius.full),
      margin: YPadding.p(YScale.s2),
      padding: YPadding.p(YScale.s1),
      child: Icon(justified ? Icons.check_rounded : Icons.close_rounded, color: color.backgroundColor, size: YScale.s5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _leading,
      title: Text((ticket.type ?? "Inconnu".capitalize()),
          style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${ticket.displayDate} (${ticket.libelle})", style: theme.texts.body1),
          if (justified)
            Padding(
              padding: YPadding.pt(YScale.s1),
              child: RichText(
                  text: TextSpan(style: theme.texts.body1, children: [
                const TextSpan(text: "Motif : ", style: TextStyle(fontWeight: YFontWeight.semibold)),
                TextSpan(text: ticket.motif ?? "Aucun"),
              ])),
            )
        ],
      ),
      onTap: () => YModalBottomSheets.show(context: context, child: TicketBottomSheet(ticket: ticket)),
      trailing: _trailing,
      isThreeLine: true,
    );
  }
}
