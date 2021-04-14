import 'dart:core';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_ns/liquid_progress_indicator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/ui/components/columnGenerator.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/homework/utils.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/quickHomeworkCurvedContainer.dart';

class QuickHomework extends StatefulWidget {
  final Function? switchPage;
  final HomeworkController? hwcontroller;
  const QuickHomework({Key? key, this.switchPage, required this.hwcontroller}) : super(key: key);
  @override
  _QuickHomeworkState createState() => _QuickHomeworkState();
}

class _QuickHomeworkState extends State<QuickHomework> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState(); //init homework
  }

  Future<void> forceRefreshModel() async {
    await this.widget.hwcontroller!.refresh(force: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return ChangeNotifierProvider<HomeworkController?>.value(
        value: this.widget.hwcontroller,
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
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: screenSize.size.width / 5 * 0.3,
                                                      right: screenSize.size.width / 5 * 0.3),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        model.homeworkCompletion[1].toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: "Asap",
                                                          color: ThemeUtils.textColor(),
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                          " fait" +
                                                              (model.homeworkCompletion[1] > 1 ? "s " : " ") +
                                                              "sur ",
                                                          style: TextStyle(
                                                            fontFamily: "Asap",
                                                            color: ThemeUtils.textColor(),
                                                          )),
                                                      Text(
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
                                              ChangeNotifierProvider<HomeworkController?>.value(
                                                value: this.widget.hwcontroller,
                                                child: Consumer<HomeworkController>(builder: (context, model, child) {
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                        left: screenSize.size.width / 5 * 0.3,
                                                        right: screenSize.size.width / 5 * 0.3),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ))),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.8),
                        child: RefreshIndicator(
                          onRefresh: model.refresh,
                          child: CupertinoScrollbar(
                            child: ChangeNotifierProvider<HomeworkController?>.value(
                              value: this.widget.hwcontroller,
                              child: Consumer<HomeworkController>(
                                builder: (context, model, child) {
                                  if (model.getHomework != null && model.getHomework.length != 0) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.4),
                                      child: ColumnBuilder(
                                          itemCount: model.getHomework.length,
                                          itemBuilder: (context, index) {
                                            return FutureBuilder(
                                              initialData: 0,
                                              future: getColor(model.getHomework[index].disciplineCode),
                                              builder: (context, color) => Column(
                                                children: <Widget>[
                                                  if (index == 0 ||
                                                      model.getHomework[index - 1].date !=
                                                          model.getHomework[index].date)
                                                    Container(
                                                      margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.25),
                                                      child: Row(children: <Widget>[
                                                        Text(
                                                          DateFormat("EEEE d", "fr_FR")
                                                                  .format(this
                                                                      .widget
                                                                      .hwcontroller!
                                                                      .getHomework[index]
                                                                      .date!)
                                                                  .toString()
                                                                  .capitalize() +
                                                              " " +
                                                              DateFormat("MMMM", "fr_FR")
                                                                  .format(this
                                                                      .widget
                                                                      .hwcontroller!
                                                                      .getHomework[index]
                                                                      .date!)
                                                                  .toString()
                                                                  .capitalize(),
                                                          style: TextStyle(
                                                              color: ThemeUtils.textColor(),
                                                              fontFamily: "Asap",
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.w600),
                                                        ),
                                                      ]),
                                                    ),
                                                  SizedBox(height: screenSize.size.height / 10 * 0.1),
                                                  HomeworkTicket(
                                                      model.getHomework[index],
                                                      Color(color.data),
                                                      widget.switchPage,
                                                      this.widget.hwcontroller!.refresh,
                                                      model.isFetching && !model.getHomework[index].loaded!),
                                                ],
                                              ),
                                            );
                                          }),
                                    );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.4),
                                      child: Center(
                                        child: FittedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                height: (screenSize.size.height / 10 * 8.8) / 10 * 1.5,
                                                child: Image(
                                                    fit: BoxFit.fitWidth,
                                                    image: AssetImage('assets/images/noHomework.png')),
                                              ),
                                              Text(
                                                "Pas de devoirs à l'horizon... \non se détend ?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Asap",
                                                    color: ThemeUtils.textColor(),
                                                    fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
                                              ),
                                              FlatButton(
                                                  textColor: ThemeUtils.textColor(),
                                                  onPressed: () async {
                                                    await model.refresh(force: true);
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: ThemeUtils.textColor(),
                                                          width: 0.2,
                                                          style: BorderStyle.solid),
                                                      borderRadius: BorderRadius.circular(50)),
                                                  child: !model.isFetching
                                                      ? Text("Recharger",
                                                          style: TextStyle(
                                                            fontFamily: "Asap",
                                                            color: ThemeUtils.textColor(),
                                                          ))
                                                      : FittedBox(
                                                          child: SpinKitThreeBounce(
                                                              color: Theme.of(context).primaryColorDark,
                                                              size: screenSize.size.width / 5 * 0.4))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}

