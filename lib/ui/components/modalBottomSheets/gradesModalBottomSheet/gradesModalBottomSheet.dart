import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/stats/gradesStats.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

void gradesModalBottomSheet(
  context,
  Grade grade,
  GradesStats stats,
  Discipline? discipline,
  Function callback,
  var widget,
  GradesController? gradesController,
) {
  MediaQueryData screenSize = MediaQuery.of(context);

  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return GradesModalBottomSheetContainer(
          grade: grade,
          stats: stats,
          discipline: discipline,
          callback: callback,
          gradesController: gradesController,
        );
      });
}

class GradesModalBottomSheetContainer extends StatefulWidget {
  final Grade? grade;

  final GradesStats? stats;
  final Discipline? discipline;
  final Function? callback;
  final GradesController? gradesController;
  const GradesModalBottomSheetContainer(
      {Key? key, this.grade, this.stats, this.discipline, this.callback, this.gradesController})
      : super(key: key);
  @override
  _GradesModalBottomSheetContainerState createState() => _GradesModalBottomSheetContainerState();
}

class _GradesModalBottomSheetContainerState extends State<GradesModalBottomSheetContainer> {
  var oldSize;
  bool open = false;
  GlobalKey headerPart = new GlobalKey(debugLabel: 'headerPart');
  @override
  Widget build(BuildContext context) {
    Color? colorGroup;
    if (widget.discipline == null) {
      colorGroup = Theme.of(context).primaryColor;
    } else {
      if (widget.discipline!.color != null) {
        colorGroup = Color(widget.discipline!.color!);
      }
    }
    SchedulerBinding.instance?.addPostFrameCallback(postFrameCallback);

    MediaQueryData screenSize = MediaQuery.of(context);
    return SlidingUpPanel(
      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
      minHeight: oldSize ?? 0.0,
      maxHeight: screenSize.size.height,
      panel: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildHeaderPart(),
        ],
      ),
      body: Center(
        child: Text("This is the Widget behind the sliding panel"),
      ),
    );
  }

  Widget buildDragChevron() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Column(
      children: [
        Text(
          "Voir plus",
          style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold),
        ),
        Container(
          width: screenSize.size.width / 5 * 0.3,
          height: screenSize.size.width / 5 * 0.3,
          child: Icon(MdiIcons.chevronDoubleUp),
        ),
      ],
    );
  }

  Widget buildDraggingHandle() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.2),
      height: 5,
      width: screenSize.size.width / 5 * 2.5,
      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget buildGradeAveragesAndDetails() {
    return Row(
      children: [
        Expanded(flex: 5, child: SizedBox()),
        buildSquareKeyValue("COEFF", widget.grade?.weight ?? ""),
        Expanded(child: SizedBox()),
        buildSquareKeyValue("MAX", widget.grade?.max ?? ""),
        Expanded(child: SizedBox()),
        buildSquareKeyValue("MIN", widget.grade?.min ?? ""),
        Expanded(child: SizedBox()),
        buildSquareKeyValue("CLASSE", widget.grade?.classAverage ?? ""),
        Expanded(flex: 5, child: SizedBox()),
      ],
    );
  }

  Widget buildGradeHeader() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      width: screenSize.size.width,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildGradeSquare(),
        SizedBox(
          width: screenSize.size.width / 5 * 0.14,
        ),
        Expanded(child: buildGradesMetas()),
      ]),
    );
  }

  Widget buildGradesMetas() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(
          horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.1),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenSize.size.width / 5 * 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Questionnaire de lecture",
              style: TextStyle(
                  fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: screenSize.size.height / 10 * 0.24),
            ),
            Text(
              "ENSEIGNMENT HESP ECRIRE",
              style: TextStyle(
                  fontFamily: "Asap", fontWeight: FontWeight.w400, fontSize: screenSize.size.height / 10 * 0.18),
            ),
            Container(
                margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                child: Text(
                  "Interros écrites - 03 mai 2021",
                  style: TextStyle(
                      fontFamily: "Asap", fontWeight: FontWeight.normal, fontSize: screenSize.size.height / 10 * 0.18),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildGradeSquare() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15)),
      width: screenSize.size.width / 5 * 1,
      height: screenSize.size.width / 5 * 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FittedBox(
              child: AutoSizeText(
                (widget.grade?.value) ?? "N/A",
                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: ThemeUtils.textColor(), borderRadius: BorderRadius.circular(55)),
            height: screenSize.size.height / 10 * 0.02,
            width: screenSize.size.width / 5 * 0.6,
          ),
          Expanded(
            child: FittedBox(
              child: AutoSizeText(
                (widget.grade?.scale) ?? "N/A",
                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderPart() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      key: headerPart,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildDraggingHandle(),
          buildGradeHeader(),
          SizedBox(height: screenSize.size.height / 10 * 0.25),
          buildGradeAveragesAndDetails(),
          SizedBox(height: screenSize.size.height / 10 * 0.15),
          buildDragChevron()
        ],
      ),
    );
  }

  Widget buildSquareKeyValue(String key, String value) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      width: screenSize.size.width / 5 * 0.9,
      height: screenSize.size.width / 5 * 0.9,
      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            key,
            style: TextStyle(color: ThemeUtils.textColor(), fontSize: 12),
          ),
          Text(
            value,
            style: TextStyle(color: ThemeUtils.textColor(), fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void postFrameCallback(_) {
    var context = headerPart.currentContext;
    if (context == null) return;

    var newSize = context.size?.height;
    if (oldSize == newSize) return;

    setState(() {
      oldSize = newSize;
    });
  }
}
