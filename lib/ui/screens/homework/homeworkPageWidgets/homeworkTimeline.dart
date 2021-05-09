import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/columnGenerator.dart';

class HomeworkTimeline extends StatefulWidget {
  const HomeworkTimeline({Key? key}) : super(key: key);
  @override
  _HomeworkTimelineState createState() => _HomeworkTimelineState();
}
// var screenSize = MediaQuery.of(context);

class _HomeworkTimelineState extends State<HomeworkTimeline> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return ChangeNotifierProvider<HomeworkController>.value(
      value: appSys.homeworkController,
      child: Consumer<HomeworkController>(builder: (context, model, child) {
        return Container(
          height: screenSize.size.height,
          width: screenSize.size.width,
          child: ListView.builder(
              itemCount: groupHomeworkByDate(model.getHomework ?? []).length,
              itemBuilder: (context, index) {
                return buildHomeworkBlock(groupHomeworkByDate(model.getHomework ?? [])[index].first.date ?? DateTime.now(),
                    groupHomeworkByDate(model.getHomework ?? [])[index]);
              }),
        );
      }),
    );
  }

  ///The basical homework element
  buildHomework(Homework homeworkElement) {
    var screenSize = MediaQuery.of(context);
    return FutureBuilder<int>(
        future: getColor(homeworkElement.disciplineCode),
        initialData: 0,
        builder: (context, snapshot) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Color(snapshot.data ?? 0),
            margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {},
              child: Container(
                width: screenSize.size.width / 5 * 4.1,
                height: screenSize.size.height / 10 * 0.6,
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.08),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8,
                            child: AutoSizeText(
                              homeworkElement.discipline ?? "",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Asap",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 7,
                              child: AutoSizeText(homeworkElement.teacherName ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontFamily: "Asap")))
                        ],
                      ),
                    ),
                    if (homeworkElement.toReturn ?? false) Icon(MdiIcons.uploadOutline),
                    if (homeworkElement.isATest ?? false) Icon(MdiIcons.bookEditOutline)
                  ],
                ),
              ),
            ),
          );
        });
  }

  buildHomeworkBlock(DateTime date, List<Homework> homework) {
    var screenSize = MediaQuery.of(context);
    return Container(
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
        width: screenSize.size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: buildLeftDate(date)),
            Expanded(
                flex: 8,
                child: ColumnBuilder(
                  itemCount: homework.length,
                  itemBuilder: (context, index) {
                    return buildHomework(homework[index]);
                  },
                )),
          ],
        ));
  }

  buildLeftDate(DateTime date) {
    var screenSize = MediaQuery.of(context);
    String day = DateFormat("EEEE", "fr_FR").format(date).substring(0, 3).toUpperCase();
    String number = date.day.toString();
    String month = DateFormat("MMMM", "fr_FR").format(date);

    return Container(
      height: screenSize.size.height / 10 * 1.2,
      width: screenSize.size.width / 5 * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: AutoSizeText(
              day,
              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
              flex: 4,
              child: AutoSizeText(
                number,
                style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                textAlign: TextAlign.center,
              )),
          Flexible(
              flex: 2,
              child: AutoSizeText(
                month,
                style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }

  //Date on the left of the homework
  List<List<Homework>> groupHomeworkByDate(List<Homework> homeworkList) {
    List<DateTime> dates = [];
    List<List<Homework>> subList = [];
    homeworkList.forEach((hw) {
      //add dates once
      if (!dates.contains(hw.date) && hw.date != null) {
        dates.add(hw.date!);
      }
    });
    dates.forEach((date) {
      subList.add(homeworkList.where((element) => element.date == date).toList());
    });
    return subList;
  }
}
