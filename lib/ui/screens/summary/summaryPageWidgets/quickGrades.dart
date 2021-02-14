import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/core/apis/Pronote.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/chart.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

class QuickGrades extends StatefulWidget {
  final Function switchPage;
  final GradesController gradesController;
  const QuickGrades({Key key, this.gradesController, this.switchPage}) : super(key: key);
  @override
  _QuickGradesState createState() => _QuickGradesState();
}

class _QuickGradesState extends State<QuickGrades> {
  Future<void> forceRefreshModel() async {
    await this.widget.gradesController.refresh(force: true);
  }

  Widget buildGauge(List<Discipline> disciplines, BuildContext context) {
    var screenSize = MediaQuery.of(context);
    //First division (gauge)
    Container(
        decoration: BoxDecoration(
            color: Color(0xff2c274c),
            border: Border.all(width: 0, color: Colors.transparent),
            borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
        child: Card(
            shadowColor: Colors.transparent,
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
                      child: disciplines != null
                          ? SummaryChart(
                              getAllGrades(disciplines, overrideLimit: true),
                            )
                          : SpinKitThreeBounce(
                              color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4))
                ],
              ),
            )));
  }

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

  buildGradesList(BuildContext context, List<Grade> grades) {
    var screenSize = MediaQuery.of(context);
    if (grades == null || grades.length == 0) {
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
      return ListView.builder(
          itemCount: grades.length,
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
                    CustomDialogs.showShareGradeDialog(context, grades[index]);
                  },
                  onTap: () {
                    widget.switchPage(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.1),
                    height: screenSize.size.height / 10 * 0.5,
                    child: buildGradeItem(grades[index]),
                  ),
                ),
              ),
            );
          });
    }
    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          buildGauge(),
          buildGradesList(context, grades)
        ],
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
