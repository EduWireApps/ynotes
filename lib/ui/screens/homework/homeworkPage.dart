import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/hiddenSettings.dart';

import 'homeworkPageWidgets/HWsettingsPage.dart';
import 'homeworkPageWidgets/homeworkTimeline.dart';

class HomeworkPage extends StatefulWidget {
  final HomeworkController hwController;
  final GlobalKey<ScaffoldState> parentScaffoldState;
  HomeworkPage({Key? key, required this.hwController, required this.parentScaffoldState}) : super(key: key);
  State<StatefulWidget> createState() {
    return HomeworkPageState();
  }
}

//Function that returns string like "In two weeks" with time relation
class HomeworkPageState extends State<HomeworkPage> {
  PageController? _pageControllerHW;
  PageController agendaSettingsController = PageController(initialPage: 1);

  animateToPage(int index) {
    _pageControllerHW!.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    //Show the pin dialog
    showDialog();
    return Scaffold(
      appBar: new AppBar(
          title: new Text(
            "Devoirs",
            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
          ),
          leading: FlatButton(
            color: Colors.transparent,
            child: Icon(MdiIcons.menu, color: ThemeUtils.textColor()),
            onPressed: () async {
              widget.parentScaffoldState.currentState?.openDrawer();
            },
          ),
          backgroundColor: Theme.of(context).backgroundColor),
      body: HiddenSettings(
          controller: agendaSettingsController, settingsWidget: HomeworkSettingPage(), child: HomeworkTimeline()),
    );
  }

  void callback() {
    setState(() {});
  }

  void initState() {
    super.initState();
  }

  showDialog() async {
    await helpDialogs[2].showDialog(context);
  }

//Build the main widget container of the homeworkpage
  void triggerSettings() {
    agendaSettingsController.animateToPage(agendaSettingsController.page == 1 ? 0 : 1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
}
