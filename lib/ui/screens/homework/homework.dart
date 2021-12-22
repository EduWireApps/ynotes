import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';

import 'widgets/homework_timeline.dart';

class HomeworkPage extends StatefulWidget {
  final HomeworkController hwController = appSys.homeworkController;
  HomeworkPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => HomeworkPageState();
}

//Function that returns string like "In two weeks" with time relation
class HomeworkPageState extends State<HomeworkPage> with LayoutMixin {
  PageController? _pageControllerHW;
  PageController agendaSettingsController = PageController(initialPage: 1);

  animateToPage(int index) {
    _pageControllerHW!.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return const YPage(title: "Devoirs", isScrollable: false, body: HomeworkTimeline());
  }

  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
