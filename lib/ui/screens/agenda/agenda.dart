import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'widgets/agenda.dart';
import 'widgets/agenda_settings.dart';

DateTime? agendaDate;

class AgendaPage extends StatefulWidget {
  AgendaPage({Key? key}) : super(key: key);

  @override
  AgendaPageState createState() => AgendaPageState();
}

class AgendaPageState extends State<AgendaPage> with LayoutMixin, YPageMixin {
  @override
  Widget build(BuildContext context) {
    return YPage(
        title: "Agenda",
        actions: [
          IconButton(
              onPressed: () => openLocalPage(YPageLocal(title: "Options", child: AgendaSettings())),
              icon: Icon(MdiIcons.wrench))
        ],
        body: Agenda());
  }
}
