import 'package:ynotes/utils/fileUtils.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/components/hiddenSettings.dart';
import 'package:ynotes/UI/screens/homeworkPageWidgets/HWsecondPage.dart';
import 'package:ynotes/UI/screens/summaryPage.dart';
import 'package:ynotes/utils/themeUtils.dart';
import 'package:ynotes/utils/fileUtils.dart';

import 'package:ynotes/main.dart';
import 'package:ynotes/apis/EcoleDirecte.dart';

import '../../classes.dart';
import '../../usefulMethods.dart';
import 'homeworkPageWidgets/HWfirstPage.dart';
import 'homeworkPageWidgets/HWsettingsPage.dart';

Future<List<Homework>> homeworkListFuture;

List<Homework> localListHomeworkDateToUse;

class HomeworkPage extends StatefulWidget {
  HomeworkPage({Key key}) : super(key: key);
  State<StatefulWidget> createState() {
    return HomeworkPageState();
  }
}

//The date the user want to see
DateTime dateToUse;
bool firstStart = true;

bool isPinnedDateToUse = false;
//Public list of dates to be easily deleted
List dates = List();
//Only use to add homework to database

class HomeworkPageState extends State<HomeworkPage> {
  PageController _pageControllerHW;
  void initState() {
    super.initState();
    _pageControllerHW = PageController(initialPage: 0);
    //WidgetsFlutterBinding.ensureInitialized();
    //Test if it's the first start

    setState(() {
      homeworkListFuture = localApi.getNextHomework();
    });

    getPinnedStateDayToUse();
  }

