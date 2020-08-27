import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/screens/homeworkPageWidgets/HWsecondPage.dart';
import 'package:ynotes/UI/animations/FadeAnimation.dart';
import 'package:ynotes/kartable/kartableAdapter.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/main.dart';
import '../../apiManager.dart';
import '../../models.dart';
import '../../offline.dart';
import '../../usefulMethods.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:html/parser.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';
import 'package:file_picker/file_picker.dart';

import 'homeworkPageWidgets/HWfirstPage.dart';
import 'homeworkPageWidgets/HWsettingsPage.dart';

Future<List<Homework>> homeworkListFuture;
PageController _pageControllerHW;

class HomeworkPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeworkPageState();
  }
}

//The date the user want to see
DateTime dateToUse;
bool firstStart = true;

bool isPinnedDateToUse = false;
//Public list of dates to be easily deleted
List dates = List();
//Only use to add homework to database
List<Homework> localListHomeworkDateToUse;

class _HomeworkPageState extends State<HomeworkPage> {
  void initState() {
    super.initState();
    _pageControllerHW = PageController(initialPage: 1);
    //WidgetsFlutterBinding.ensureInitialized();
    //Test if it's the first start

    setState(() {
      homeworkListFuture = localApi.getNextHomework();
    });

    getPinnedStateDayToUse();
  }

