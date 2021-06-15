import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/stats/gradesStats.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/drag_handle.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';

void gradesModalBottomSheet(
  context,
  Grade grade,
  GradesStats stats,
  Discipline? discipline,
  Function callback,
  var widget,
  GradesController? gradesController,
) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
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

class _GradesModalBottomSheetContainerState extends State<GradesModalBottomSheetContainer> with LayoutMixin {
  var oldSize;
  var statsPartOldSize;
  bool open = false;
  GlobalKey headerPart = new GlobalKey(debugLabel: 'headerPart');
  GlobalKey statsPart = new GlobalKey(debugLabel: 'statsPart');
  ExpandableController a = ExpandableController();
  PanelController panelController = PanelController();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Color? colorGroup;
    if (widget.discipline == null) {
      colorGroup = Theme.of(context).primaryColor;
    } else {
      if (widget.discipline!.color != null) {
        colorGroup = Color(widget.discipline!.color!);
      }
    }
    SchedulerBinding.instance?.addPostFrameCallback(postFrameCallback);
    SchedulerBinding.instance?.addPostFrameCallback(postFrameCallbackLowerPart);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        SlidingUpPanel(
            backdropEnabled: false,
            backdropOpacity: 0.0,
            body: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
            ),
            controller: panelController,
            color: Colors.transparent,
            boxShadow: [],
            minHeight: oldSize ?? 0.0,
            maxHeight: (oldSize ?? 0.0) + (statsPartOldSize ?? 0),
            panelBuilder: (scroll) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [buildHeaderPart(scroll), buildStatsPart()],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ],
    );
  }

  Widget buildDragChevron() {
    return InkWell(
      onTap: () {
        panelController.isPanelOpen ? panelController.close() : panelController.open();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Voir plus",
            style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold),
          ),
          Container(
            width: 50,
            height: 50,
            child: Icon(
              MdiIcons.chevronDown,
              color: ThemeUtils.textColor(),
            ),
          ),
        ],
      ),
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
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child:
            Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          buildGradeSquare(),
          SizedBox(
            width: screenSize.size.width / 5 * 0.14,
          ),
          Expanded(child: buildGradesMetas()),
        ]),
      ),
    );
  }

  Widget buildGradesMetas() {
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder<int>(
        future: getColor(widget.grade?.disciplineCode ?? ""),
        initialData: 0,
        builder: (context, snapshot) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100, maxHeight: 250),
            child: Container(
              decoration: BoxDecoration(color: Color(snapshot.data ?? 0), borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.grade?.testName ?? "",
                    style: TextStyle(
                        fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: screenSize.size.height / 10 * 0.24),
                  ),
                  Text(
                    widget.grade?.disciplineName ?? "",
                    style: TextStyle(
                        fontFamily: "Asap", fontWeight: FontWeight.w400, fontSize: screenSize.size.height / 10 * 0.18),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                      child: Text(
                        (widget.grade?.testType ?? "") +
                            " - " +
                            ((widget.grade != null && widget.grade?.date != null)
                                ? (DateFormat("dd MMMM yyyy", "fr_FR").format(widget.grade!.date!))
                                : ""),
                        style: TextStyle(
                            fontFamily: "Asap",
                            fontWeight: FontWeight.normal,
                            fontSize: screenSize.size.height / 10 * 0.18),
                      ))
                ],
              ),
            ),
          );
        });
  }

  Widget buildGradeSquare() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 100, maxHeight: 100),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(15)),
        width: screenSize.size.width / 5 * 1,
        height: screenSize.size.width / 5 * 1,
        padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: FittedBox(
                    child: AutoSizeText.rich(
                        //MARK
                        TextSpan(
              text: ((widget.grade?.notSignificant ?? false)
                  ? "(" + (widget.grade?.value ?? "")
                  : (widget.grade?.value ?? "")),
              style: TextStyle(
                  color: (widget.grade?.simulated ?? false) ? Colors.blue : ThemeUtils.textColor(),
                  fontFamily: "Asap",
                  fontWeight: FontWeight.bold,
                  fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.3),
              children: <TextSpan>[
                if (widget.grade?.notSignificant == true)
                  TextSpan(
                      text: ")",
                      style: TextStyle(
                          color: (widget.grade?.simulated ?? false) ? Colors.blue : ThemeUtils.textColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.3)),
              ],
            )))),
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
      ),
    );
  }

  Widget buildHeaderPart(ScrollController con) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 500),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
        key: headerPart,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
            ),
            DragHandle(),
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
            ),
            if (widget.gradesController?.isSimulating ?? false)
              CustomButtons.materialButton(
                context,
                null,
                null,
                () async {
                  Navigator.pop(context);
                  widget.gradesController!.simulationRemove(widget.grade);
                },
                label: "Supprimer virtuellement la note",
                textColor: Colors.blue,
                icon: MdiIcons.trashCan,
                iconColor: Colors.blue,
              ),
            if (widget.gradesController?.isSimulating ?? false) SizedBox(height: screenSize.size.height / 10 * 0.25),
            ConstrainedBox(constraints: BoxConstraints(maxWidth: 500), child: buildGradeHeader()),
            SizedBox(height: screenSize.size.height / 10 * 0.25),
            buildGradeAveragesAndDetails(),
            SizedBox(height: screenSize.size.height / 10 * 0.15),
            if (widget.grade != null)
              CustomButtons.materialButton(context, 130, 45, () {
                CustomDialogs.showShareGradeDialog(context, widget.grade!);
              }, label: "Partager", icon: MdiIcons.shareVariant, padding: EdgeInsets.all(10)),
            SizedBox(height: screenSize.size.height / 10 * 0.15),
            buildDragChevron(),
          ],
        ),
      ),
    );
  }

  Widget buildSquareKeyValue(String key, String value) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 80, maxHeight: 80),
      child: Container(
        width: screenSize.size.width / 5 * 0.9,
        height: screenSize.size.width / 5 * 0.9,
        decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(15)),
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
      ),
    );
  }

  Widget buildStat(double impact, String label, String explanation) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
      child: ExpandableNotifier(
        child: ExpandableTheme(
          data: ExpandableThemeData(
              hasIcon: false, animationDuration: const Duration(milliseconds: 500), useInkWell: true),
          child: ScrollOnExpand(
            child: ExpandablePanel(
              header: Container(
                padding: EdgeInsets.only(
                  top: screenSize.size.height / 10 * 0.1,
                  left: screenSize.size.width / 5 * 0.1,
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11))),
                height: screenSize.size.height / 10 * 0.8,
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 50,
                      padding: EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(color: getAdaptedColor(impact), borderRadius: BorderRadius.circular(20)),
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getText(impact),
                              style: TextStyle(
                                fontFamily: "Asap",
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: screenSize.size.width / 5 * 0.1),
                    Expanded(
                      child: Text(
                        label,
                        style:
                            TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w600, color: ThemeUtils.textColor()),
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              ),
              collapsed: Container(
                padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
                height: screenSize.size.height / 10 * 0.1,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(11), bottomRight: Radius.circular(11))),
              ),
              expanded: Container(
                width: screenSize.size.width / 5 * 4.8,
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.1),
                child: Text(
                  explanation,
                  style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w500, color: ThemeUtils.textColor()),
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(11), bottomRight: Radius.circular(11))),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStatsPart() {
    MediaQueryData screenSize = MediaQuery.of(context);
    SchedulerBinding.instance?.addPostFrameCallback(postFrameCallbackLowerPart);

    return Container(
      width: 500,
      child: Column(
        key: statsPart,
        children: [
          Divider(
            thickness: 2,
          ),
          Text(
            "Statistiques",
            style:
                TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w600, fontSize: 20, color: ThemeUtils.textColor()),
          ),
          SizedBox(
            height: screenSize.size.height / 10 * 0.1,
          ),
          Container(
              width: screenSize.size.width / 5 * 4.8,
              height: screenSize.size.height / 10 * 3.2,
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.1),
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(11)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    buildStat(
                        (widget.stats?.calculateAverageImpact() ?? 0.0),
                        "Points de moyenne pour la matière (à l'obtention).",
                        "Indique le nombre de points d'impact sur la moyenne de la matière au moment de l'obtention de cette note."),
                    buildStat(
                        (widget.stats?.calculateGlobalAverageImpact() ?? 0.0),
                        "Points de moyenne générale (à l'obtention).",
                        "Indique le nombre de points d'impact sur la moyenne générale au moment de l'obtention de cette note."),
                    buildStat(
                        (widget.stats?.calculateGlobalAverageImpactOverall() ?? 0.0),
                        "Points de moyenne générale (tout le temps).",
                        "Indique le nombre de points d'impact sur la moyenne générale avec ou sans la note."),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget buildTest() {
    return Center(
      child: Text("test"),
    );
  }

  getAdaptedColor(double impact) {
    if (impact.isNaN || impact == 0) {
      return Colors.grey;
    }
    if (impact < 0) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  getText(double impact) {
    if (impact.isNaN || impact == 0) {
      return "+0.0";
    } else {
      return (impact < 0 ? "" : "+") + impact.toStringAsFixed(1);
    }
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

  void postFrameCallbackLowerPart(_) {
    var context = statsPart.currentContext;
    if (context == null) return;

    var newSize = context.size?.height;
    if (statsPartOldSize == newSize) return;

    setState(() {
      statsPartOldSize = newSize;
    });
  }
}
