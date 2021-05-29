import 'dart:core';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_ns/liquid_progress_indicator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';

class QuickHomework extends StatefulWidget {
  final Function? switchPage;
  const QuickHomework({Key? key, this.switchPage}) : super(key: key);
  @override
  _QuickHomeworkState createState() => _QuickHomeworkState();
}

//The basic ticket for homeworks with the discipline and the description and a checkbox
class _QuickHomeworkState extends State<QuickHomework> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return ChangeNotifierProvider<HomeworkController>.value(
        value: appSys.homeworkController,
        child: Consumer<HomeworkController>(builder: (context, model, child) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(top: 0),
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 0),
              width: screenSize.size.width,
              child: ClipRRect(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            margin: EdgeInsets.only(
                                top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1,
                                left: screenSize.size.width / 5 * 0.25,
                                right: screenSize.size.width / 5 * 0.15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        color: Theme.of(context).primaryColor,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.08),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(500),
                                                  ),
                                                  width: screenSize.size.width / 5 * 0.4,
                                                  height: screenSize.size.width / 5 * 0.4,
                                                  child: LiquidCircularProgressIndicator(
                                                    value:
                                                        (model.homeworkCompletion[0] ?? 100) / 100, // Defaults to 0.5.
                                                    valueColor: AlwaysStoppedAnimation(Color(
                                                        0xff15803D)), // Defaults to the current Theme's accentColor.
                                                    backgroundColor: Color(0xff27272A),
                                                    borderWidth:
                                                        0.00, // Defaults to the current Theme's backgroundColor.
                                                    borderColor: Colors.transparent,
                                                    direction: Axis.vertical,
                                                    center: Icon(
                                                      Icons.done,
                                                      color: Colors.white,
                                                    ), // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      AutoSizeText(
                                                        model.homeworkCompletion[1].toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: "Asap",
                                                          color: ThemeUtils.textColor(),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                          " fait" +
                                                              (model.homeworkCompletion[1] > 1 ? "s " : " ") +
                                                              "sur ",
                                                          style: TextStyle(
                                                            fontFamily: "Asap",
                                                            color: ThemeUtils.textColor(),
                                                          )),
                                                      AutoSizeText(
                                                        model.homeworkCompletion[2].toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: "Asap",
                                                          color: ThemeUtils.textColor(),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        color: Theme.of(context).primaryColor,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.08),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                                  width: screenSize.size.width / 5 * 0.4,
                                                  height: screenSize.size.width / 5 * 0.4,
                                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.01),
                                                  child: Icon(
                                                    MdiIcons.pen,
                                                    color: Colors.white,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff27272A),
                                                    borderRadius: BorderRadius.circular(500),
                                                  )),
                                              Expanded(
                                                child: ChangeNotifierProvider<HomeworkController?>.value(
                                                  value: appSys.homeworkController,
                                                  child: Consumer<HomeworkController>(builder: (context, model, child) {
                                                    return Container(
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(model.examsCount.toString(),
                                                              style: TextStyle(
                                                                fontFamily: "Asap",
                                                                color: ThemeUtils.textColor(),
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                          Text(" contrôle" + (model.examsCount > 1 ? "s" : ""),
                                                              style: TextStyle(
                                                                fontFamily: "Asap",
                                                                color: ThemeUtils.textColor(),
                                                              )),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.08),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: screenSize.size.width / 5 * 0.4,
                                            height: screenSize.size.width / 5 * 0.4,
                                            padding: EdgeInsets.all(screenSize.size.width / 5 * 0.01),
                                            child: Icon(
                                              MdiIcons.calendarAlert,
                                              color: Colors.white,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xff27272A),
                                              borderRadius: BorderRadius.circular(500),
                                            )),
                                        ChangeNotifierProvider<HomeworkController?>.value(
                                          value: appSys.homeworkController,
                                          child: Consumer<HomeworkController>(builder: (context, model, child) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  left: screenSize.size.width / 5 * 0.3,
                                                  right: screenSize.size.width / 5 * 0.3),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(model.tomorrowCount.toString(),
                                                      style: TextStyle(
                                                        fontFamily: "Asap",
                                                        color: ThemeUtils.textColor(),
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  Text(" pour demain",
                                                      style: TextStyle(
                                                        fontFamily: "Asap",
                                                        color: ThemeUtils.textColor(),
                                                      )),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.08),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: screenSize.size.width / 5 * 0.4,
                                            height: screenSize.size.width / 5 * 0.4,
                                            padding: EdgeInsets.all(screenSize.size.width / 5 * 0.01),
                                            child: Icon(
                                              MdiIcons.calendarWeek,
                                              color: Colors.white,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xff27272A),
                                              borderRadius: BorderRadius.circular(500),
                                            )),
                                        ChangeNotifierProvider<HomeworkController?>.value(
                                          value: appSys.homeworkController,
                                          child: Consumer<HomeworkController>(builder: (context, model, child) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  left: screenSize.size.width / 5 * 0.3,
                                                  right: screenSize.size.width / 5 * 0.3),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(model.weekCount.toString(),
                                                      style: TextStyle(
                                                        fontFamily: "Asap",
                                                        color: ThemeUtils.textColor(),
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  Text(" cette semaine",
                                                      style: TextStyle(
                                                        fontFamily: "Asap",
                                                        color: ThemeUtils.textColor(),
                                                      )),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenSize.size.height / 10 * 0.2,
                                )
                              ],
                            ))),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> forceRefreshModel() async {
    await appSys.homeworkController.refresh(force: true);
  }

  @override
  void initState() {
    super.initState(); //init homework
  }
}