//The basic ticket for homeworks with the discipline and the description and a checkbox
class HomeworkTicket extends StatefulWidget {
  final Homework _homework;
  final Color color;
  final Function refreshCallback;
  final bool load;
  final Function? pageSwitcher;
  const HomeworkTicket(this._homework, this.color, this.pageSwitcher, this.refreshCallback, this.load);
  State<StatefulWidget> createState() {
    return _HomeworkTicketState();
  }
}

class _HomeworkTicketState extends State<HomeworkTicket> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      width: screenSize.size.width,
      margin: EdgeInsets.only(
          bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.1, left: screenSize.size.width / 5 * 0.25),
      child: Stack(
        children: [
          Material(
            color: widget.color,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                widget.pageSwitcher!(2);
              },
              onLongPress: !widget._homework.loaded!
                  ? null
                  : () async {
                      await CustomDialogs.showHomeworkDetailsDialog(context, this.widget._homework);
                      setState(() {});
                    },
              child: Container(
                width: screenSize.size.width / 5 * 4.5,
                height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(39),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: screenSize.size.width / 5 * 0.8,
                      child: FutureBuilder(
                          future: appSys.offline!.doneHomework.getHWCompletion(widget._homework.id ?? ''),
                          initialData: false,
                          builder: (context, snapshot) {
                            bool? done = snapshot.data;
                            return CircularCheckBox(
                              activeColor: Color(0xff15803D),
                              value: done,
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              onChanged: this
                                      .widget
                                      ._homework
                                      .date!
                                      .isBefore(DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now())))
                                  ? null
                                  : (bool? x) async {
                                      widget.refreshCallback();
                                      await appSys.offline!.doneHomework.setHWCompletion(widget._homework.id, x);
                                    },
                            );
                          }),
                    ),
                    FittedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: screenSize.size.width / 5 * 3.5,
                              child: Row(
                                children: [
                                  Container(
                                    width: screenSize.size.width / 5 * 3,
                                    child: AutoSizeText(widget._homework.discipline!,
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            TextStyle(fontSize: 14, fontFamily: "Asap", fontWeight: FontWeight.bold)),
                                  ),
                                  if (widget.load)
                                    Container(
                                        width: screenSize.size.width / 5 * 0.4,
                                        child: FittedBox(
                                          child: SpinKitThreeBounce(
                                            color: ThemeUtils.darken(widget.color),
                                          ),
                                        )),
                                ],
                              )),
                          if (widget._homework.loaded!)
                            Container(
                              width: screenSize.size.width / 5 * 2.7,
                              child: AutoSizeText(
                                parse(widget._homework.rawContent ?? "").documentElement!.text,
                                style: TextStyle(fontFamily: "Asap"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (widget._homework.isATest!)
            Container(
                height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
                width: screenSize.size.width / 5 * 0.2,
                child: TestBadge()),
        ],
      ),
    );
  }
}
