import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:ynotes/UI/animations/FadeAnimation.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/components/hiddenSettings.dart';
import 'package:ynotes/UI/screens/drawer/drawerBuilderWidgets/drawer.dart';
import 'package:ynotes/UI/screens/grades/gradesPage.dart';
import 'package:ynotes/UI/screens/homework/homeworkPage.dart';
import 'package:ynotes/UI/screens/summary/summaryPageWidgets/quickGrades.dart';
import 'package:ynotes/UI/screens/summary/summaryPageWidgets/summaryPageSettings.dart';
import 'package:ynotes/UI/screens/summary/summaryPageWidgets/chart.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/utils/themeUtils.dart';

import '../../../classes.dart';

///First page to access quickly to last grades, homework and
class SummaryPage extends StatefulWidget {
  final Function switchPage;

  const SummaryPage({Key key, this.switchPage}) : super(key: key);
  State<StatefulWidget> createState() {
    return SummaryPageState();
  }
}

Future donePercentFuture;
int oldGauge = 0;
Future allGrades;
bool firstStart = true;
GlobalKey _one = GlobalKey();

class SummaryPageState extends State<SummaryPage> {
  double actualPage;
  PageController _pageControllerSummaryPage;
  PageController todoSettingsController;
  bool done2 = false;
  double offset;

  int _slider = 1;
  List items = [1, 2, 3, 4, 5];
  PageController summarySettingsController = PageController(initialPage: 1);
  setGauge() async {
    var tempGauge = await getHomeworkDonePercent();
    setState(() {
      oldGauge = tempGauge ?? 0;
    });
  }

  initState() {
    super.initState();

    todoSettingsController = new PageController(initialPage: 0);
    initialIndexGradesOffset = 0;
    _pageControllerSummaryPage = PageController();
    _pageControllerSummaryPage.addListener(() {
      setState(() {
        actualPage = _pageControllerSummaryPage.page;
        offset = _pageControllerSummaryPage.offset;
      });
    });
    homeworkListFuture = localApi.getNextHomework();
    disciplinesListFuture = localApi.getGrades();
    setState(() {
      donePercentFuture = getHomeworkDonePercent();
    });
    setGauge();
    SchedulerBinding.instance.addPostFrameCallback(!mounted
        ? null
        : (_) => {
              initTransparentLogin().then((var f) {
                if (firstStart == true) {
                  refreshLocalHomeworkList();
                  refreshLocalGradesList();
                  firstStart = false;
                }
              })
            });
  }

