import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/screens/grades/gradesPage.dart';
import 'package:ynotes/apis/Pronote.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/utils/themeUtils.dart';

class QuickGrades extends StatefulWidget {
  final List<Grade> grades;
  final Function callback;
  final Function refreshCallback;
  const QuickGrades({Key key, this.grades, this.callback, this.refreshCallback}) : super(key: key);
  @override
  _QuickGradesState createState() => _QuickGradesState();
}

class _QuickGradesState extends State<QuickGrades> {
  Future<void> refreshLocalGradesList() async {
    await this.widget.refreshCallback();
    _refreshController.refreshCompleted();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  Widget buildGradeCircle(Grade grade) {
    var screenSize = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueGrey,
      ),
      child: FittedBox(
        child: AutoSizeText.rich(
          //MARK
          TextSpan(
            text: (grade.notSignificant ? "(" + grade.value : grade.value),
            style: TextStyle(
                color: (ThemeUtils.textColor()),
                fontFamily: "Asap",
                fontWeight: FontWeight.normal,
                fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.5),
            children: <TextSpan>[
              if (grade.scale != "20")
                //MARK ON
                TextSpan(
                    text: '/' + grade.scale,
                    style: TextStyle(
                        color: (ThemeUtils.textColor()),
                        fontWeight: FontWeight.normal,
                        fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.4)),
              if (grade.notSignificant == true)
                TextSpan(
                    text: ")",
                    style: TextStyle(
                        color: (ThemeUtils.textColor()),
                        fontWeight: FontWeight.normal,
                        fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.5)),
            ],
          ),
        ),
      ),
      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.15),
      width: screenSize.size.width / 5 * 0.9,
      height: screenSize.size.width / 5 * 0.9,
    );
  }

  Widget buildGradeItem(Grade grade) {
    DateFormat df = DateFormat("dd MMMM", "fr_FR");
    var screenSize = MediaQuery.of(context);

    return Row(children: [
      buildGradeCircle(grade),
      SizedBox(width: screenSize.size.width / 5 * 0.1),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: screenSize.size.width / 5 * 0.1,
            children: [
              Text(
                grade.disciplineName ?? "",
                style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
                textAlign: TextAlign.left,
              )
            ],
          ),
          Text(
            grade.testName ?? "",
            style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap", fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          Text(
            grade.date != null ? df.format(grade.entryDate) : "",
            style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
            textAlign: TextAlign.left,
          )
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    if (widget.grades == null || widget.grades.length == 0) {
      return Container(
        height: screenSize.size.height / 10 * 1.2,
        child: Center(
          child: Text(
            "Vos notes apparaîtront ici.",
            style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
          ),
        ),
      );
    } else {
      return Container(
        height: screenSize.size.height / 10 * 1.2,
        child: SmartRefresher(
          onRefresh: refreshLocalGradesList,
          enablePullDown: true,
          controller: _refreshController,
          scrollDirection: Axis.horizontal,
          cacheExtent: screenSize.size.width / 5 * 1.8,
          header: ClassicHeader(
            height: screenSize.size.width / 5 * 1.8,
            textStyle: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
            refreshingText: "Chargement...",
            completeText: "Terminé !",
            failedText: "Une erreur a eu lieu...",
            releaseText: "Lacher pour rafraichir",
            idleText: "Tirer pour rafraichir",
            completeIcon: Icon(Icons.done, color: Colors.green),
          ),
          child: ListView.builder(
              itemCount: widget.grades.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                  color: Theme.of(context).primaryColor,
                  child: Material(
                    borderRadius: BorderRadius.circular(11),
                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(11),
                      onLongPress: () {
                        CustomDialogs.showShareGradeDialog(context, widget.grades[index]);
                      },
                      onTap: () {
                        widget.callback(2);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.1),
                        height: screenSize.size.height / 10 * 0.5,
                        child: buildGradeItem(widget.grades[index]),
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    }
  }
}

class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
