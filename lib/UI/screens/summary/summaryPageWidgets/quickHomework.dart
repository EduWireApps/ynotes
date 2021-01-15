import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/models/homework/controller.dart';
import 'package:ynotes/models/homework/utils.dart';
import 'package:ynotes/utils/themeUtils.dart';

class QuickHomework extends StatefulWidget {
  final Function switchPage;

  const QuickHomework({Key key, this.switchPage}) : super(key: key);
  @override
  _QuickHomeworkState createState() => _QuickHomeworkState();
}

class _QuickHomeworkState extends State<QuickHomework> {
  Future donePercentFuture;
  int oldGauge = 0;

  setGauge() async {
    var tempGauge = await HomeworkUtils.getHomeworkDonePercent();
    setState(() {
      oldGauge = tempGauge ?? 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //init homework
    hwcontroller.refresh(force: true);

    //set gauge
    setState(() {
      donePercentFuture = HomeworkUtils.getHomeworkDonePercent();
    });
  }

  void refreshCallback() {
    setState(() {
      donePercentFuture = HomeworkUtils.getHomeworkDonePercent();
    });
  }

  @override
  Future<void> refreshLocalHomeworkList() async {
    await hwcontroller.refresh(force: true);
    setState(() {
      donePercentFuture = HomeworkUtils.getHomeworkDonePercent();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
      color: Theme.of(context).primaryColor,
      child: Container(
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
        width: screenSize.size.width / 5 * 4.5,
        height: screenSize.size.height / 10 * 5.3,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //gauge
                            Container(
                                height: screenSize.size.width / 5 * 0.5,
                                child: FutureBuilder<int>(
                                    future: donePercentFuture,
                                    initialData: oldGauge,
                                    builder: (context, snapshot) {
                                      return LinearPercentIndicator(
                                        center: Text(
                                          snapshot.data.toString() + "%",
                                          style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                        ),
                                        width: screenSize.size.width / 5 * 4.1,
                                        lineHeight: screenSize.size.height / 10 * 0.25,
                                        percent: (snapshot.data ?? 100) / 100,
                                        backgroundColor: Colors.orange.shade400,
                                        animationDuration: 550,
                                        progressColor: Colors.green.shade300,
                                      );
                                    })),
                          ],
                        ),
                      )),

                  //homework part
                  StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.56),
                            height: screenSize.size.height / 10 * 5.1,
                            child: RefreshIndicator(
                              onRefresh: refreshLocalHomeworkList,
                              child: CupertinoScrollbar(
                                child: ChangeNotifierProvider<HomeworkController>.value(
                                  value: hwcontroller,
                                  child: Consumer<HomeworkController>(
                                    builder: (context, model, child) {
                                      if (model.getHomework != null && model.getHomework.length != 0) {
                                        return ListView.builder(
                                            itemCount: model.getHomework.length,
                                            padding: EdgeInsets.only(
                                                left: screenSize.size.width / 5 * 0.1,
                                                right: screenSize.size.width / 5 * 0.1),
                                            itemBuilder: (context, index) {
                                              return FutureBuilder(
                                                initialData: 0,
                                                future: getColor(model.getHomework[index].disciplineCode),
                                                builder: (context, color) => Column(
                                                  children: <Widget>[
                                                    if (index == 0 ||
                                                        model.getHomework[index - 1].date !=
                                                            model.getHomework[index].date)
                                                      Row(children: <Widget>[
                                                        Expanded(
                                                          child: new Container(
                                                              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                                              child: Divider(
                                                                color: ThemeUtils.textColor(),
                                                                height: 36,
                                                              )),
                                                        ),
                                                        Text(
                                                          DateFormat("EEEE d MMMM", "fr_FR")
                                                              .format(hwcontroller.getHomework[index].date)
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: ThemeUtils.textColor(), fontFamily: "Asap"),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                                                              child: Divider(
                                                                color: ThemeUtils.textColor(),
                                                                height: 36,
                                                              )),
                                                        ),
                                                      ]),
                                                    HomeworkTicket(
                                                        model.getHomework[index],
                                                        Color(color.data),
                                                        widget.switchPage,
                                                        refreshCallback,
                                                        model.isFetching && !model.getHomework[index].loaded),
                                                  ],
                                                ),
                                              );
                                            });
                                      } else {
                                        return Center(
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
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//The basic ticket for homeworks with the discipline and the description and a checkbox
class HomeworkTicket extends StatefulWidget {
  final Homework _homework;
  final Color color;
  final Function refreshCallback;
  final bool load;
  final Function pageSwitcher;
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
      margin: EdgeInsets.only(bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.1),
      child: Material(
        color: widget.color,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            widget.pageSwitcher(4);
          },
          onLongPress: !widget._homework.loaded
              ? null
              : () async {
                  await CustomDialogs.showHomeworkDetailsDialog(context, this.widget._homework);
                  setState(() {});
                },
          child: Container(
            width: screenSize.size.width / 5 * 4.3,
            height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(39),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: screenSize.size.width / 5 * 0.8,
                  child: FutureBuilder(
                      future: offline.doneHomework.getHWCompletion(widget._homework.id ?? ''),
                      initialData: false,
                      builder: (context, snapshot) {
                        bool done = snapshot.data;
                        return CircularCheckBox(
                          activeColor: Colors.blue,
                          inactiveColor: Colors.white,
                          value: done,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          onChanged: (bool x) async {
                            widget.refreshCallback();
                            await offline.doneHomework.setHWCompletion(widget._homework.id, x);
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
                          width: screenSize.size.width / 5 * 2.8,
                          child: Row(
                            children: [
                              Container(
                                width: screenSize.size.width / 5 * 2.4,
                                child: AutoSizeText(widget._homework.discipline,
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontFamily: "Asap", fontWeight: FontWeight.bold)),
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
                      if (widget._homework.loaded)
                        Container(
                          width: screenSize.size.width / 5 * 2.8,
                          child: AutoSizeText(
                            parse(widget._homework.rawContent ?? "").documentElement.text,
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
    );
  }
}

/**/