  getPinnedStateDayToUse() async {
    print(dateToUse);
    var pinnedStatus = await offline.getPinnedHomeworkSingleDate(dateToUse.toString());
    setState(() {
      isPinnedDateToUse = pinnedStatus;
    });
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

//Build the main widget container of the homeworkpage
  @override
  Widget build(BuildContext context) {
    //Show the pin dialog
    helpDialogs[2].showDialog(context);
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
   
      height: screenSize.size.height / 10 * 8.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Homework list view
          Container(
              width: screenSize.size.width / 5 * 4.7,
              height: screenSize.size.height / 10 * 7.1,
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
                        //First page with settings
                        HomeworkSettingPage(animateToPage),

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
                    borderRadius: BorderRadius.circular(11),
                    child: InkWell(
                       borderRadius: BorderRadius.circular(11),
                      onTap: () {
                        _pageControllerHW.animateTo(0, duration: Duration(milliseconds: 250), curve: Curves.ease);
                      },
                      child: Container(
                          height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                          padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.settings,
                                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                                ),
                                Text(
                                  "Paramètres",
                                  style: TextStyle(
                                    fontFamily: "Asap",
                                    color: isDarkModeEnabled ? Colors.white : Colors.black,
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
                       borderRadius: BorderRadius.circular(11),
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
                                color: isDarkModeEnabled ? Colors.white : Colors.black,
                              ),
                              Text(
                                "Choisir une date",
                                style: TextStyle(
                                  fontFamily: "Asap",
                                  color: isDarkModeEnabled ? Colors.white : Colors.black,
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

//Represents the element containing details about homework
class HomeworkElement extends StatefulWidget {
  final Homework homeworkForThisDay;
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

  bool isExpanded = false;

  ///Expand document part or not
  bool isDocumentExpanded = false;

  //The index of the segmented control (travail à faire / contenu de cours)
  int segmentedControlIndex = 0;

  @override
  void initState() {
    super.initState();
    //Define the default expanding state
    getDefaultValue();
  }

  void getDefaultValue() async {
    var defaultValue = await getSetting("isExpandedByDefault");

    setState(() {
      isExpanded = defaultValue;
    });
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
          initialData: 0,
          builder: (context, snapshot) {
            Color color = Color(snapshot.data);

            return Stack(
              children: <Widget>[
                //Label
                Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    color: color,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      child: GestureDetector(
                        excludeFromSemantics: true,
                        onLongPress: () {
                          showHomeworkDetails(context, segmentedControlIndex == 0 ? this.widget.homeworkForThisDay.contenu : this.widget.homeworkForThisDay.contenuDeSeance);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0, color: Colors.transparent),
                          ),
                          width: screenSize.size.width / 5 * 4.5,
                          height: isExpanded ? (screenSize.size.height / 10 * 8.8) / 10 * 0.6 : (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                          child: Stack(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2, top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1),
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    this.widget.homeworkForThisDay.matiere,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.normal),
                                  ),
                                  if (widget.homeworkForThisDay.interrogation == true)
                                    Container(
                                      margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.15),
                                      width: screenSize.size.width / 5 * 0.15,
                                      height: screenSize.size.width / 5 * 0.15,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                                    )
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 0.5),
                      width: screenSize.size.width / 5 * 4.4,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, color: Colors.transparent),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                        child: Column(
                          children: <Widget>[
                            if (this.widget.homeworkForThisDay.interrogation == true && isExpanded)
                              Container(
                                width: screenSize.size.width / 5 * 4.4,
                                height: screenSize.size.width / 10 * 0.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
                                    color: Colors.orangeAccent,
                                    border: Border.all(
                                      width: 0,
                                      color: Colors.transparent,
                                    )),
                                child: Text(
                                  "Interrogation",
                                  style: TextStyle(fontFamily: "Asap", color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            Container(
                              color: isDarkModeEnabled ? darken(Theme.of(context).primaryColorDark, forceAmount: 0.1) : darken(Theme.of(context).primaryColor, forceAmount: 0.03),
                              width: screenSize.size.width / 5 * 4.4,
                              height: isExpanded ? null : 0,
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(width: 0, color: Colors.transparent)),
                                padding: isExpanded ? EdgeInsets.only(left: screenSize.size.height / 10 * 0.1, top: screenSize.size.height / 10 * 0.1, right: screenSize.size.height / 10 * 0.1) : null,
                                child: Column(
                                  children: <Widget>[
                                    if (widget.homeworkForThisDay.documentsContenuDeSeance != null && widget.homeworkForThisDay.documentsContenuDeSeance.length != 0)
                                      Container(
                                        height: screenSize.size.height / 10 * 0.6,
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
                                                style: TextStyle(fontFamily: "Asap"),
                                              ),
                                              1: Text(
                                                'Contenu',
                                                style: TextStyle(fontFamily: "Asap"),
                                                textAlign: TextAlign.center,
                                              ),
                                            }),
                                      ),
                                    if (this.widget.homeworkForThisDay.nomProf.length > 0)
                                      Container(
                                          child: Text(
                                        this.widget.homeworkForThisDay.nomProf,
                                        style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                                      )),
                                    HtmlWidget(segmentedControlIndex == 0 ? this.widget.homeworkForThisDay.contenu : this.widget.homeworkForThisDay.contenuDeSeance,
                                        bodyPadding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1), textStyle: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black, fontFamily: "Asap"), onTapUrl: (url) async {
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
                            if (this.widget.homeworkForThisDay.documents != null && (segmentedControlIndex == 0 ? this.widget.homeworkForThisDay.documents.length : this.widget.homeworkForThisDay.documentsContenuDeSeance.length) != 0 && isExpanded)
                              Container(
                                width: screenSize.size.width / 5 * 4.4,
                                child: Column(
                                  children: <Widget>[
                                    Material(
                                      color: Color(0xff2874A6),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isDocumentExpanded = !isDocumentExpanded;
                                          });
                                        },
                                        child: Container(
                                          height: screenSize.size.height / 10 * 0.5,
                                          width: screenSize.size.width / 5 * 4.4,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Documents",
                                                style: TextStyle(fontFamily: "Asap", color: Colors.white),
                                              ),
                                              Icon(MdiIcons.fileOutline, color: Colors.white),
                                              if (isDocumentExpanded)
                                                SizedBox(
                                                  width: screenSize.size.width / 5 * 1.88,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 75),
                                      width: screenSize.size.width / 5 * 4.4,
                                      height: isDocumentExpanded ? (segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents.length : widget.homeworkForThisDay.documentsContenuDeSeance.length) * (screenSize.size.height / 10 * 0.7) : 0,
                                      child: ListView.builder(
                                          itemCount: segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents.length : widget.homeworkForThisDay.documentsContenuDeSeance.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Material(
                                              color: Color(0xff5FA9DA),
                                              child: InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.2, color: Colors.white))),
                                                  width: screenSize.size.width / 5 * 4.4,
                                                  height: screenSize.size.height / 10 * 0.7,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                                          width: screenSize.size.width / 5 * 3.8,
                                                          child: ClipRRect(
                                                            child: Marquee(
                                                                text: (segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].libelle,
                                                                blankSpace: screenSize.size.width / 5 * 0.2,
                                                                style: TextStyle(fontFamily: "Asap", color: Colors.white)),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: screenSize.size.width / 5 * 0.1,
                                                        top: screenSize.size.height / 10 * 0.11,
                                                        child: Container(
                                                          height: screenSize.size.height / 10 * 0.5,
                                                          decoration: BoxDecoration(color: darken(Color(0xff5FA9DA)), borderRadius: BorderRadius.circular(50)),
                                                          child: ViewModelBuilder<DownloadModel>.reactive(
                                                              viewModelBuilder: () => DownloadModel(),
                                                              builder: (context, model, child) {
                                                                return FutureBuilder(
                                                                    future: model.fileExists((segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].libelle),
                                                                    initialData: false,
                                                                    builder: (context, snapshot) {
                                                                      if (snapshot.data == false) {
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
                                                                              padding: EdgeInsets.symmetric(vertical: 0),
                                                                              icon: Row(
                                                                                children: <Widget>[
                                                                                  Icon(
                                                                                    MdiIcons.check,
                                                                                    color: Colors.green,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              onPressed: () async {
                                                                                FileAppUtil.openFile((segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].libelle);
                                                                              },
                                                                            ));
                                                                          }
                                                                        }

                                                                        ///Isn't downloading
                                                                        if (!model.isDownloading) {
                                                                          return IconButton(
                                                                            padding: EdgeInsets.symmetric(vertical: 0),
                                                                            icon: Icon(
                                                                              MdiIcons.fileDownloadOutline,
                                                                              color: Colors.white,
                                                                            ),
                                                                            onPressed: () async {
                                                                              await model.download(
                                                                                  (segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].id.toString(),
                                                                                  (segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].type,
                                                                                  (segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].libelle);
                                                                            },
                                                                          );
                                                                        }
                                                                      }

                                                                      ///If file already exists
                                                                      else {
                                                                        return Container(
                                                                            height: screenSize.size.height / 10 * 8,
                                                                            child: IconButton(
                                                                              padding: EdgeInsets.symmetric(vertical: 0),
                                                                              icon: Icon(
                                                                                MdiIcons.check,
                                                                                color: Colors.green,
                                                                              ),
                                                                              onPressed: () async {
                                                                                FileAppUtil.openFile((segmentedControlIndex == 0 ? widget.homeworkForThisDay.documents : widget.homeworkForThisDay.documentsContenuDeSeance)[index].libelle);
                                                                              },
                                                                            ));
                                                                      }
                                                                    });
                                                              }),
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
                            if (this.widget.homeworkForThisDay.rendreEnLigne == true && isExpanded)
                              Material(
                                color: Color(0xff63A86A),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                child: InkWell(
                                  onTap: () async {
                                    CustomDialogs.showUnimplementedSnackBar(context);
                                    /*
                                        File file = await FilePicker.getFile();
                                        await api.uploadFile("CDT", this.widget.homeworkForThisDay.idDevoir, file.path);*/
                                  },
                                  child: Container(
                                    width: screenSize.size.width / 5 * 4.4,
                                    height: screenSize.size.height / 10 * 0.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Rendre en ligne",
                                          style: TextStyle(fontFamily: "Asap", color: Colors.white),
                                        ),
                                        Icon(Icons.file_upload, color: Colors.white)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (!isExpanded)
                              Material(
                                color: color,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isExpanded = !isExpanded;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.00000, color: Colors.transparent),
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

class DialogHomework extends StatefulWidget {
  final String html;

  const DialogHomework(this.html);
  State<StatefulWidget> createState() {
    return _DialogHomeworkState();
  }
}

class _DialogHomeworkState extends State<DialogHomework> {
  initState() {
    super.initState();
  }

  HighlightMap highlightMap;

  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(backgroundColor: Colors.yellow.shade100);

    var document = parse(widget.html);

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
                      color: isDarkModeEnabled ? Colors.white : Colors.black,
                      size: screenSize.size.width / 5 * 0.5,
                    )),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenSize.size.height / 10 * 3.5),
            child: Container(
              margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
              width: screenSize.size.width / 5 * 4.5,
              padding: EdgeInsets.all(screenSize.size.height / 10 * 0.2),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(11)),
              child: SingleChildScrollView(
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    parsedHtml, // You need to pass the string you want the highlights

                    style: TextStyle(
                        // You can set the general style, like a Text()
                        fontFamily: "Asap",
                        fontSize: 20.0,
                        color: isDarkModeEnabled ? Colors.white : Colors.black),
                    textAlign: TextAlign.justify,
                    // You can use any attribute of the RichText widget
                  ),
                ),
              ),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: Container(
              margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
              width: screenSize.size.width / 5 * 4.5,
              padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.2),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(11)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: FittedBox(
                          child: Text(
                    "kartable",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontFamily: "ProximaNova", color: Color(0xff26c0ff), fontSize: screenSize.size.height / 10 * 0.32),
                  ))),
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
                                      borderRadius: BorderRadius.circular(11),
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
                                        child: Material(
                                            borderRadius: BorderRadius.circular(11),
                                            color: Theme.of(context).primaryColorDark,
                                            child: InkWell(
                                                borderRadius: BorderRadius.circular(11),
                                                onTap: () {
                                                  launchURL(snapshot.data[index]["url"]);
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
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
                                                                style: TextStyle(fontFamily: "ProximaNova", color: Colors.grey.shade600, fontSize: screenSize.size.height / 10 * 0.25),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
                                                              width: screenSize.size.width,
                                                              child: Text(
                                                                snapshot.data[index]["chapter"],
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(fontFamily: "ProximaNova", color: isDarkModeEnabled ? Colors.grey.shade400 : Colors.grey.shade500, fontSize: screenSize.size.height / 10 * 0.25),
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
                            style: TextStyle(fontFamily: "ProximaNova", color: isDarkModeEnabled ? Colors.grey.shade200 : Colors.black54, fontSize: screenSize.size.height / 10 * 0.25),
                          )));
                        } else {
                          return SpinKitFadingFour(
                            color: Theme.of(context).primaryColorDark,
                            size: screenSize.size.width / 5 * 1,
                          );
                        }
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

showHomeworkDetails(BuildContext context, String html) {
  return showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {},
      transitionBuilder: (context, a1, a2, widget) {
        MediaQueryData screenSize;
        screenSize = MediaQuery.of(context);
        return Transform.scale(scale: a1.value, child: Container(child: DialogHomework(html)));
      });
}
