import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/screens/homeworkPage.dart';
import 'package:ynotes/UI/animations/FadeAnimation.dart';
import 'package:ynotes/offline.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/main.dart';
class HomeworkSecondPage extends StatefulWidget {
  final Function animateToPage;

  const HomeworkSecondPage(this.animateToPage);
  State<StatefulWidget> createState() {
    return _HomeworkSecondPageState();
  }
}

class _HomeworkSecondPageState extends State<HomeworkSecondPage> {
  Future<void> refreshLocalHomeworkList() async {
    setState(() {
      homeworkListFuture = localApi.getNextHomework(forceReload: true);
    });
    var realHW = await homeworkListFuture;
  }

  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return FutureBuilder(
        future: localApi.getHomeworkFor(dateToUse),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            localListHomeworkDateToUse = snapshot.data;
          }
          //PIN DayToUse
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: screenSize.size.height / 10 * 0.2),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            color: Color(0xff3b3b3b),
                            shape: CircleBorder(),
                            onPressed: !snapshot.hasData
                                ? null
                                : () {
                                    setState(() {
                                      isPinnedDateToUse = !isPinnedDateToUse;
                                      setPinnedHomeworkDate(
                                          dateToUse.toString(),
                                          isPinnedDateToUse);
                                    });
                                    if (isPinnedDateToUse) {
                                      putHomework(localListHomeworkDateToUse,
                                          add: true);
                                    }
                                  },
                            child: Container(
                                padding: EdgeInsets.all(
                                    screenSize.size.width / 5 * 0.1),
                                child: Icon(
                                  MdiIcons.pin,
                                  color: isPinnedDateToUse
                                      ? Colors.green
                                      : Colors.white,
                                  size: screenSize.size.width / 5 * 0.4,
                                )),
                          )),
                      Positioned(
                        top: screenSize.size.height / 10 * 0.1,
                        left: screenSize.size.width / 5 * 0.5,
                        child: Container(
                          width: screenSize.size.width / 5 * 2.5,
                          padding: EdgeInsets.only(
                              top: screenSize.size.width / 5 * 0.1,
                              bottom: screenSize.size.width / 5 * 0.1,
                              left: screenSize.size.width / 5 * 0.5),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(11),
                                  topRight: Radius.circular(11))),
                          child: Text(
                              (dateToUse != null
                                  ? toBeginningOfSentenceCase(
                                      DateFormat("EEEE d MMMM", "fr_FR")
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
                            setState(() {
                              localListHomeworkDateToUse = null;
                            });

                            widget.animateToPage(1);
                          },
                          child: Container(
                              padding: EdgeInsets.all(
                                  screenSize.size.width / 5 * 0.1),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: screenSize.size.width / 5 * 0.4,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: screenSize.size.height / 10 * 5.0,
                    width: screenSize.size.width / 5 * 4.4,
                    child: snapshot.hasData
                        ? Container(
                            child: ListView.builder(
                                addRepaintBoundaries: false,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return FadeAnimationLeftToRight(
                                    0.05 + index / 5,
                                    HomeworkElement(snapshot.data[index], true),
                                  );
                                }),
                          )
                        : Center(
                            child: SpinKitFadingFour(
                            color: Theme.of(context).primaryColorDark,
                            size: screenSize.size.width / 5 * 1,
                          ))),
              ],
            ),
          );
        });
  }
}
