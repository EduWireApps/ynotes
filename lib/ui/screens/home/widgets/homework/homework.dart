import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';

class Homeworks extends StatefulWidget {
  const Homeworks({Key? key}) : super(key: key);

  @override
  _HomeworksState createState() => _HomeworksState();
}

class _HomeworksState extends State<Homeworks> {
  final controller = appSys.homeworkController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.refresh(force: true);
    });
  }

  List<Homework> get homework => controller.homework(showAll: true) ?? [];

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<HomeworkController>(
        controller: controller,
        builder: (context, controller, _) {
          return homework.isNotEmpty
              ? Column(
                  children: [...homework.map((hw) => Text(hw.rawContent ?? "no content")).toList(), const YDivider()],
                )
              : Container();
        });
  }
}
