
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/screens/homework/homeworkPageWidgets/HWelement.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/utils/themeUtils.dart';

///Homework container to access the homeworks on the right page

class HomeworkContainer extends StatefulWidget {
  final DateTime date;
  final Function callback;
  final List<Homework> listHW;
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
    var defaultValue = await offline.pinnedHomework
        .getPinnedHomeworkSingleDate(widget.date.toString());
    setState(() {
      isPinned = defaultValue;
    });
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

  getAllHWCompletion(List<Homework> list) async {}
  getHomeworkInList(List<Homework> list) {
    List<Homework> listToReturn = new List<Homework>();
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
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(11),
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
                            Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    //The main date or date relation
                                    mainLabel,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ThemeUtils.textColor(),
                                        fontFamily: "Asap",
                                        fontSize:
                                            screenSize.size.height / 10 * 0.4,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
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
                                //Pin button
                                RaisedButton(
                                  color: Color(0xff3b3b3b),
                                  onPressed: () async {
                                    setState(() {
                                      isPinned = !isPinned;
                                      offline.pinnedHomework.set(
                                          widget.date.toString(), isPinned);
                                      //If date pinned is before actual date (can be deleted)
                                    });
                                    if (isPinned != true &&
                                        widget.date.isBefore(DateTime.now())) {
                                      CustomDialogs.showAnyDialog(context,
                                          "Cette date sera supprimée au prochain rafraichissement.");
                                    }
                                    widget.callback();
                                  },
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
                                        color: (isPinned)
                                            ? Colors.green
                                            : Colors.white,
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
              margin: EdgeInsets.only(
                  top: containerSize == 0
                      ? screenSize.size.height / 10 * 0.8
                      : (screenSize.size.height / 10 * 1.5 +
                          (showSmallLabel
                              ? screenSize.size.height / 10 * 0.2
                              : 0))),
              padding: EdgeInsets.symmetric(
                  vertical: screenSize.size.height / 10 * 0.1,
                  horizontal: screenSize.size.width / 5 * 0.1),
              child: Container(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    itemCount: getHomeworkInList(widget.listHW).length,
                    itemBuilder: (context, index) {
                      return HomeworkElement(
                          getHomeworkInList(widget.listHW)[index], true);
                    }),
              ),
            ),
          ],
        ),
      );
    }
  }
}