  PageController agendaSettingsController = PageController(initialPage: 1);
  void triggerSettings() {
    agendaSettingsController.animateToPage(agendaSettingsController.page == 1 ? 0 : 1, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  getPinnedStateDayToUse() async {
    print(dateToUse);
    var pinnedStatus = await offline.getPinnedHomeworkSingleDate(dateToUse.toString());
    if (mounted) {
      setState(() {
        isPinnedDateToUse = pinnedStatus;
      });
    }
  }

  void callback() {
    setState(() {});
  }

  @override
  Future<void> refreshLocalHomeworkList() async {
    setState(() {
      homeworkListFuture = localApi.getNextHomework(forceReload: true);
    });
    var realHW = await homeworkListFuture;
  }

  animateToPage(int index) {
    _pageControllerHW.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
  }

  showDialog() async {
    await helpDialogs[2].showDialog(context);
  }

//Build the main widget container of the homeworkpage
  @override
  Widget build(BuildContext context) {
    //Show the pin dialog
    showDialog();
    MediaQueryData screenSize = MediaQuery.of(context);
    return HiddenSettings(
      controller: agendaSettingsController,
      settingsWidget: HomeworkSettingPage(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            margin: EdgeInsets.zero,
            color: Theme.of(context).primaryColor,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //Homework list view
                  Container(
                      width: screenSize.size.width,
                      height: screenSize.size.height / 10 * 8.18,
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
                              controller: _pageControllerHW,
                              physics: NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                //Second page with homework
                                HomeworkFirstPage(),

                                //Third page (with homework at a specific date)
                                HomeworkSecondPage(animateToPage)
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
                      padding: EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1, bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
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
                          Material(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                              onTap: () {
                                CustomDialogs.showUnimplementedSnackBar(context);
                              },
                              child: Container(
                                  height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.swap_horiz_outlined,
                                          color: ThemeUtils.textColor(),
                                        ),
                                        Text(
                                          "Devoirs à faire",
                                          style: TextStyle(
                                            fontFamily: "Asap",
                                            color: ThemeUtils.textColor(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          Material(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                              onTap: () async {
                                DateTime someDate = await showDatePicker(
                                  locale: Locale('fr', 'FR'),
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2018),
                                  lastDate: DateTime(2030),
                                  helpText: "",
                                  builder: (BuildContext context, Widget child) {
                                    return FittedBox(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Theme(
                                          data: isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[SizedBox(child: child)],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (someDate != null) {
                                  setState(() {
                                    dateToUse = someDate;
                                    setState() {
                                      localListHomeworkDateToUse = null;
                                    }

                                    getPinnedStateDayToUse();
                                  });

                                  _pageControllerHW.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                }
                              },
                              child: Container(
                                  height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        MdiIcons.calendar,
                                        color: ThemeUtils.textColor(),
                                      ),
                                      Text(
                                        "Choisir une date",
                                        style: TextStyle(
                                          fontFamily: "Asap",
                                          color: ThemeUtils.textColor(),
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
            ),
          ),
        ],
      ),
    );
  }
}

getDates(List<Homework> list) {
  List<DateTime> listtoReturn = List<DateTime>();
  list.forEach((element) {
    if (!listtoReturn.contains(element.date)) {
      listtoReturn.add(element.date);
    }
  });
  listtoReturn.sort();
  return listtoReturn;
}

//Function that returns string like "In two weeks" with time relation
getWeeksRelation(int index, List<Homework> list) {
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
        if (getWeeksRelation(index - 1, list) != "La semaine prochaine") return "La semaine prochaine";
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
        if (getWeeksRelation(index - 1, list) != "Dans 2 semaines") return "Dans 2 semaines";
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
        if (getWeeksRelation(index - 1, list) != "Dans 3 semaines") return "Dans 3 semaines";
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
        if (getWeeksRelation(index - 1, list) != "Dans 4 semaines") return "Dans 4 semaines";
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
        if (getWeeksRelation(index - 1, list) != "Dans plus d'un mois") return "Dans plus d'un mois";
      } else {
        return "Dans plus d'un mois";
      }
    }
  } catch (error) {
    print(error);
  }
}

class DialogHomework extends StatefulWidget {
  final Homework hw;

  const DialogHomework(this.hw);
  State<StatefulWidget> createState() {
    return _DialogHomeworkState();
  }
}

class _DialogHomeworkState extends State<DialogHomework> {
  initState() {
    super.initState();
  }

  HighlightMap highlightMap;
  int segmentedControlIndex = 0;
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(backgroundColor: Colors.yellow.shade100);

    var document = parse(segmentedControlIndex == 0 ? widget.hw.contenu : widget.hw.contenuDeSeance);

    String parsedHtml = parse(document.body.text).documentElement.text;
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return Container(
      height: screenSize.size.height / 10 * 6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: CircleBorder(),
                onPressed: () {
                  Share.share(parsedHtml);
                },
                child: Container(
                    padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                    child: Icon(
                      MdiIcons.share,
                      color: ThemeUtils.textColor(),
                      size: screenSize.size.width / 5 * 0.5,
                    )),
              ),
            ],
          ),
          if (widget.hw.contenuDeSeance != null && widget.hw.contenuDeSeance != "")
            Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                width: screenSize.size.width / 5 * 4.5,
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
                        style: TextStyle(fontFamily: "Asap"),
                      ),
                      1: Text(
                        'Contenu',
                        style: TextStyle(fontFamily: "Asap"),
                        textAlign: TextAlign.center,
                      ),
                    }),
              ),
            ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenSize.size.height / 10 * 3.5),
            child: Container(
              margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
              width: screenSize.size.width / 5 * 4.5,
              padding: EdgeInsets.all(screenSize.size.height / 10 * 0.2),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15)),
              child: Material(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: AutoSizeText(
                    parsedHtml,
                    style: TextStyle(fontSize: 20, fontFamily: "Asap", color: ThemeUtils.textColor()),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
          ),
          /* Material(
            type: MaterialType.transparency,
            child: Container(
              margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
              width: screenSize.size.width / 5 * 4.5,
              padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.2),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    child: Container(width: screenSize.size.width / 5 * 1.8, child: Image(fit: BoxFit.fill, image: AssetImage('assets/images/schoolmouv.png'))),
                  ),
                  FutureBuilder(
                      future: gettingRelatedLessons(parsedHtml),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data.length > 0) {
                          return Container(
                              height: screenSize.size.height / 10 * 2.1,
                              width: screenSize.size.width / 5 * 4.2,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeBottom: true,
                                removeTop: false,
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
                                        child: Material(
                                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.5),
                                            color: Theme.of(context).primaryColorDark,
                                            child: InkWell(
                                                borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.5),
                                                onTap: () {
                                                  launchURL(snapshot.data[index]["url"]);
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.5)),
                                                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                                      Container(
                                                        width: screenSize.size.width / 5 * 4,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
                                                              width: screenSize.size.width,
                                                              child: Text(
                                                                snapshot.data[index]["discipline"],
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(fontFamily: "Asap", color: Colors.grey.shade600, fontSize: screenSize.size.height / 10 * 0.25),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
                                                              width: screenSize.size.width,
                                                              child: Text(
                                                                snapshot.data[index]["chapter"],
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.grey.shade400 : Colors.grey.shade500, fontSize: screenSize.size.height / 10 * 0.25),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ])))),
                                      ),
                                    );
                                  },
                                ),
                              ));
                        }
                        if (snapshot.hasData && snapshot.data.length == 0) {
                          return Container(
                              child: FittedBox(
                                  child: Text(
                            "Aucun cours trouvé",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.grey.shade200 : Colors.black54, fontSize: screenSize.size.height / 10 * 0.25),
                          )));
                        } else {
                          return SpinKitFadingFour(
                            color: Theme.of(context).primaryColorDark,
                            size: screenSize.size.width / 5 * 1,
                          );
                        }
                      }),
                ],
              ),
            ),
          ),*/
          FutureBuilder(
              future: getColor(this.widget.hw.codeMatiere),
              initialData: 0,
              builder: (context, snapshot) {
                Color color = Color(snapshot.data);
                return Material(
                  type: MaterialType.transparency,
                  child: Container(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                      width: screenSize.size.width / 5 * 4.5,
                      padding: EdgeInsets.all(screenSize.size.height / 10 * 0.2),
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15)),
                      child: Column(
                        children: [
                          Text(
                            this.widget.hw.matiere,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.grey.shade200 : Colors.black54, fontSize: screenSize.size.height / 10 * 0.25),
                          ),
                          FutureBuilder(
                              future: offline.getHWCompletion(widget.hw.id ?? ''),
                              initialData: false,
                              builder: (context, snapshot) {
                                bool done = snapshot.data;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularCheckBox(
                                      activeColor: Colors.blue,
                                      inactiveColor: Colors.green,
                                      value: done,
                                      materialTapTargetSize: MaterialTapTargetSize.padded,
                                      onChanged: (bool x) async {
                                        setState(() {
                                          done = !done;
                                          donePercentFuture = getHomeworkDonePercent();
                                        });

                                        offline.setHWCompletion(widget.hw.id, x);
                                      },
                                    ),
                                    Text(
                                      "J'ai fait ce devoir",
                                      style: TextStyle(
                                        fontFamily: "Asap",
                                        color: ThemeUtils.textColor(),
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ],
                      )),
                );
              }),
        ],
      ),
    );
  }
}

Future<void> showHomeworkDetails(BuildContext context, Homework hw) async {
  String returnVal = await showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {},
      transitionBuilder: (context, a1, a2, widget) {
        MediaQueryData screenSize;
        screenSize = MediaQuery.of(context);
        return Transform.scale(scale: a1.value, child: Container(child: DialogHomework(hw)));
      });
}
