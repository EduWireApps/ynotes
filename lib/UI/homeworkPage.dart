import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/animations/FadeAnimation.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import '../apiManager.dart';
import '../usefulMethods.dart';
import 'package:provider_architecture/provider_architecture.dart';

Future<List<homework>> homeworkListFuture;

class HomeworkPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeworkPageState();
  }
}

enum sortHomeworkValue { date, reversed_date, done, pinned }

PageController _pageController;
//The date the user want to see
DateTime dateToUse;
bool firstStart = true;
API api = APIManager();

class _HomeworkPageState extends State<HomeworkPage> {
  sortHomeworkValue actualSortHomework = sortHomeworkValue.date;
  void initState() {
    super.initState();
    _pageController = PageController();
    //WidgetsFlutterBinding.ensureInitialized();
    //Test if it's the first start
    if (firstStart == true) {
      homeworkListFuture = api.getNextHomework();
      firstStart = false;
    }
  }

  void callback() {
    setState(() {});
  }

  @override
  Future<void> refreshLocalHomeworkList() async {
    setState(() {
      homeworkListFuture = api.getNextHomework(forceReload: true);
    });
    var realHW = await homeworkListFuture;
  }

//Build the main widget container of the homeworkpage
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
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
                        RefreshIndicator(
                          onRefresh: refreshLocalHomeworkList,
                          child: FutureBuilder(
                              future: homeworkListFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List dates = getDates(snapshot.data);
                                  if (snapshot.data.length != 0) {
                                    return Stack(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: (screenSize.size.height /
                                                      10 *
                                                      8.8) /
                                                  10 *
                                                  0.1),
                                          child: AnimatedList(
                                              initialItemCount: dates.length,
                                              padding: EdgeInsets.all(
                                                  screenSize.size.width /
                                                      5 *
                                                      0.1),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index, animation) {
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
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          20.0),
                                                              child: Divider(
                                                                color: isDarkModeEnabled
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                height: 36,
                                                              )),
                                                        ),
                                                        Text(
                                                          getWeeksRelation(
                                                              index,
                                                              snapshot.data),
                                                          style: TextStyle(
                                                              color:
                                                                  isDarkModeEnabled
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                              fontFamily:
                                                                  "Asap"),
                                                        ),
                                                        Expanded(
                                                          child: new Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          20.0,
                                                                      right:
                                                                          10.0),
                                                              child: Divider(
                                                                color: isDarkModeEnabled
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                height: 36,
                                                              )),
                                                        ),
                                                      ]),
                                                    HomeworkContainer(
                                                        dates[index],
                                                        this.callback,
                                                        snapshot.data),
                                                  ],
                                                );
                                              }),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container(
                                      height: screenSize.size.height / 10 * 7.5,
                                      width: screenSize.size.width / 5 * 4.7,
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
                        ),

                        //Second page (with homework)
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        screenSize.size.height / 10 * 0.2),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      top: screenSize.size.height / 10 * 0.1,
                                      left: screenSize.size.width / 5 * 0.5,
                                      child: Container(
                                        width: screenSize.size.width / 5 * 2.5,
                                        padding: EdgeInsets.only(
                                            top:
                                                screenSize.size.width / 5 * 0.1,
                                            bottom:
                                                screenSize.size.width / 5 * 0.1,
                                            left: screenSize.size.width /
                                                5 *
                                                0.5),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(11),
                                                topRight: Radius.circular(11))),
                                        child: Text(
                                            (dateToUse != null
                                                ? toBeginningOfSentenceCase(
                                                    DateFormat("EEEE d MMMM",
                                                            "fr_FR")
                                                        .format(dateToUse)
                                                        .toString())
                                                : ""),
                                            style: TextStyle(
                                                fontFamily: "Asap",
                                                color: isDarkModeEnabled
                                                    ? Colors.white
                                                    : Colors.black)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RaisedButton(
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
                                                screenSize.size.width /
                                                    5 *
                                                    0.1),
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                              size: screenSize.size.width /
                                                  5 *
                                                  0.4,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: screenSize.size.height / 10 * 5.0,
                                width: screenSize.size.width / 5 * 4.4,
                                child: FutureBuilder(
                                    future: api.getHomeworkFor(dateToUse),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          child: ListView.builder(
                                              addRepaintBoundaries: false,
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                return FadeAnimationLeftToRight(
                                                  0.05 + index / 5,
                                                  HomeworkElement(
                                                      snapshot.data[index],
                                                      true),
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
                ],
              )),

          ///Button Bar
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
              width: screenSize.size.width / 5 * 4.7,
              padding: EdgeInsets.only(
                  top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1,
                  bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  border: Border.all(width: 0.00000, color: Colors.transparent),
                  color: Theme.of(context).primaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: (screenSize.size.width / 5) * 0.2),
                    child: Material(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(11),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            print(sortHomeworkValue);
                            int index = sortHomeworkValue.values
                                .indexOf(actualSortHomework);
                            actualSortHomework = sortHomeworkValue.values[
                                index +
                                    (index ==
                                            sortHomeworkValue.values.length - 1
                                        ? -2
                                        : 1)];
                          });
                        },
                        borderRadius: BorderRadius.circular(11),
                        child: Container(
                            height:
                                (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                            width: (screenSize.size.width / 5) * 0.6,
                            child: Icon(
                              case2(
                                actualSortHomework,
                                {
                                  sortHomeworkValue.date:
                                      MdiIcons.sortAscending,
                                  sortHomeworkValue.reversed_date:
                                      MdiIcons.sortDescending,
                                  sortHomeworkValue.done: MdiIcons.check,
                                  sortHomeworkValue.pinned: MdiIcons.bookmark,
                                },
                                MdiIcons.bookmark,
                              ),
                              color: isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black,
                            )),
                      ),
                    ),
                  ),
                  Material(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(11),
                    child: InkWell(
                      child: Container(
                          height:
                              (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                          padding:
                              EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.settings,
                                  color: isDarkModeEnabled
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Text(
                                  "Paramètres",
                                  style: TextStyle(
                                    fontFamily: "Asap",
                                    color: isDarkModeEnabled
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Material(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(11),
                    child: InkWell(
                      onTap: () async {
                        DateTime someDate = await showDatePicker(
                          locale: Locale('fr', 'FR'),
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2018),
                          lastDate: DateTime(2030),
                          helpText: "",
                          builder: (BuildContext context, Widget child) {
                            return Material(
                              color: Colors.transparent,
                              child: Theme(
                                data: isDarkModeEnabled
                                    ? ThemeData.dark()
                                    : ThemeData.light(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                        height: screenSize.size.height / 10 * 5,
                                        child: child)
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        if (someDate != null) {
                          setState(() {
                            dateToUse = someDate;
                          });
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                        }
                      },
                      child: Container(
                          height:
                              (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                          padding:
                              EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                MdiIcons.calendar,
                                color: isDarkModeEnabled
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Text(
                                "Choisir une date",
                                style: TextStyle(
                                  fontFamily: "Asap",
                                  color: isDarkModeEnabled
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

getDates(List<homework> list) {
  List<DateTime> listtoReturn = List<DateTime>();
  list.forEach((element) {
    if (!listtoReturn.contains(element.date)) {
      listtoReturn.add(element.date);
    }
  });

  return listtoReturn;
}

//Function that returns string like "In two weeks" with time relation
getWeeksRelation(int index, List<homework> list) {
  try {
    DateTime dateToUse = list[index].date;

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

//Represents the element containing details about homework
class HomeworkElement extends StatefulWidget {
  final homework homeworkForThisDay;
  final bool initialExpansion;
  HomeworkElement(this.homeworkForThisDay, this.initialExpansion);

  @override
  _HomeworkElementState createState() => _HomeworkElementState();
}

class _HomeworkElementState extends State<HomeworkElement> {
  ///Label to show on the left (I.E : "Tomorrow")
  String mainLabel = "";

  /// Show a small label if the main label doesn't show a date
  bool showSmallLabel = true;

  bool isExpanded;

  ///Expand document part or not
  bool isDocumentExpanded = false;

  //The index of the segmented control (travail à faire / contenu de cours)
  int segmentedControlIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///Expand the element or not
    isExpanded = widget.initialExpansion;
  }

  @override
  Widget build(BuildContext context) {
    ///Expand the element or not

    MediaQueryData screenSize = MediaQuery.of(context);
    var _zoom = 0.0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
      child: FutureBuilder(
          future: getColor(this.widget.homeworkForThisDay.codeMatiere),
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
                        width: screenSize.size.width / 5 * 4.5,
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
                                  this.widget.homeworkForThisDay.matiere,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Asap",
                                      fontWeight: FontWeight.normal),
                                ),
                                if (widget.homeworkForThisDay.interrogation ==
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
                            bottomRight: Radius.circular(15)),
                        child: Column(
                          children: <Widget>[
                            if (this.widget.homeworkForThisDay.interrogation ==
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
                                child: Column(
                                  children: <Widget>[
                                    if (widget.homeworkForThisDay
                                            .documentsContenuDeSeance.length !=
                                        0)
                                      Container(
                                        height:
                                            screenSize.size.height / 10 * 0.6,
                                        width: screenSize.size.width / 5 * 3.2,
                                        child: CupertinoSegmentedControl<int>(
                                            onValueChanged: (i) {
                                              setState(() {
                                                segmentedControlIndex = i;
                                              });
                                            },
                                            groupValue: segmentedControlIndex,
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
                                    Container(
                                        child: Text(this
                                            .widget
                                            .homeworkForThisDay
                                            .nomProf)),
                                    HtmlWidget(
                                        //Delete all format made by teachers to allow the zoom
                                        segmentedControlIndex == 0
                                            ? this
                                                .widget
                                                .homeworkForThisDay
                                                .contenu
                                            : this
                                                .widget
                                                .homeworkForThisDay
                                                .contenuDeSeance,
                                        onTapUrl: (url) async {
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw "Unable to launch url";
                                      }
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            if ((segmentedControlIndex == 0
                                        ? this
                                            .widget
                                            .homeworkForThisDay
                                            .documents
                                            .length
                                        : this
                                            .widget
                                            .homeworkForThisDay
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 75),
                                      width: screenSize.size.width / 5 * 4.4,
                                      height: isDocumentExpanded
                                          ? (segmentedControlIndex == 0
                                                  ? widget.homeworkForThisDay
                                                      .documents.length
                                                  : widget
                                                      .homeworkForThisDay
                                                      .documentsContenuDeSeance
                                                      .length) *
                                              (screenSize.size.height /
                                                  10 *
                                                  0.7)
                                          : 0,
                                      child: ListView.builder(
                                          itemCount: segmentedControlIndex == 0
                                              ? widget.homeworkForThisDay
                                                  .documents.length
                                              : widget
                                                  .homeworkForThisDay
                                                  .documentsContenuDeSeance
                                                  .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Material(
                                              color: Color(0xff5FA9DA),
                                              child: InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 0.2,
                                                              color: Colors
                                                                  .white))),
                                                  width: screenSize.size.width /
                                                      5 *
                                                      4.4,
                                                  height:
                                                      screenSize.size.height /
                                                          10 *
                                                          0.7,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: screenSize
                                                                      .size
                                                                      .width /
                                                                  5 *
                                                                  0.1),
                                                          width: screenSize
                                                                  .size.width /
                                                              5 *
                                                              2.8,
                                                          child: ClipRRect(
                                                            child: Marquee(
                                                                text: (segmentedControlIndex ==
                                                                                0
                                                                            ? widget
                                                                                .homeworkForThisDay.documents
                                                                            : widget
                                                                                .homeworkForThisDay.documentsContenuDeSeance)[
                                                                        index]
                                                                    .libelle,
                                                                blankSpace:
                                                                    screenSize
                                                                            .size
                                                                            .width /
                                                                        5 *
                                                                        0.2,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Asap",
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: screenSize
                                                                .size.width /
                                                            5 *
                                                            0.1,
                                                        top: screenSize
                                                                .size.height /
                                                            10 *
                                                            0.11,
                                                        child: Container(
                                                          height: screenSize
                                                                  .size.height /
                                                              10 *
                                                              0.5,
                                                          decoration: BoxDecoration(
                                                              color: darken(Color(
                                                                  0xff5FA9DA)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: <Widget>[
                                                              if ((segmentedControlIndex == 0
                                                                          ? widget
                                                                              .homeworkForThisDay
                                                                              .documents
                                                                          : widget
                                                                              .homeworkForThisDay
                                                                              .documentsContenuDeSeance)[index]
                                                                      .libelle
                                                                      .substring((segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].libelle.length - 3) ==
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
                                                              if ((segmentedControlIndex == 0
                                                                          ? widget
                                                                              .homeworkForThisDay
                                                                              .documents
                                                                          : widget
                                                                              .homeworkForThisDay
                                                                              .documentsContenuDeSeance)[index]
                                                                      .libelle
                                                                      .substring((segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].libelle.length - 3) ==
                                                                  "pdf")
                                                                VerticalDivider(
                                                                  width: 2,
                                                                  color: Color(
                                                                      0xff5FA9DA),
                                                                ),
                                                              ViewModelProvider<
                                                                      DownloadModel>.withConsumer(
                                                                  viewModel:
                                                                      DownloadModel(),
                                                                  builder:
                                                                      (context,
                                                                          model,
                                                                          child) {
                                                                    return FutureBuilder(
                                                                        future: model.fileExists((segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index]
                                                                            .libelle),
                                                                        initialData:
                                                                            false,
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          if (snapshot.data ==
                                                                              false) {
                                                                            if (model.isDownloading) {
                                                                              /// If download is in progress or connecting
                                                                              if (model.downloadProgress == null || model.downloadProgress < 100) {
                                                                                return Container(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                    horizontal: screenSize.size.width / 5 * 0.2,
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: SizedBox(
                                                                                      width: screenSize.size.width / 5 * 0.3,
                                                                                      height: screenSize.size.width / 5 * 0.3,
                                                                                      child: CircularProgressIndicator(
                                                                                        backgroundColor: Colors.green,
                                                                                        strokeWidth: screenSize.size.width / 5 * 0.05,
                                                                                        value: model.downloadProgress,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }

                                                                              ///Download is ended
                                                                              else {
                                                                                return Container(
                                                                                    child: IconButton(
                                                                                  icon: Icon(
                                                                                    MdiIcons.check,
                                                                                    color: Colors.green,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    openFile((segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].libelle);
                                                                                  },
                                                                                ));
                                                                              }
                                                                            }

                                                                            ///Isn't downloading
                                                                            if (!model.isDownloading) {
                                                                              return IconButton(
                                                                                icon: Icon(
                                                                                  MdiIcons.fileDownloadOutline,
                                                                                  color: Colors.white,
                                                                                ),
                                                                                onPressed: () async {
                                                                                  await model.download((segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].id.toString(), (segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].type, (segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].libelle);
                                                                                },
                                                                              );
                                                                            }
                                                                          }

                                                                          ///If file already exists
                                                                          else {
                                                                            return Container(
                                                                                child: IconButton(
                                                                              icon: Icon(
                                                                                MdiIcons.check,
                                                                                color: Colors.green,
                                                                              ),
                                                                              onPressed: () async {
                                                                                openFile((segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].libelle);
                                                                              },
                                                                            ));
                                                                          }
                                                                        });
                                                                  }),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),

                            //Show a button to send homework
                            if (this.widget.homeworkForThisDay.rendreEnLigne ==
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
  final List<homework> listHW;
  const HomeworkContainer(this.date, this.callback, this.listHW);

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

  getHomeworkInList(List<homework> list) {
    List<homework> listToReturn = new List<homework>();
    listToReturn.clear();
    list.forEach((element) {
      if (element.date == widget.date) {
        listToReturn.add(element);
      }
    });
    return listToReturn;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    if (widget.date != null) {
      getTimeRelation();

//Container with homework date
      return AnimatedContainer(
        margin:
            EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
        duration: Duration(milliseconds: 170),
        width: screenSize.size.width / 5 * 5,
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
                /* onTap: () {
                  /*_pageController.animateToPage(1,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                  dateToUse = widget.date;
                  widget.callback();*/
                },*/
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                child: Container(
                  width: screenSize.size.width / 5 * 5,
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
                              //The main date or date relation
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
                            //Small date
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
                                        MdiIcons.pin,
                                        color: Colors.white,
                                        size: screenSize.size.width / 5 * 0.5,
                                      )),
                                ),
                              ],
                            ),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.size.height / 10 * 0.1,
                            horizontal: screenSize.size.width / 5 * 0.1),
                        child: Container(
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              addAutomaticKeepAlives: true,
                              shrinkWrap: true,
                              itemCount:
                                  getHomeworkInList(widget.listHW).length,
                              itemBuilder: (context, index) {
                                return HomeworkElement(
                                    getHomeworkInList(widget.listHW)[index],
                                    true);
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
      );
    }
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
