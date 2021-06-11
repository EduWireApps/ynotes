import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';

import 'homeworkPageWidgets/homeworkTimeline.dart';

class HomeworkPage extends StatefulWidget {
  final HomeworkController hwController = appSys.homeworkController;
  HomeworkPage({Key? key}) : super(key: key);
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
    return YPage(
      title: "Devoirs",
      body: HomeworkTimeline(),
      isScrollable: false,
    );
  }

  void initState() {
    super.initState();
  }
}
