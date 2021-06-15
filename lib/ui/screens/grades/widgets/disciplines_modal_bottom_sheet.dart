import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/drag_handle.dart';

///Bottom windows with some infos on the discipline and the possibility to change the discipline color
void disciplineModalBottomSheet(context, Discipline? discipline, Function? callback, var widget) {
  Color? colorGroup;

  if (widget.discipline == null) {
    colorGroup = Colors.blueAccent;
  } else {
    if (widget.discipline.color != null) {
      colorGroup = Color(widget.discipline.color);
    }
  }
  showModalBottomSheet(
      shape: RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return DisciplineModalBottomSheet(discipline, callback, colorGroup);
      });
}

class DisciplineModalBottomSheet extends StatefulWidget {
  final Discipline? discipline;
  final Function? callback;
  final Color? colorGroup;

  const DisciplineModalBottomSheet(this.discipline, this.callback, this.colorGroup);

  @override
  _DisciplineModalBottomSheetState createState() => _DisciplineModalBottomSheetState();
}

class _DisciplineModalBottomSheetState extends State<DisciplineModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                color: Theme.of(context).primaryColor),
            padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: screenSize.size.height / 10 * 0.1,
                ),
                DragHandle(),
                SizedBox(
                  height: screenSize.size.height / 10 * 0.1,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildGradeSquare(),
                      SizedBox(
                        width: screenSize.size.width / 5 * 0.14,
                      ),
                      Expanded(
                        child: buildDisciplineMetas(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize.size.height / 10 * 0.25,
                ),
                buildDisciplineAverageAndDetails(),
                SizedBox(
                  height: screenSize.size.height / 10 * 0.4,
                ),
                buildButtons(),
                SizedBox(
                  height: screenSize.size.height / 10 * 0.1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButtons.materialButton(context, 130, 45, () async {
          Navigator.pop(context);
          Color? color = await CustomDialogs.showColorPicker(context, Color(widget.discipline?.color ?? 0));

          if (color != null) {
            String test = color.toString();
            String finalColor = "#" + test.toString().substring(10, test.length - 1);
            final prefs = await (SharedPreferences.getInstance());
            await prefs.setString(widget.discipline?.disciplineCode ?? "", finalColor);
            widget.discipline?.setcolor = color;
            //Call set state
            if (widget.callback != null) {
              widget.callback!();
            }
          }
        }, label: "Couleur", icon: MdiIcons.palette, padding: EdgeInsets.all(10)),
      ],
    );
  }

  Widget buildDisciplineAverageAndDetails() {
    return Row(
      children: [
        Expanded(flex: 5, child: SizedBox()),
        buildSquareKeyValue("MAX", widget.discipline?.maxClassAverage ?? "N/A"),
        Expanded(child: SizedBox()),
        buildSquareKeyValue("MIN", widget.discipline?.minClassAverage ?? "N/A"),
        Expanded(child: SizedBox()),
        buildSquareKeyValue("CLASSE", widget.discipline?.classAverage ?? "N/A"),
        Expanded(flex: 5, child: SizedBox()),
      ],
    );
  }

  Widget buildDisciplineMetas() {
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder<int>(
        future: getColor(widget.discipline?.disciplineCode ?? ""),
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
                    widget.discipline?.disciplineName ?? "",
                    style: TextStyle(
                        fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: screenSize.size.height / 10 * 0.24),
                  ),
                  Text(
                    widget.discipline?.teachers?.join("-").trim() ?? "",
                    style: TextStyle(
                        fontFamily: "Asap", fontWeight: FontWeight.w400, fontSize: screenSize.size.height / 10 * 0.18),
                  ),
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FittedBox(
                child: AutoSizeText(
                  ((widget.discipline?.average) ?? "N/A") != "" ? ((widget.discipline?.average) ?? "N/A") : "N/A",
                  style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
                ),
              ),
            ),
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
}
