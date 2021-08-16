import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import 'package:ynotes/core/logic/competences/models.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/ui/components/column_builder.dart';
import 'package:ynotes/ui/components/row_builder.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';

class CompetencesGroup extends StatefulWidget {
  final CompetencesDiscipline? discipline;
  const CompetencesGroup({this.discipline});
  State<StatefulWidget> createState() {
    return _CompetencesGroupState();
  }
}

class _CompetencesGroupState extends State<CompetencesGroup> with LayoutMixin {
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    String? capitalizedNomDiscipline;
    String? nomsProfesseurs;
    Color? colorGroup;

    if (widget.discipline == null) {
      colorGroup = Theme.of(context).primaryColorDark;
      nomsProfesseurs = null;
      capitalizedNomDiscipline = null;
    } else {
      String nomDiscipline = widget.discipline!.disciplineName.toLowerCase();
      capitalizedNomDiscipline = "${nomDiscipline[0].toUpperCase()}${nomDiscipline.substring(1)}";
      if (widget.discipline!.color != null) {
        colorGroup = widget.discipline?.color;
      }
      if (widget.discipline!.teachers != null && widget.discipline!.teachers!.length > 0) {
        nomsProfesseurs = widget.discipline!.teachers![0];
        if (nomsProfesseurs != null) {
          widget.discipline!.teachers!.forEach((element) {
            if (widget.discipline!.teachers!.indexOf(element) > 0) {
              nomsProfesseurs = nomsProfesseurs! + " / " + element!;
            }
          });
        }
      }
    }

    double getWidthConstraints() {
      if (isLargeScreen) {
        if (isVeryLargeScreen) {
          return ((screenSize.size.width - 310) / 2.2);
        } else {
          return 480;
        }
      } else {
        return 1500;
      }
    }

    //BLOCK BUILDER
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: getWidthConstraints()),
      child: Column(
        children: <Widget>[
          //Label
          Container(
            child: Material(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isLargeScreen ? 25 : 15),
                  topRight: Radius.circular(isLargeScreen ? 25 : 15)),
              color: colorGroup,
              child: InkWell(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isLargeScreen ? 25 : 15),
                    topRight: Radius.circular(isLargeScreen ? 25 : 15)),
                onTap: () {
                  if (widget.discipline != null) {}
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: (screenSize.size.height / 10 * 0.1), horizontal: screenSize.size.width / 5 * 0.1),
                  decoration: BoxDecoration(border: Border.all(width: 0.0, color: Colors.transparent)),
                  child: Stack(children: <Widget>[
                    if (widget.discipline != null && capitalizedNomDiscipline != null)
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  capitalizedNomDiscipline,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: "Asap",
                                      fontWeight: FontWeight.w400,
                                      fontSize: screenSize.size.height / 10 * 0.2),
                                ),
                              ),
                            ),
                            Icon(MdiIcons.information, color: ThemeUtils.textColor(revert: true).withOpacity(0.8))
                          ],
                        ),
                      ),
                    if (widget.discipline == null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Shimmer.fromColors(
                            baseColor: Color(0xff5D6469),
                            highlightColor: Color(0xff8D9499),
                            child: Container(
                              margin: EdgeInsets.only(left: 0, bottom: 10),
                              width: screenSize.size.width / 5 * 1.5,
                              height: (screenSize.size.height / 10 * 8.8) / 10 * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8), color: Theme.of(context).primaryColorDark),
                            )),
                      ),
                  ]),
                ),
              ),
            ),
          ),

          //Body with columns
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(isLargeScreen ? 25 : 15),
                bottomRight: Radius.circular(isLargeScreen ? 25 : 15),
              ),
            ),
            child: ColumnBuilder(
              crossAxisAlignment: CrossAxisAlignment.start,
              itemCount:
                  (widget.discipline?.subdisciplineCodes != null && widget.discipline!.subdisciplineCodes!.length > 0)
                      ? widget.discipline!.subdisciplineCodes!.length
                      : 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    competencesList(index),
                    SizedBox(
                      height: 0.3.h,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  //MARKS LIST VIEW
  competencesList(int sousMatiereIndex) {
    List<Assessment> assessments = widget.discipline?.assessmentsList ?? [];
    assessments.sort((a, b) => b.assessmentDate.compareTo(a.assessmentDate));

    assessments = assessments.reversed.toList();

    Color? colorGroup;
    if (widget.discipline == null) {
      colorGroup = Theme.of(context).primaryColorDark;
    } else {
      if (widget.discipline!.color != null) {
        colorGroup = widget.discipline!.color;
      }
    }

    MediaQueryData screenSize = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Used to fullfill size
        Divider(
          thickness: 0,
          height: 0,
          indent: 0,
          endIndent: 0,
          color: Colors.transparent,
        ),
        if (widget.discipline?.subdisciplineNames != null &&
            widget.discipline!.subdisciplineNames!.length - 1 >= sousMatiereIndex &&
            assessments.length > 0)
          if (sousMatiereIndex > 0)
            Divider(
              thickness: 2,
            ),
        if (widget.discipline?.subdisciplineNames != null &&
            widget.discipline!.subdisciplineNames!.length - 1 >= sousMatiereIndex &&
            assessments.length > 0)
          Center(
              child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    widget.discipline!.subdisciplineNames![sousMatiereIndex] ?? "N/A",
                    style: TextStyle(
                      fontFamily: "Asap",
                      color: ThemeUtils.textColor(),
                    ),
                  ))),
        Wrap(
          spacing: screenSize.size.width / 5 * 0.05,
          runSpacing: 0.5.h,
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: List.generate(assessments.length, (index) {
            return Material(
              borderRadius: BorderRadius.circular(8),
              color: colorGroup,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                splashColor: Theme.of(context).primaryColorDark,
                hoverColor: Theme.of(context).primaryColorDark,
                highlightColor: Theme.of(context).primaryColorDark,
                onLongPress: () {},
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.6, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                      color: colorGroup),
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  child: RowBuilder(
                      itemCount: assessments[index].competences.length,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      itemBuilder: (context, index2) {
                        return Container(
                          margin: EdgeInsets.only(right: 5),
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              color: assessments[index].competences[index2].level.defaultColor, shape: BoxShape.circle),
                        );
                      }),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
