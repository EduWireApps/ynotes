import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ynotes/animations/FadeAnimation.dart';
import 'package:ynotes/animations/Zoomable.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'dart:math' as math;
import '../landGrades.dart';
import '../landHomework.dart';
import '../usefulMethods.dart';

Future<List<DateTime>> HWDates;

class AgendaPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _AgendaPageState();
  }
}

PageController _pageController;
//The date the user want to see
DateTime dateToUse;

class _AgendaPageState extends State<AgendaPage> {
  void initState() {
    _pageController = PageController();
    WidgetsFlutterBinding.ensureInitialized();

    HWDates = getDatesNextHomeWork();
  }

  void callback() {
    setState(() {});
  }

  @override
  Future<void> refreshLocalHomeworkList() async {
    setState(() {
      HWDates = getDatesNextHomeWork();
    });
  }

//Build the main widget container
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      margin:
          EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 0.5),
      height: screenSize.size.height / 10 * 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Homework list view
          Container(
              width: screenSize.size.width / 5 * 4.7,
              height: (screenSize.size.height / 10 * 8.8) / 10 * 7.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  border: Border.all(width: 0.00000, color: Colors.transparent),
                  color: Theme.of(context).primaryColor),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    child: PageView(
                      controller: _pageController,
                      physics: new NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        FutureBuilder(
                            future: HWDates,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.length != 0) {
                                  return Stack(
                                    children: <Widget>[
                                      Container(
                                        width: screenSize.size.width / 5 * 4.7,
                                        height: (screenSize.size.height /
                                                10 *
                                                8.8) /
                                            10 *
                                            1.3,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        child: Center(
                                          child: Container(
                                              width: screenSize.size.width /
                                                  5 *
                                                  4.7),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: (screenSize.size.height /
                                                    10 *
                                                    8.8) /
                                                10 *
                                                1.4),
                                        child: ListView.builder(
                                            itemCount: snapshot.data.length,
                                            padding: EdgeInsets.all(
                                                screenSize.size.width /
                                                    5 *
                                                    0.2),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Column(
                                                children: <Widget>[
                                                  if (getWeeksRelation(index,
                                                          snapshot.data) !=
                                                      null)
                                                    Row(children: <Widget>[
                                                      Expanded(
                                                        child: new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        20.0),
                                                            child: Divider(
                                                              color:
                                                                  isDarkModeEnabled
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                              height: 36,
                                                            )),
                                                      ),
                                                      Text(
                                                        getWeeksRelation(index,
                                                            snapshot.data),
                                                        style: TextStyle(
                                                            color:
                                                                isDarkModeEnabled
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                            fontFamily: "Asap"),
                                                      ),
                                                      Expanded(
                                                        child: new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20.0,
                                                                    right:
                                                                        10.0),
                                                            child: Divider(
                                                              color:
                                                                  isDarkModeEnabled
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                              height: 36,
                                                            )),
                                                      ),
                                                    ]),
                                                  FadeAnimation(
                                                      0.2,
                                                      HomeworkContainer(
                                                        date: snapshot
                                                            .data[index],
                                                        callback: this.callback,
                                                      )),
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container(
                                    height: screenSize.size.height / 10 * 3,
                                    width: screenSize.size.width / 5 * 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image(
                                            fit: BoxFit.fitWidth,
                                            image: AssetImage(
                                                'assets/images/noHomework.png')),
                                        Text(
                                          "Pas de devoirs à l'horizon... \non se détend ?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Asap",
                                            color: isDarkModeEnabled
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            //Reload list
                                            refreshLocalHomeworkList();
                                          },
                                          child: Text("Recharger",
                                              style: TextStyle(
                                                fontFamily: "Asap",
                                                color: isDarkModeEnabled
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      18.0),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColorDark)),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                return SpinKitFadingFour(
                                  color: Theme.of(context).primaryColorDark,
                                  size: screenSize.size.width / 5 * 1,
                                );
                              }
                            }),
                        //Second page (with homework)
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        screenSize.size.height / 10 * 0.2),
                                child: Row(
                                  children: <Widget>[
                                    RaisedButton(
                                      color: Color(0xff3b3b3b),
                                      shape: CircleBorder(),
                                      onPressed: () {
                                        _pageController.animateToPage(0,
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.easeIn);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(
                                              screenSize.size.width / 5 * 0.1),
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                            size:
                                                screenSize.size.width / 5 * 0.4,
                                          )),
                                    ),
                                    Text(
                                        (dateToUse != null
                                            ? toBeginningOfSentenceCase(
                                                DateFormat(
                                                        "EEEE d MMMM", "fr_FR")
                                                    .format(dateToUse)
                                                    .toString())
                                            : ""),
                                        style: TextStyle(
                                            fontFamily: "Asap",
                                            color: isDarkModeEnabled
                                                ? Colors.white
                                                : Colors.black)),
                                  ],
                                ),
                              ),
                              Container(
                                height: screenSize.size.height / 10 * 5.0,
                                width: screenSize.size.width / 5 * 4.4,
                                child: FutureBuilder(
                                    future: getHomeworkFor(dateToUse),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          child: ListView.builder(
                                              addRepaintBoundaries: false,
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                return FadeAnimation(
                                                  0.2,
                                                  HomeworkElement(
                                                      homeWorkForThisDay:
                                                          snapshot.data[index]),
                                                );
                                              }),
                                        );
                                      } else {
                                        return Center(
                                            child: SpinKitFadingFour(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          size: screenSize.size.width / 5 * 1,
                                        ));
                                      }
                                    }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: screenSize.size.width / 5 * 4.7,
                      height: screenSize.size.height / 10 * 0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: Colors.blueGrey),
                    ),
                  ),
                ],
              )),

          ///Button Bar
          Container(
            width: screenSize.size.width / 5 * 4.7,
            margin: EdgeInsets.only(
                top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1),
            padding: EdgeInsets.only(
                top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1,
                bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(width: 0.00000, color: Colors.transparent),
                color: Theme.of(context).primaryColorDark),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  shape: CircleBorder(),
                  onPressed: () {},
                  child: Container(
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      child: Icon(
                        MdiIcons.filter,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                        size: screenSize.size.width / 5 * 0.5,
                      )),
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  shape: CircleBorder(),
                  onPressed: () {},
                  //Open the settings bar
                  child: Container(
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      child: Icon(
                        Icons.settings,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                        size: screenSize.size.width / 5 * 0.5,
                      )),
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  shape: CircleBorder(),
                  onPressed: () {
                    showDatePicker(
                      locale: Locale('fr', 'FR'),
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2030),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: Column(
                            children: <Widget>[child],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      child: Icon(
                        MdiIcons.calendar,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                        size: screenSize.size.width / 5 * 0.5,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Function that returns string like "In two weeks" with time relation
getWeeksRelation(int index, List<DateTime> list) {
  try {
    DateTime dateToUse = list[index];

    var now = new DateFormat("yyyy-MM-dd").format(DateTime.now());
    var difference = dateToUse.difference(DateTime.parse(now)).inDays;

//Next week tester
    if (difference >= 7 - (DateTime.now().weekday - 1) && difference <= 7) {
      if (index > 0) {
        int i = index;
        //This loop is used to prevent return a week difference if the previous item of the list already returned something
        while (i > 0) {
          i--;
          if (getWeeksRelation(i, list) == "La semaine prochaine") {
            break;
          }

          if (i == 0) {
            return "La semaine prochaine";
          }
        }
      } else if (index == 1) {
        if (getWeeksRelation(index - 1, list) != "La semaine prochaine")
          return "La semaine prochaine";
      } else {
        return "La semaine prochaine";
      }
    }
//In 2 weeks tester
    if (difference >= 14 - (DateTime.now().weekday - 1) && difference <= 14) {
      if (index > 1) {
        int i = index;
        while (i > 0) {
          i--;
          if (getWeeksRelation(i, list) == "Dans 2 semaines") {
            break;
          }

          if (i == 0) {
            return "Dans 2 semaines";
          }
        }
      } else if (index == 1) {
        if (getWeeksRelation(index - 1, list) != "Dans 2 semaines")
          return "Dans 2 semaines";
      } else {
        return "Dans 2 semaines";
      }
    }
    if (difference >= 21 - (DateTime.now().weekday - 1) && difference <= 14) {
      if (index > 1) {
        int i = index;
        while (i > 0) {
          i--;
          if (getWeeksRelation(i, list) == "Dans 3 semaines") {
            break;
          }

          if (i == 0) {
            return "Dans 3 semaines";
          }
        }
      } else if (index == 1) {
        if (getWeeksRelation(index - 1, list) != "Dans 3 semaines")
          return "Dans 3 semaines";
      } else {
        return "Dans 3 semaines";
      }
    }

    if (difference >= 28 - (DateTime.now().weekday - 1) && difference <= 28) {
      if (index > 1) {
        int i = index;
        while (i > 0) {
          i--;
          if (getWeeksRelation(i, list) == "Dans 4 semaines") {
            break;
          }

          if (i == 0) {
            return "Dans 4 semaines";
          }
        }
      } else if (index == 1) {
        if (getWeeksRelation(index - 1, list) != "Dans 4 semaines")
          return "Dans 4 semaines";
      } else {
        return "Dans 4 semaines";
      }
    }
    if (difference >= 28) {
      if (index > 1) {
        int i = index;
        while (i > 0) {
          i--;
          if (getWeeksRelation(i, list) == "Dans plus d'un mois") {
            break;
          }

          if (i == 0) {
            return "Dans plus d'un mois";
          }
        }
      } else if (index == 1) {
        if (getWeeksRelation(index - 1, list) != "Dans plus d'un mois")
          return "Dans plus d'un mois";
      } else {
        return "Dans plus d'un mois";
      }
    }
  } catch (error) {
    print(error);
  }
}

class HomeworkElement extends StatefulWidget {
  final homework homeWorkForThisDay;

  HomeworkElement({Key key, @required this.homeWorkForThisDay})
      : super(key: key);

  @override
  _HomeworkElementState createState() => _HomeworkElementState();
}

class _HomeworkElementState extends State<HomeworkElement> {
  ///Label to show on the left (I.E : "Tomorrow")
  String mainLabel = "";

  /// Show a small label if the main label doesn't show a date
  bool showSmallLabel = true;

  ///Expand the element or not
  bool isExpanded = false;

  ///Expand document part or not
  bool isDocumentExpanded = false;

  int sharedValue = 0;
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    var _zoom = 0.0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
      child: FutureBuilder(
          future: getColor(this.widget.homeWorkForThisDay.codeMatiere),
          initialData: Colors.grey,
          builder: (context, snapshot) {
            Color color = snapshot.data;

            return Stack(
              children: <Widget>[
                //Label
                Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: color,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 0, color: Colors.transparent),
                        ),
                        width: screenSize.size.width / 5 * 4.4,
                        height: isExpanded
                            ? (screenSize.size.height / 10 * 8.8) / 10 * 0.9
                            : (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                        child: Stack(children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: screenSize.size.width / 5 * 0.2,
                                top: (screenSize.size.height / 10 * 8.8) /
                                    10 *
                                    0.1),
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  this.widget.homeWorkForThisDay.matiere,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Asap",
                                      fontWeight: FontWeight.normal),
                                ),
                                if (widget.homeWorkForThisDay.interrogation ==
                                    true)
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: screenSize.size.width / 5 * 0.15),
                                    width: screenSize.size.width / 5 * 0.15,
                                    height: screenSize.size.width / 5 * 0.15,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.redAccent),
                                  )
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      margin: EdgeInsets.only(
                          top: (screenSize.size.height / 10 * 8.8) / 10 * 0.5),
                      width: screenSize.size.width / 5 * 4.4,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, color: Colors.transparent),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topRight: (isExpanded
                                ? Radius.circular(25)
                                : Radius.circular(0)),
                            bottomRight: Radius.circular(15)),
                        child: Column(
                          children: <Widget>[
                            if (this.widget.homeWorkForThisDay.interrogation ==
                                    true &&
                                isExpanded)
                              Container(
                                width: screenSize.size.width / 5 * 4.4,
                                height: screenSize.size.width / 10 * 0.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15)),
                                    color: Colors.orangeAccent,
                                    border: Border.all(
                                      width: 0,
                                      color: Colors.transparent,
                                    )),
                                child: Text(
                                  "Interrogation",
                                  style: TextStyle(
                                      fontFamily: "Asap", color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            Container(
                              color: Colors.white,
                              width: screenSize.size.width / 5 * 4.4,
                              height: isExpanded ? null : 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0, color: Colors.transparent)),
                                padding: isExpanded
                                    ? EdgeInsets.only(
                                        left: screenSize.size.height / 10 * 0.1,
                                        top: screenSize.size.height / 10 * 0.1,
                                        right:
                                            screenSize.size.height / 10 * 0.1)
                                    : null,
                                //The html widget is used to show the homework content
                                child: Column(
                                  children: <Widget>[
                                    if (widget.homeWorkForThisDay
                                            .documentsContenuDeSeance.length !=
                                        0)
                                      Container(
                                        height:
                                            screenSize.size.height / 10 * 0.6,
                                        width: screenSize.size.width / 5 * 3.2,
                                        child: CupertinoSegmentedControl<int>(
                                            onValueChanged: (i) {
                                              setState(() {
                                                sharedValue = i;
                                              });
                                            },
                                            groupValue: sharedValue,
                                            children: <int, Widget>{
                                              0: Text(
                                                'A faire',
                                                style: TextStyle(
                                                    fontFamily: "Asap"),
                                              ),
                                              1: Text(
                                                'Contenu',
                                                style: TextStyle(
                                                    fontFamily: "Asap"),
                                                textAlign: TextAlign.center,
                                              ),
                                            }),
                                      ),
                                    ZoomableWidget(
                                      child: HtmlWidget(
                                        //Delete all format made by teachers to allow the zoom
                                        sharedValue == 0
                                            ? this
                                                .widget
                                                .homeWorkForThisDay
                                                .contenu
                                            : this
                                                .widget
                                                .homeWorkForThisDay
                                                .contenuDeSeance,

                                        onTapUrl: (url) => showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text('onTapUrl'),
                                            content: Text(url),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if ((sharedValue == 0
                                        ? this
                                            .widget
                                            .homeWorkForThisDay
                                            .documents
                                            .length
                                        : this
                                            .widget
                                            .homeWorkForThisDay
                                            .documentsContenuDeSeance
                                            .length) !=
                                    0 &&
                                isExpanded)
                              Container(
                                width: screenSize.size.width / 5 * 4.4,
                                child: Column(
                                  children: <Widget>[
                                    Material(
                                      color: Color(0xff2874A6),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isDocumentExpanded =
                                                !isDocumentExpanded;
                                          });
                                        },
                                        child: Container(
                                          height:
                                              screenSize.size.height / 10 * 0.5,
                                          width:
                                              screenSize.size.width / 5 * 4.4,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Documents",
                                                style: TextStyle(
                                                    fontFamily: "Asap",
                                                    color: Colors.white),
                                              ),
                                              Icon(MdiIcons.fileOutline,
                                                  color: Colors.white),
                                              if (isDocumentExpanded)
                                                SizedBox(
                                                  width: screenSize.size.width /
                                                      5 *
                                                      1.88,
                                                ),
                                              if (isDocumentExpanded)
                                                FadeAnimation(
                                                  0.1,
                                                  IconButton(
                                                    icon: Icon(
                                                      MdiIcons.downloadMultiple,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      // do something
                                                    },
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 75),
                                      width: screenSize.size.width / 5 * 4.4,
                                      height: isDocumentExpanded
                                          ? (sharedValue == 0
                                                  ? widget.homeWorkForThisDay
                                                      .documents.length
                                                  : widget
                                                      .homeWorkForThisDay
                                                      .documentsContenuDeSeance
                                                      .length) *
                                              (screenSize.size.height /
                                                  10 *
                                                  0.5)
                                          : 0,
                                      child: CupertinoScrollbar(
                                        child: ListView.builder(
                                            itemCount: sharedValue == 0
                                                ? widget.homeWorkForThisDay
                                                    .documents.length
                                                : widget
                                                    .homeWorkForThisDay
                                                    .documentsContenuDeSeance
                                                    .length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Material(
                                                color: Color(0xff5FA9DA),
                                                child: InkWell(
                                                  child: Container(
                                                    width:
                                                        screenSize.size.width /
                                                            5 *
                                                            4.4,
                                                    height: (sharedValue == 0
                                                            ? widget
                                                                .homeWorkForThisDay
                                                                .documents
                                                                .length
                                                            : widget
                                                                .homeWorkForThisDay
                                                                .documentsContenuDeSeance
                                                                .length) *
                                                        screenSize.size.height /
                                                        10 *
                                                        0.2,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: screenSize
                                                                  .size.width /
                                                              5 *
                                                              3,
                                                          child: Text(
                                                              (sharedValue == 0
                                                                          ? widget
                                                                              .homeWorkForThisDay
                                                                              .documents
                                                                          : widget
                                                                              .homeWorkForThisDay
                                                                              .documentsContenuDeSeance)[
                                                                      index]
                                                                  .libelle,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Asap",
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                        Positioned(
                                                          right:   screenSize.size.width /
                                                            5 *
                                                            0.1,
                                                          child: Row(
                                                            children: <Widget>[
                                                              if ((sharedValue == 0
                                                                          ? widget
                                                                              .homeWorkForThisDay
                                                                              .documents
                                                                          : widget
                                                                              .homeWorkForThisDay
                                                                              .documentsContenuDeSeance)[index]
                                                                      .libelle
                                                                      .substring((sharedValue == 0 ? widget.homeWorkForThisDay.documents : widget.homeWorkForThisDay.documentsContenuDeSeance)[index].libelle.length - 3) ==
                                                                  "pdf")
                                                                IconButton(
                                                                  icon: Icon(
                                                                    MdiIcons
                                                                        .eyeOutline,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    // do something
                                                                  },
                                                                ),
                                                              IconButton(
                                                                icon: Icon(
                                                                  MdiIcons
                                                                      .fileDownloadOutline,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  await download(
                                                                      (sharedValue == 0 ? widget.homeWorkForThisDay.documents : widget.homeWorkForThisDay.documentsContenuDeSeance)[
                                                                              index]
                                                                          .id,
                                                                      (sharedValue == 0 ? widget.homeWorkForThisDay.documents : widget.homeWorkForThisDay.documentsContenuDeSeance)[
                                                                              index]
                                                                          .type,
                                                                      (sharedValue == 0
                                                                              ? widget.homeWorkForThisDay.documents
                                                                              : widget.homeWorkForThisDay.documentsContenuDeSeance)[index]
                                                                          .libelle);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (this.widget.homeWorkForThisDay.rendreEnLigne ==
                                    true &&
                                isExpanded)
                              Material(
                                color: Color(0xff63A86A),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                child: InkWell(
                                  child: Container(
                                    width: screenSize.size.width / 5 * 4.4,
                                    height: screenSize.size.height / 10 * 0.5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Rendre en ligne",
                                          style: TextStyle(
                                              fontFamily: "Asap",
                                              color: Colors.white),
                                        ),
                                        Icon(Icons.file_upload,
                                            color: Colors.white)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (!isExpanded)
                              Material(
                                color: color,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isExpanded = !isExpanded;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.00000,
                                          color: Colors.transparent),
                                    ),
                                    width: screenSize.size.width / 5 * 4.4,
                                    height: screenSize.size.height / 10 * 0.4,
                                    child: Center(
                                      child: Icon(Icons.expand_more),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )),
                )
              ],
            );
          }),
    );
  }
}

///Homework container to access the homeworks on the right page

class HomeworkContainer extends StatefulWidget {
  final DateTime date;
  final Function callback;
  const HomeworkContainer({Key key, this.date, this.callback})
      : super(key: key);

  @override
  _HomeworkContainerState createState() => _HomeworkContainerState();
}

class _HomeworkContainerState extends State<HomeworkContainer> {
  ///Label to show on the left (I.E : "Tomorrow")
  String mainLabel = "";

  /// Show a small label if the main label doesn't show a date
  bool showSmallLabel = true;
  int containerSize = 0;
  @override
  initState() {}

  ///Really important function that indicate for example if homework DateTime is tomorrow
  getTimeRelation() {
    DateTime dateToUse = widget.date;
    var now = new DateFormat("yyyy-MM-dd").format(DateTime.now());
    var difference = dateToUse.difference(DateTime.parse(now)).inDays;
    //Value that indicate the number of day offset with today when it's not considered as near

    if (difference == 0) {
      mainLabel = "Aujourd'hui";
      showSmallLabel = true;
    }
    if (difference == 1) {
      mainLabel = "Demain";
      showSmallLabel = true;
    }
    if (difference == 2) {
      mainLabel = "Après-demain";
      showSmallLabel = true;
    }
    if (difference >= 3) {
      mainLabel = toBeginningOfSentenceCase(
          DateFormat("EEEE d MMMM", "fr_FR").format(dateToUse).toString());
      showSmallLabel = false;
    }
    if (difference < 0) {
      mainLabel = toBeginningOfSentenceCase(
          DateFormat("EEEE d MMMM", "fr_FR").format(dateToUse).toString());
      showSmallLabel = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    if (widget.date != null) {
      getTimeRelation();

      return AnimatedContainer(
        margin:
            EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
        duration: Duration(milliseconds: 170),
        width: screenSize.size.width / 5 * 4.1,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: <Widget>[
            Material(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              child: InkWell(
                onLongPress: () {
                  if (containerSize == 0) {
                    setState(() {
                      containerSize = 2;
                    });
                  } else {
                    setState(() {
                      containerSize = 0;
                    });
                  }
                },
                onTap: () {
                  _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                  dateToUse = widget.date;
                  widget.callback();
                },
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                child: Container(
                  width: screenSize.size.width / 5 * 4.4,
                  //height: screenSize.size.width / 10 * 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  padding:
                      EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: (showSmallLabel
                                ? 0
                                : screenSize.size.height / 10 * 0.2),
                            bottom: screenSize.size.height / 10 * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              mainLabel,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: isDarkModeEnabled
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: "Asap",
                                  fontSize: screenSize.size.height / 10 * 0.4,
                                  fontWeight: FontWeight.w600),
                            ),
                            if (showSmallLabel == true)
                              Text(
                                DateFormat("EEEE d MMMM", "fr_FR")
                                    .format(widget.date),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: isDarkModeEnabled
                                        ? Colors.white70
                                        : Colors.grey,
                                    fontFamily: "Asap",
                                    fontSize:
                                        screenSize.size.height / 10 * 0.2),
                              )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                          duration: Duration(milliseconds: 170),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            color: isDarkModeEnabled
                                ? Color(0xff656565)
                                : Colors.white,
                          ),
                          padding: EdgeInsets.only(
                              top: screenSize.size.height / 10 * 0.1,
                              bottom: screenSize.size.height / 10 * 0.1),
                          height:
                              screenSize.size.width / 10 * containerSize / 1.2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  color: Color(0xff3b3b3b),
                                  shape: CircleBorder(),
                                  onPressed: () {},
                                  child: Container(
                                      width: screenSize.size.width / 5 * 0.7,
                                      height: screenSize.size.width / 5 * 0.7,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.done_all,
                                            color: Colors.greenAccent,
                                            size:
                                                screenSize.size.width / 5 * 0.5,
                                          ),
                                        ],
                                      )),
                                ),
                                RaisedButton(
                                  color: Color(0xff3b3b3b),
                                  onPressed: () {},
                                  shape: CircleBorder(),
                                  child: Container(
                                      width: screenSize.size.width / 5 * 0.7,
                                      height: screenSize.size.width / 5 * 0.7,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.alarm,
                                            color: Colors.white,
                                            size:
                                                screenSize.size.width / 5 * 0.5,
                                          ),
                                        ],
                                      )),
                                ),
                                RaisedButton(
                                  color: Color(0xff3b3b3b),
                                  onPressed: () {},
                                  shape: CircleBorder(),
                                  child: Container(
                                      width: screenSize.size.width / 5 * 0.7,
                                      height: screenSize.size.width / 5 * 0.7,
                                      padding: EdgeInsets.only(
                                          bottom: screenSize.size.height /
                                              10 *
                                              0.05),
                                      child: Icon(
                                        MdiIcons.share,
                                        color: Colors.white,
                                        size: screenSize.size.width / 5 * 0.5,
                                      )),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
      duration: Duration(milliseconds: 170),
      width: screenSize.size.width / 5 * 4.1,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: <Widget>[
          Material(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            child: InkWell(
              onLongPress: () {
                if (containerSize == 0) {
                  setState(() {
                    containerSize = 2;
                  });
                } else {
                  setState(() {
                    containerSize = 0;
                  });
                }
              },
              onTap: () {
                _pageController.animateToPage(1,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              },
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              child: Container(
                width: screenSize.size.width / 5 * 4.4,
                //height: screenSize.size.width / 10 * 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                padding:
                    EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: (showSmallLabel
                              ? 0
                              : screenSize.size.height / 10 * 0.2),
                          bottom: screenSize.size.height / 10 * 0.1),
                      child: Shimmer.fromColors(
                          baseColor: Color(0xff5D6469),
                          highlightColor: Color(0xff8D9499),
                          child: Container(
                            width: screenSize.size.width / 5 * 1,
                            height:
                                (screenSize.size.height / 10 * 8.8) / 10 * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.grey),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 20, size.height / 2);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
