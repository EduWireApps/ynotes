import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/columnGenerator.dart';
import 'package:ynotes/ui/components/customLoader.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/screens/homework/homeworkPageWidgets/homeworkViewPage.dart';
import 'package:ynotes/usefulMethods.dart';

class HomeworkElement extends StatefulWidget {
  final List<Homework> homework;
  final int index;

  const HomeworkElement(
    this.homework,
    this.index, {
    Key? key,
  }) : super(key: key);
  @override
  _HomeworkElementState createState() => _HomeworkElementState();
}
// var screenSize = MediaQuery.of(context);

class HomeworkTimeline extends StatefulWidget {
  const HomeworkTimeline({Key? key}) : super(key: key);
  @override
  _HomeworkTimelineState createState() => _HomeworkTimelineState();
}

class _HomeworkElementState extends State<HomeworkElement> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation =
        Tween(begin: 0.0, end: 24.0).chain(CurveTween(curve: Curves.elasticIn)).animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder<int>(
        future: getColor(widget.homework[widget.index].disciplineCode),
        initialData: 0,
        builder: (context, snapshot) {
          return AnimatedBuilder(
              animation: offsetAnimation,
              builder: (buildContext, child) {
                return Transform.translate(
                  offset: Offset(offsetAnimation.value, 0),
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      color: Color(snapshot.data ?? 0),
                      margin: EdgeInsets.zero,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () async {
                          if (!(widget.homework[widget.index].loaded ?? true)) {
                            appSys.homeworkController.ugradePriority(widget.homework[widget.index]);
                            controller.forward();
                          } else {
                            Navigator.of(context).push(router(HomeworkDayViewPage(
                              widget.homework,
                              defaultPage: widget.index,
                            )));
                          }
                        },
                        onLongPress: () async {
                          await CustomDialogs.showHomeworkDetailsDialog(context, widget.homework[widget.index]);
                          setState(() {});
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            width: screenSize.size.width / 5 * 4.1,
                            height: screenSize.size.height / 10 * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 8,
                                                child: Container(
                                                  child: AutoSizeText(
                                                    widget.homework[widget.index].discipline ?? "",
                                                    textAlign: TextAlign.start,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: "Asap",
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                  flex: 7,
                                                  child: AutoSizeText(
                                                      widget.homework[widget.index].teacherName?.trimLeft() ?? "",
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(fontFamily: "Asap")))
                                            ],
                                          ),
                                        ),
                                        if (widget.homework[widget.index].toReturn ?? false)
                                          Icon(MdiIcons.uploadOutline),
                                        if (widget.homework[widget.index].isATest ?? false)
                                          Icon(MdiIcons.bookEditOutline)
                                      ],
                                    ),
                                  ),
                                ),
                                if (!(widget.homework[widget.index].loaded ?? true)) LinearProgressIndicator()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }
}

class _HomeworkTimelineState extends State<HomeworkTimeline> {
  bool loading = false;

  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: Stack(
        children: [
          ChangeNotifierProvider<HomeworkController>.value(
            value: appSys.homeworkController,
            child: Consumer<HomeworkController>(builder: (context, model, child) {
              return RefreshIndicator(
                onRefresh: refresh,
                child: Container(
                    height: screenSize.size.height,
                    width: screenSize.size.width,
                    child: groupHomeworkByDate(model.getHomework ?? []).length > 0
                        ? ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: groupHomeworkByDate(model.getHomework ?? []).length,
                            itemBuilder: (context, index) {
                              return buildHomeworkBlock(
                                  groupHomeworkByDate(model.getHomework ?? [])[index].first.date ?? DateTime.now(),
                                  groupHomeworkByDate(model.getHomework ?? [])[index]);
                            })
                        : buildNoHomework(model)),
              );
            }),
          ),
          if (loading)
            Container(
              color: Colors.black.withOpacity(0.4),
            ),
          if (loading)
            Center(
                child: CustomLoader(
              screenSize.size.width / 5 * 2.5,
              screenSize.size.width / 5 * 2.5,
              Theme.of(context).primaryColorDark,
            )),
        ],
      ),
    );
  }

  buildHomeworkBlock(DateTime date, List<Homework> homework) {
    var screenSize = MediaQuery.of(context);
    return Container(
        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
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
                    return HomeworkElement(homework, index);
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
      height: screenSize.size.height / 10 * 1,
      width: screenSize.size.width / 5 * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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

  Widget buildNoHomework(HomeworkController model) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: screenSize.size.height / 10 * 7.5,
          width: screenSize.size.width / 5 * 4.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(fit: BoxFit.fitWidth, image: AssetImage('assets/images/noHomework.png')),
              Text(
                "Pas de devoirs à l'horizon... \non se détend ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Asap",
                  color: ThemeUtils.textColor(),
                ),
              ),
              FlatButton(
                onPressed: () {
                  //Reload list
                  appSys.homeworkController.refresh(force: true);
                },
                child: !model.isFetching
                    ? Text("Recharger",
                        style: TextStyle(
                          fontFamily: "Asap",
                          color: ThemeUtils.textColor(),
                        ))
                    : FittedBox(
                        child: SpinKitThreeBounce(
                            color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4)),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Theme.of(context).primaryColorDark)),
              )
            ],
          ),
        )
      ],
    );
  }

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

  //Date on the left of the homework
  Future<void> refresh() async {
    await appSys.homeworkController.refresh(force: true);
  }
}
