import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/dialogs.dart';
import 'package:ynotes/UI/homeworkPage.dart';
import 'package:ynotes/offline.dart';
import 'package:ynotes/usefulMethods.dart';

import '../../apiManager.dart';

class HomeworkFirstPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeworkFirstPageState();
  }
}

class _HomeworkFirstPageState extends State<HomeworkFirstPage> {
  Future<void> refreshLocalHomeworkList() async {
    setState(() {
      homeworkListFuture = api.getNextHomework(forceReload: true);
    });
    var realHW = await homeworkListFuture;
  }

  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshHomeworkOfflineFuture();
  }

  void reloadDates() async {
    var realHW = await homeworkListFuture;
    setState(() {
      dates = getDates(realHW);
    });
  }

  void refreshHomeworkOfflineFuture() {
    setState(() {
      homeworkListFuture = api.getNextHomework();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return RefreshIndicator(
      onRefresh: refreshLocalHomeworkList,
      child: FutureBuilder(
          future: homeworkListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length != 0) {
                return Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1),
                      child: ListView.builder(
                          itemCount: getDates(snapshot.data).length,
                          padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                if (getWeeksRelation(index, snapshot.data) != null)
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: new Container(
                                          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                          child: Divider(
                                            color: isDarkModeEnabled ? Colors.white : Colors.black,
                                            height: 36,
                                          )),
                                    ),
                                    Text(
                                      getWeeksRelation(index, snapshot.data),
                                      style: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black, fontFamily: "Asap"),
                                    ),
                                    Expanded(
                                      child: new Container(
                                          margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                                          child: Divider(
                                            color: isDarkModeEnabled ? Colors.white : Colors.black,
                                            height: 36,
                                          )),
                                    ),
                                  ]),
                                HomeworkContainer(getDates(snapshot.data)[index], this.callback, snapshot.data),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(fit: BoxFit.fitWidth, image: AssetImage('assets/images/noHomework.png')),
                      Text(
                        "Pas de devoirs à l'horizon... \non se détend ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Asap",
                          color: isDarkModeEnabled ? Colors.white : Colors.black,
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
                              color: isDarkModeEnabled ? Colors.white : Colors.black,
                            )),
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0), side: BorderSide(color: Theme.of(context).primaryColorDark)),
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
  bool isPinned = false;
  @override
  initState() {
    getPinnedStatus();
  }

  getPinnedStatus() async {
    var defaultValue = await getPinnedHomeworkSingleDate(widget.date.toString());
    setState(() {
      isPinned = defaultValue;
    });
    print("called");
  }

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
      mainLabel = toBeginningOfSentenceCase(DateFormat("EEEE d MMMM", "fr_FR").format(dateToUse).toString());
      showSmallLabel = false;
    }
    if (difference < 0) {
      mainLabel = toBeginningOfSentenceCase(DateFormat("EEEE d MMMM", "fr_FR").format(dateToUse).toString());
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
        margin: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
        duration: Duration(milliseconds: 170),
        width: screenSize.size.width / 5 * 5,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
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
                  padding: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: (showSmallLabel ? 0 : screenSize.size.height / 10 * 0.2), bottom: screenSize.size.height / 10 * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    //The main date or date relation
                                    mainLabel,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black, fontFamily: "Asap", fontSize: screenSize.size.height / 10 * 0.4, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                if (isPinned)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      MdiIcons.pin,
                                      color: Colors.black38,
                                      size: screenSize.size.width / 5 * 0.5,
                                    ),
                                  )
                              ],
                            ),
                            //Small date
                            if (showSmallLabel == true)
                              Text(
                                DateFormat("EEEE d MMMM", "fr_FR").format(widget.date),
                                textAlign: TextAlign.left,
                                style: TextStyle(color: isDarkModeEnabled ? Colors.white70 : Colors.grey, fontFamily: "Asap", fontSize: screenSize.size.height / 10 * 0.2),
                              )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                          duration: Duration(milliseconds: 170),
                          decoration: BoxDecoration(
                            color: isDarkModeEnabled ? Color(0xff656565) : Colors.white,
                          ),
                          padding: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1, bottom: screenSize.size.height / 10 * 0.1),
                          height: screenSize.size.width / 10 * containerSize / 1.2,
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.done_all,
                                            color: Colors.greenAccent,
                                            size: screenSize.size.width / 5 * 0.5,
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.alarm,
                                            color: Colors.white,
                                            size: screenSize.size.width / 5 * 0.5,
                                          ),
                                        ],
                                      )),
                                ),

                                //Pin button
                                RaisedButton(
                                  color: Color(0xff3b3b3b),
                                  onPressed: () async {
                                    setState(() {
                                      isPinned = !isPinned;
                                      setPinnedHomeworkDate(widget.date.toString(), isPinned);
                                      //If date pinned is before actual date (can be deleted)
                                    });
                                    if (isPinned != true && widget.date.isBefore(DateTime.now())) {
                                      CustomDialogs.showAnyDialog(context, "Cette date sera supprimée au prochain rafraichissement.");
                                    }
                                    widget.callback();
                                  },
                                  shape: CircleBorder(),
                                  child: Container(
                                      width: screenSize.size.width / 5 * 0.7,
                                      height: screenSize.size.width / 5 * 0.7,
                                      padding: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.05),
                                      child: Icon(
                                        MdiIcons.pin,
                                        color: (isPinned) ? Colors.green : Colors.white,
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
            AnimatedContainer(
              duration: Duration(milliseconds: 170),
              margin: EdgeInsets.only(top: containerSize == 0 ? screenSize.size.height / 10 * 0.6 : screenSize.size.height / 10 * 1.5),
              padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1, horizontal: screenSize.size.width / 5 * 0.1),
              child: Container(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    itemCount: getHomeworkInList(widget.listHW).length,
                    itemBuilder: (context, index) {
                      return HomeworkElement(getHomeworkInList(widget.listHW)[index], true);
                    }),
              ),
            ),
          ],
        ),
      );
    }
  }
}
