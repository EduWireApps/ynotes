import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'widgets/grades_group.dart';
import 'widgets/simulator_modal_bottom_sheet.dart';
import 'package:ynotes_packages/components.dart';

bool firstStart = true;

//This boolean show a little badge if true
int initialIndexGradesOffset = 0;
//If true, show a carousel
bool newGrades = false;
List? specialties;

class GradesPage extends StatefulWidget {
  const GradesPage({Key? key}) : super(key: key);
  State<StatefulWidget> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> with LayoutMixin {
  ///Start building grades box from here
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ChangeNotifierProvider<GradesController>.value(
        value: appSys.gradesController,
        child: Consumer<GradesController>(builder: (context, model, child) {
          return YPage(
              title: "Notes",
              isScrollable: false,
              actions: [
                IconButton(
                    onPressed: () async {
                      var choice = await CustomDialogs.showMultipleChoicesDialog(
                          context,
                          (model.periods ?? []).map((e) => e.name).toList(),
                          [(model.periods ?? []).map((e) => e.name).toList().indexOf(model.period)],
                          singleChoice: true);
                      if (choice != null) {
                        model.period = model.periods?[choice.first].name;
                      }
                    },
                    icon: Icon(MdiIcons.calendarRange)),
                IconButton(
                    onPressed: () async {
                      openSortBox(model);
                    },
                    icon: Icon(MdiIcons.sortVariant,
                        color: model.sorter != "all" ? Colors.green : ThemeUtils.textColor())),
                IconButton(
                    onPressed: () async {
                      model.isSimulating = !model.isSimulating;
                    },
                    icon: Icon(MdiIcons.flask, color: model.isSimulating ? Colors.blue : ThemeUtils.textColor()))
              ],
              body: Consumer<GradesController>(builder: (context, model, child) {
                return Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                  Container(
                      height: screenSize.size.height / 10 * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model.period ?? "Pas de période",
                            style: TextStyle(
                                fontFamily: "Asap",
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: ThemeUtils.textColor()),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 28,
                    child: RefreshIndicator(
                        onRefresh: forceRefreshGrades,
                        child: Container(
                            width: screenSize.size.width,
                            margin: EdgeInsets.only(top: 0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.000000, color: Colors.transparent),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                                color: Theme.of(context).backgroundColor),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Consumer<GradesController>(builder: (context, model, child) {
                                    if (!model.isFetching) {
                                      if (model
                                          .disciplines()!
                                          .any((Discipline element) => (element.gradesList!.length > 0))) {
                                        return Column(
                                          children: [
                                            if (model.isSimulating) _buildResetButton(model),
                                            Expanded(
                                              child: LayoutBuilder(builder: (context, constraints) {
                                                return YShadowScrollContainer(
                                                  color: Theme.of(context).backgroundColor,
                                                  children: [
                                                    StaggeredGridView.countBuilder(
                                                      shrinkWrap: true,
                                                      physics: ClampingScrollPhysics(),
                                                      padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 15 : 5),
                                                      crossAxisCount: 4,
                                                      itemCount: model.disciplines()!.length,
                                                      itemBuilder: (BuildContext context, int index) => new GradesGroup(
                                                        discipline: model.disciplines()![index],
                                                        gradesController: model,
                                                      ),
                                                      staggeredTileBuilder: (int index) =>
                                                          new StaggeredTile.fit(isLargeScreen ? 2 : 4),
                                                      mainAxisSpacing: 15,
                                                      crossAxisSpacing: 10,
                                                    )
                                                  ],
                                                );
                                              }),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: screenSize.size.height / 10 * 2.5,
                                              child: FittedBox(
                                                child: Image(
                                                  fit: BoxFit.fitHeight,
                                                  image: AssetImage('assets/images/pageItems/grades/noGrades.png'),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.5),
                                                child: AutoSizeText("Pas de notes pour cette periode.",
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor())),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                                              width: 80,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: new BorderRadius.circular(18.0),
                                                      side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                                ),
                                                onPressed: () {
                                                  //Reload list
                                                  forceRefreshGrades();
                                                },
                                                child: !model.isFetching
                                                    ? Text("Recharger",
                                                        style: TextStyle(
                                                            fontFamily: "Asap",
                                                            color: ThemeUtils.textColor(),
                                                            fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2))
                                                    : FittedBox(
                                                        child: SpinKitThreeBounce(
                                                            color: Theme.of(context).primaryColorDark,
                                                            size: screenSize.size.width / 5 * 0.4)),
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                    }
                                    if (!model.isFetching) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                            image: AssetImage('assets/images/issues/totor.png'),
                                            width: screenSize.size.width / 5 * 3.5,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.5),
                                            child: AutoSizeText(
                                                "Hum... on dirait que tout ne s'est pas passé comme prévu.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "Asap",
                                                  color: ThemeUtils.textColor(),
                                                )),
                                          ),
                                        ],
                                      );
                                    } else {
                                      //Loading group
                                      return ShaderMask(
                                          shaderCallback: (Rect rect) {
                                            return LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.purple,
                                                Colors.transparent,
                                                Colors.transparent,
                                                Colors.purple
                                              ],
                                              stops: [0, 0, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
                                            ).createShader(rect);
                                          },
                                          blendMode: BlendMode.dstOut,
                                          child: Container(
                                              width: screenSize.size.width,
                                              child: LayoutBuilder(builder: (context, constraints) {
                                                return StaggeredGridView.countBuilder(
                                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                                  crossAxisCount: 4,
                                                  itemCount: 18,
                                                  itemBuilder: (BuildContext context, int index) => new GradesGroup(
                                                    discipline: null,
                                                    gradesController: model,
                                                  ),
                                                  staggeredTileBuilder: (int index) =>
                                                      new StaggeredTile.fit(isLargeScreen ? 2 : 4),
                                                  mainAxisSpacing: 15,
                                                  crossAxisSpacing: 10,
                                                );
                                              })));
                                    }
                                  }),
                                ),
                                if (model.isSimulating) _buildFloatingButton(context)
                              ],
                            ))),
                  ),

                  //Average section
                  Container(
                    width: screenSize.size.width,
                    child: Consumer<GradesController>(builder: (context, model, child) {
                      Discipline? lastDiscipline;
                      if (model.disciplines()?.length != 0) {
                        try {
                          lastDiscipline = model
                              .disciplines()!
                              .lastWhere((disciplinesList) => disciplinesList.periodName == model.period);
                        } catch (exception) {}

                        //If everything is ok, show stuff
                        return buildBottomBar(lastDiscipline, model);
                      } else {
                        return SpinKitFadingFour(
                          color: Theme.of(context).primaryColorDark,
                          size: screenSize.size.width / 5 * 0.7,
                        );
                      }
                    }),
                  ),
                ]);
              }));
        }));
  }

  Widget buildAverageContainer(String name, String average) {
    var screenSize = MediaQuery.of(context);

    return Container(
      height: screenSize.size.height / 10 * 0.45,
      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              child: Text(
            name,
            style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
          )),
          SizedBox(
            width: 15,
          ),
          Text(average,
              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()))
        ],
      ),
    );
  }

  Widget buildBottomBar(Discipline? discipline, GradesController model) {
    var screenSize = MediaQuery.of(context);
    bool largeScreen = screenSize.size.width > 500;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          SizedBox(
            width: screenSize.size.width / 5 * 0.15,
          ),
          Container(
            padding: EdgeInsets.all(5),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 2.67,
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 2.67),
                  ),
                ],
                color: (model.sorter == "all" ? Colors.white : Colors.green)),
            child: FittedBox(
              child: AutoSizeText(
                (!model.average.isNaN ? model.average.toStringAsFixed(2) : "-"),
                style: TextStyle(color: Colors.black, fontFamily: "Asap", fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: screenSize.size.width / 5 * 0.3,
          ),
          Expanded(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: largeScreen ? WrapAlignment.end : WrapAlignment.start,
              runSpacing: screenSize.size.height / 10 * 0.1,
              spacing: screenSize.size.width / 5 * 0.1,
              children: [
                buildAverageContainer("MAX", discipline?.maxClassGeneralAverage ?? "N/A"),
                buildAverageContainer("CLASSE", discipline?.classGeneralAverage ?? "N/A"),
                buildAverageContainer("RANG", discipline?.generalRank ?? "N/A"),
              ],
            ),
          ),
          SizedBox(
            width: screenSize.size.width / 5 * 0.1,
          ),
        ],
      ),
    );
  }

  Widget buildDefaultChoice(String name, IconData icon, GradesController con, String filterName) {
    var screenSize = MediaQuery.of(context);

    return Material(
      borderRadius: BorderRadius.circular(11),
      color: con.sorter == filterName ? Colors.green : Theme.of(context).primaryColorDark,
      child: InkWell(
        onTap: () {
          con.sorter = filterName;
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(11),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(11)),
          height: screenSize.size.height / 10 * 0.8,
          child: Row(
            children: [
              Container(
                width: screenSize.size.width / 10 * 1.5,
                height: screenSize.size.width / 10 * 1.5,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Icon(
                  icon,
                  color: ThemeUtils.textColor(),
                ),
              ),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> forceRefreshGrades() async {
    await appSys.gradesController.refresh(force: true);
  }

  void initState() {
    super.initState();

    initializeDateFormatting("fr_FR", null);
  }

  openSortBox(GradesController gradesController) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            content: Container(
              width: screenSize.size.width / 5 * 3.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildDefaultChoice("Pas de filtre", MdiIcons.borderNoneVariant, gradesController, "all"),
                  SizedBox(height: screenSize.size.height / 10 * 0.1),
                  buildDefaultChoice("Spécialités", MdiIcons.star, gradesController, "specialties"),
                  SizedBox(height: screenSize.size.height / 10 * 0.1),
                  buildDefaultChoice("Littérature", MdiIcons.bookOpenBlankVariant, gradesController, "littérature"),
                  SizedBox(height: screenSize.size.height / 10 * 0.1),
                  buildDefaultChoice(
                    "Sciences",
                    MdiIcons.atom,
                    gradesController,
                    "sciences",
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildFloatingButton(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1, right: screenSize.size.width / 5 * 0.1),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          child: FloatingActionButton(
            heroTag: "simulBtn",
            backgroundColor: Colors.transparent,
            child: Container(
              width: 120,
              height: 120,
              child: FittedBox(
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff100A30)),
            ),
            onPressed: () async {
              Grade? a = await simulatorModalBottomSheet(appSys.gradesController, context);
              if (a != null) {
                appSys.gradesController.simulationAdd(a);
              }
            },
          ),
        ),
      ),
    );
  }

  _buildResetButton(GradesController controller) {
    var screenSize = MediaQuery.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: Container(
        margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.2),
        child: CustomButtons.materialButton(context, screenSize.size.width / 5 * 3.2, screenSize.size.height / 10 * 0.5,
            () {
          controller.simulationReset();
        },
            label: "Réinitialiser les notes",
            textColor: Colors.white,
            backgroundColor: Colors.blue,
            padding: EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