  void triggerSettings() {
    summarySettingsController.animateToPage(summarySettingsController.page == 1 ? 0 : 1, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  initTransparentLogin() async {
    await tlogin.init();
  }

  @override
  Future<void> refreshLocalHomeworkList() async {
    setState(() {
      homeworkListFuture = localApi.getNextHomework(forceReload: true);
    });
    var realHW = await homeworkListFuture;
    setState(() {
      donePercentFuture = getHomeworkDonePercent();
    });
  }

  @override
  Future<void> refreshLocalGradesList() async {
    setState(() {
      allGradesOld = null;
      disciplinesListFuture = localApi.getGrades(forceReload: true);
    });
    var realGL = await disciplinesListFuture;
  }

  void refreshCallback() {
    setState(() {
      donePercentFuture = getHomeworkDonePercent();
    });
  }

  showDialog() async {
    await helpDialogs[0].showDialog(context);
    await showUpdateNote();
  }

  showUpdateNote() async {
    if ((!await getSetting("updateNote0.9"))) {
      await CustomDialogs.showUpdateNoteDialog(context);
      await setSetting("updateNote0.9", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return VisibilityDetector(
      key: Key('sumpage'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage == 100) {
          showDialog();
        }
      },
      child: HiddenSettings(
          controller: summarySettingsController,
          settingsWidget: SummaryPageSettings(),
          child: ShowCaseWidget(
            builder: Builder(builder: (context) {
              return Container(
                height: screenSize.size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Quick shortcuts
                    Container(
                      width: screenSize.size.width / 5 * 4.5,
                      height: screenSize.size.height / 10 * 0.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 4),
                        child: ListView.builder(
                            padding: EdgeInsets.only(left: screenSize.size.width / 5 * 0.3),
                            scrollDirection: Axis.horizontal,
                            itemCount: entries.length,
                            itemBuilder: (context, index) {
                              if (index != 1 && ((entries[index]["relatedApi"] == null || entries[index]["relatedApi"] == chosenParser))) {
                                return Container(
                                  margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.2),
                                  child: Material(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: BorderSide(width: screenSize.size.width / 5 * 0.008, color: ThemeUtils.textColor())),
                                    child: InkWell(
                                      onTap: () {
                                        widget.switchPage(index);
                                      },
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        width: screenSize.size.width / 5 * 1.3,
                                        height: screenSize.size.height / 10 * 0.5,
                                        child: Center(
                                          child: Text(
                                            entries[index]["menuName"],
                                            style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ),
                    //First division (gauge)

                    Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xff2c274c),
                              Color(0xff46426c),
                            ]),
                            border: Border.all(width: 0),
                            borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                        child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: Colors.transparent,
                            child: Container(
                              color: Colors.transparent,
                              width: screenSize.size.width / 5 * 4.5,
                              height: (screenSize.size.height / 10 * 8.8) / 10 * 2,
                              child: Row(
                                children: [
                                  Container(
                                      color: Colors.transparent,
                                      width: screenSize.size.width / 5 * 4.5,
                                      child: FutureBuilder(
                                          future: disciplinesListFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return SummaryChart(getAllGrades(snapshot.data));
                                            } else {
                                              return SpinKitThreeBounce(color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4);
                                            }
                                          }))
                                ],
                              ),
                            ))),
                    //Third division (quick marks)
                    Container(
                      margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2, top: screenSize.size.height / 10 * 0.1),
                      child: FutureBuilder(
                          future: disciplinesListFuture,
                          initialData: null,
                          builder: (context, snapshot) {
                            return QuickGrades(
                              grades: getAllGrades(snapshot.data),
                              callback: widget.switchPage,
                              refreshCallback: refreshLocalGradesList,
                            );
                          }),
                    ),

                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                      color: Theme.of(context).primaryColor,
                      child: Container(
                        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                        width: screenSize.size.width / 5 * 4.5,
                        height: (screenSize.size.height / 10 * 8.8) / 10 * 5.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: PageView(
                            controller: todoSettingsController,
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
                                            Container(
                                                width: screenSize.size.width / 5 * 0.5,
                                                height: screenSize.size.width / 5 * 0.5,
                                                child: FittedBox(
                                                  child: FutureBuilder<int>(
                                                      future: donePercentFuture,
                                                      initialData: oldGauge,
                                                      builder: (context, snapshot) {
                                                        return CircularPercentIndicator(
                                                          radius: 120,
                                                          lineWidth: screenSize.size.width / 5 * 0.4,
                                                          percent: (snapshot.data ?? 100) / 100,
                                                          backgroundColor: Colors.orange.shade400,
                                                          animationDuration: 550,
                                                          circularStrokeCap: CircularStrokeCap.round,
                                                          progressColor: Colors.green.shade300,
                                                        );
                                                      }),
                                                )),
                                            Text(
                                              "A faire",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontFamily: "Asap", fontSize: 18, color: ThemeUtils.textColor()),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.2, top: screenSize.size.height / 10 * 0.1),
                                      height: (screenSize.size.height / 10 * 8.8) / 10 * 4.4,
                                      child: RefreshIndicator(
                                        onRefresh: refreshLocalHomeworkList,
                                        child: CupertinoScrollbar(
                                          child: FutureBuilder<List<Homework>>(
                                              future: homeworkListFuture,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data.length != 0) {
                                                    return ListView.builder(
                                                        itemCount: snapshot.data.length,
                                                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                        itemBuilder: (context, index) {
                                                          return FutureBuilder(
                                                            initialData: 0,
                                                            future: getColor(snapshot.data[index].codeMatiere),
                                                            builder: (context, color) => Column(
                                                              children: <Widget>[
                                                                if (index == 0 || snapshot.data[index - 1].date != snapshot.data[index].date)
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
                                                                      DateFormat("EEEE d MMMM", "fr_FR").format(snapshot.data[index].date).toString(),
                                                                      style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
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
                                                                HomeworkTicket(snapshot.data[index], Color(color.data), widget.switchPage, refreshCallback),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  } else {
                                                    return FittedBox(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Container(
                                                            height: (screenSize.size.height / 10 * 8.8) / 10 * 1.5,
                                                            child: Image(fit: BoxFit.fitWidth, image: AssetImage('assets/images/noHomework.png')),
                                                          ),
                                                          Text(
                                                            "Pas de devoirs à l'horizon... \non se détend ?",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () {
                                                              //Reload list
                                                              refreshLocalHomeworkList();
                                                            },
                                                            child: snapshot.connectionState != ConnectionState.waiting
                                                                ? Text("Recharger",
                                                                    style: TextStyle(
                                                                      fontFamily: "Asap",
                                                                      color: ThemeUtils.textColor(),
                                                                    ))
                                                                : FittedBox(child: SpinKitThreeBounce(color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4)),
                                                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0), side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  return SpinKitFadingFour(
                                                    color: Theme.of(context).primaryColorDark,
                                                    size: screenSize.size.width / 5 * 0.5,
                                                  );
                                                }
                                              }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //SecondDivision (homeworks)
                    /*
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.3),
                      color: Theme.of(context).primaryColor,
                      child: Container(
                        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1, bottom: screenSize.size.height / 10 * 0.1),
                        width: screenSize.size.width / 5 * 4.5,
                        height: (screenSize.size.height / 10 * 8.8) / 10 * 2,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: FutureBuilder<void>(
                            future: disciplinesListFuture,
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if (getAllGrades(snapshot.data).length > 0) {
                                  return ClipRRect(
                                    child: Stack(
                                      children: <Widget>[
                                        Center(
                                          child: PageView.builder(
                                              physics: BouncingScrollPhysics(),
                                              controller: _pageControllerSummaryPage,
                                              itemCount: getAllGrades(snapshot.data).length,
                                              itemBuilder: (context, position) {
                                                return Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      widget.switchPage(2);
                                                    },
                                                    child: Container(
                                                      height: (screenSize.size.height / 10 * 8.8) / 10 * 1.8,
                                                      width: screenSize.size.width / 5 * 4,
                                                      child: FittedBox(
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Container(
                                                                    child: Badge(
                                                                      showBadge: getAllGrades(snapshot.data)[position].dateSaisie == DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                                      animationType: BadgeAnimationType.scale,
                                                                      toAnimate: true,
                                                                      elevation: 0,
                                                                      position: BadgePosition.topEnd(),
                                                                      badgeColor: Colors.blue,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: screenSize.size.width / 5 * 0.1,
                                                                  ),
                                                                  Text(
                                                                    getAllGrades(snapshot.data)[position].libelleMatiere + " - " + getAllGrades(snapshot.data)[position].date,
                                                                    style: TextStyle(fontFamily: "Asap", color: (ThemeUtils.textColor())),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ],
                                                              ),
                                                              AutoSizeText.rich(
                                                                //MARK
                                                                TextSpan(
                                                                  text: (getAllGrades(snapshot.data)[position].nonSignificatif ? "(" + getAllGrades(snapshot.data)[position].valeur : getAllGrades(snapshot.data)[position].valeur),
                                                                  style: TextStyle(color: (ThemeUtils.textColor()), fontFamily: "Asap", fontWeight: FontWeight.normal, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.5),
                                                                  children: <TextSpan>[
                                                                    if (getAllGrades(snapshot.data)[position].noteSur != "20")

                                                                      //MARK ON
                                                                      TextSpan(text: '/' + getAllGrades(snapshot.data)[position].noteSur, style: TextStyle(color: (ThemeUtils.textColor()), fontWeight: FontWeight.normal, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.4)),
                                                                    if (getAllGrades(snapshot.data)[position].nonSignificatif == true) TextSpan(text: ")", style: TextStyle(color: (ThemeUtils.textColor()), fontWeight: FontWeight.normal, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.5)),
                                                                  ],
                                                                ),
                                                              ),
                                                              if (getAllGrades(snapshot.data)[position].devoir != "") SizedBox(height: screenSize.size.height / 10 * 0.1),
                                                              if (getAllGrades(snapshot.data)[position].devoir != "")
                                                                SizedBox(
                                                                  width: screenSize.size.width / 5 * 3,
                                                                  child: Text(
                                                                    getAllGrades(snapshot.data)[position].devoir,
                                                                    textAlign: TextAlign.center,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 15, fontFamily: "Asap", color: (ThemeUtils.textColor())),
                                                                  ),
                                                                )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                        if (actualPage != null && actualPage != 0)
                                          FadeAnimationLeftToRight(
                                            0.5,
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: RaisedButton(
                                                color: Theme.of(context).primaryColor.withOpacity(0.6),
                                                shape: CircleBorder(),
                                                onPressed: () {
                                                  setState(() {
                                                    actualPage = 0;
                                                  });
                                                  _pageControllerSummaryPage.animateToPage(0, duration: Duration(milliseconds: 250), curve: Curves.easeInOutQuint);
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                                    child: Icon(
                                                      Icons.arrow_left,
                                                      color: ThemeUtils.textColor(),
                                                      size: screenSize.size.width / 5 * 0.4,
                                                    )),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container(
                                    width: screenSize.size.width / 5 * 0.2,
                                    height: screenSize.size.height / 10 * 0.4,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                MdiIcons.emoticonConfused,
                                                color: ThemeUtils.textColor(),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
                                                child: AutoSizeText(
                                                  "Pas de notes.",
                                                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                                ),
                                              ),
                                            ],
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              //Reload list
                                              refreshLocalGradesList();
                                            },
                                            child: snapshot.connectionState != ConnectionState.waiting
                                                ? Text("Recharger",
                                                    style: TextStyle(
                                                      fontFamily: "Asap",
                                                      color: ThemeUtils.textColor(),
                                                    ))
                                                : FittedBox(child: SpinKitThreeBounce(color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4)),
                                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0), side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return SpinKitFadingFour(
                                  color: Theme.of(context).primaryColorDark,
                                  size: screenSize.size.width / 5 * 0.7,
                                );
                              }
                            }),
                      ),
                    ),*/
                  ],
                ),
              );
            }),
          )),
    );
  }

  List<charts.Series<GaugeSegment, String>> _getDoneTasks(int donePercent) {
    final data = [
      new GaugeSegment('Done', donePercent, Color(0xffA6F38B)),
      new GaugeSegment('NotDone', 100 - donePercent, Color(0xffDC6A46)),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'ToDoGauge',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        colorFn: (GaugeSegment segment, __) => charts.ColorUtil.fromDartColor(segment.color),
        strokeWidthPxFn: (GaugeSegment segment, _) => 0.0,
        data: data,
      ),
    ];
  }
}

//The basic ticket for homeworks with the discipline and the description and a checkbox
class HomeworkTicket extends StatefulWidget {
  final Homework _homework;
  final Color color;
  final Function refreshCallback;

  final Function pageSwitcher;
  const HomeworkTicket(this._homework, this.color, this.pageSwitcher, this.refreshCallback);
  State<StatefulWidget> createState() {
    return _HomeworkTicketState();
  }
}

class _HomeworkTicketState extends State<HomeworkTicket> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
      child: Material(
        color: widget.color,
        borderRadius: BorderRadius.circular(39),
        child: InkWell(
          borderRadius: BorderRadius.circular(39),
          onTap: () {
            widget.pageSwitcher(4);
          },
          onLongPress: () async {
            await CustomDialogs.showHomeworkDetailsDialog(context, this.widget._homework);
            setState(() {});
          },
          child: Container(
            width: screenSize.size.width / 5 * 4,
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
                            setState(() {
                              done = !done;
                              donePercentFuture = getHomeworkDonePercent();
                              widget.refreshCallback();
                            });
                            offline.doneHomework.setHWCompletion(widget._homework.id, x);
                          },
                        );
                      }),
                ),
                FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(width: screenSize.size.width / 5 * 2.8, child: Text(widget._homework.matiere, textScaleFactor: 1.0, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontFamily: "Asap", fontWeight: FontWeight.bold))),
                      Container(
                        width: screenSize.size.width / 5 * 2.8,
                        child: AutoSizeText(
                          parse(widget._homework.contenu).documentElement.text,
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

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;
  final Color color;

  GaugeSegment(this.segment, this.size, this.color);
}

//Homework done percent
Future<int> getHomeworkDonePercent() async {
  List list = await getReducedListHomework();
  if (list != null) {
    //Number of elements in list
    int total = list.length;
    if (total == 0) {
      return 100;
    } else {
      int done = 0;

      await Future.forEach(list, (element) async {
        bool isDone = await offline.doneHomework.getHWCompletion(element.id);
        if (isDone) {
          done++;
        }
      });
      print(done);
      int percent = (done * 100 / total).round();

      return percent;
    }
  } else {
    return 100;
  }
}

Future<List<Homework>> getReducedListHomework() async {
  int reduce = await getIntSetting("summaryQuickHomework");
  if (reduce == 11) {
    reduce = 770;
  }
  List<Homework> localList = await localApi.getNextHomework();
  if (localList != null) {
    List<Homework> listToReturn = List<Homework>();
    localList.forEach((element) {
      var now = DateTime.now();
      var date = element.date;

      //ensure that the list doesn't contain the pinned homework
      if (date.difference(now).inDays < reduce && date.isAfter(DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now())))) {
        listToReturn.add(element);
      }
    });
    print(listToReturn.length);
    return listToReturn;
  } else {
    return null;
  }
}
