import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/hiddenSettings.dart';
import 'package:ynotes/ui/mixins/layoutMixin.dart';
import 'package:ynotes/ui/screens/agenda/agendaPageWidgets/agenda.dart';
import 'package:ynotes/ui/screens/agenda/agendaPageWidgets/agendaSettings.dart';

DateTime? agendaDate;

class AgendaPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldState;
  AgendaPage({Key? key, required this.parentScaffoldState}) : super(key: key);

  @override
  AgendaPageState createState() => AgendaPageState();
}

class AgendaPageState extends State<AgendaPage> with Layout {
  PageController agendaPageSettingsController = PageController(initialPage: 1);
  double btPercents = 0;
  double topPercents = 100;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
          title: new Text(
            "Agenda",
            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
          ),
          leading: !isVeryLargeScreen
              ? TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                  child: Icon(MdiIcons.menu, color: ThemeUtils.textColor()),
                  onPressed: () async {
                    widget.parentScaffoldState.currentState?.openDrawer();
                  },
                )
              : null,
          actions: [
            TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)),
              child: Icon(MdiIcons.tuneVariant, color: ThemeUtils.textColor()),
              onPressed: () async {
                triggerSettings();
              },
            )
          ],
          backgroundColor: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).backgroundColor,
      body: HiddenSettings(
          controller: agendaPageSettingsController,
          settingsWidget: AgendaSettings(),
          child: Agenda()),
    );
  }

  void triggerSettings() {
    agendaPageSettingsController.animateToPage(agendaPageSettingsController.page == 1 ? 0 : 1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
}
