import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/ui/components/customLoader.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/globals.dart';
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

  Widget buildChart(BuildContext context, List<Discipline> disciplines, bool fetching) {
    var screenSize = MediaQuery.of(context);

    //First division (gauge)
    return Container(
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
                      child: (disciplines != null && !fetching)
                          ? SummaryChart(
                              getAllGrades(disciplines, overrideLimit: true, sortByWritingDate: true),
                            )
                          : CustomLoader(
                              screenSize.size.width / 5 * 2.5, screenSize.size.width / 5 * 2.5, Color(0xff4A446D)))
                ],
              ),
            )));
  }

  Widget buildGradeCircle(Grade grade) {
    var screenSize = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColorDark,
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

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: screenSize.size.width / 5 * 2.8),
      child: Row(children: [
        buildGradeCircle(grade),
        SizedBox(width: screenSize.size.width / 5 * 0.1),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (grade.disciplineName != null && grade.disciplineName != "")
                Text(
                  grade.disciplineName ?? "",
                  style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              if (grade.testName != null && grade.testName != "")
                Text(
                  grade.testName ?? "",
                  style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap", fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              if (grade.date != null)
                Text(
                  grade.date != null ? df.format(grade.entryDate) : "",
                  style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                )
            ],
          ),
        )
      ]),
    );
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
      return Container(
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
        height: screenSize.size.height / 10 * 1.4,
        width: screenSize.size.width,
        child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
            itemCount: grades.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2, top: screenSize.size.height / 10 * 0.1),
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
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GradesController>.value(
      value: widget.gradesController,
      child: Consumer<GradesController>(builder: (context, model, child) {
        return Column(children: [
          buildChart(context, model.disciplines(showAll: true), model.isFetching),
          buildGradesList(
              context, getAllGrades(model.disciplines(showAll: true), overrideLimit: true, sortByWritingDate: true)),
        ]);
      }),
    );
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
