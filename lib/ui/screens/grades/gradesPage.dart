import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modalBottomSheets/simulatorModalBottomSheet/simulatorModalBottomSheet.dart';
import 'package:ynotes/ui/screens/grades/gradesPageWidgets/gradesGroup.dart';

bool firstStart = true;

//This boolean show a little badge if true
int initialIndexGradesOffset = 0;
//If true, show a carousel
bool newGrades = false;
List? specialties;

class GradesPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldState;
  const GradesPage({Key? key, required this.parentScaffoldState}) : super(key: key);
  State<StatefulWidget> createState() {
    return _GradesPageState();
  }
}

class _GradesPageState extends State<GradesPage> {
  ///Start building grades box from here
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    ScrollController controller = ScrollController();

    return ChangeNotifierProvider<GradesController>.value(
      value: appSys.gradesController,
      child: Consumer<GradesController>(builder: (context, model, child) {
        return Scaffold(
          appBar: new AppBar(
              title: new Text(
                "Notes",
                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
              ),
              leading: FlatButton(
                color: Colors.transparent,
                child: Icon(MdiIcons.menu, color: ThemeUtils.textColor()),
                onPressed: () async {
                  widget.parentScaffoldState.currentState?.openDrawer();
                },
              ),
              actions: [
                Container(
                  width: screenSize.size.width / 5 * 0.6,
                  child: TextButton(
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
                      child: Icon(MdiIcons.calendarRange, color: ThemeUtils.textColor())),
                ),
                Container(
                  width: screenSize.size.width / 5 * 0.6,
                  child: TextButton(
                      onPressed: () async {
                        openSortBox(model);
                      },
                      child: Icon(MdiIcons.sortVariant,
                          color: model.sorter != "all" ? Colors.green : ThemeUtils.textColor())),
                ),
                Container(
                  width: screenSize.size.width / 5 * 0.6,
                  child: TextButton(
                      onPressed: () async {
                        model.isSimulating = !model.isSimulating;
                      },
                      child: Icon(MdiIcons.flask, color: model.isSimulating ? Colors.blue : ThemeUtils.textColor())),
                ),
              ],
              backgroundColor: Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).backgroundColor,
          body: Consumer<GradesController>(builder: (context, model, child) {
            return Container(
              color: Theme.of(context).backgroundColor,
              height: screenSize.size.height,
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                ///Button container

                ///Grades container
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
                          width: screenSize.size.width / 5 * 4.7,
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
                                            child: ShaderMask(
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
                                              child: ListView.builder(
                                                  physics: AlwaysScrollableScrollPhysics(),
                                                  itemCount: model.disciplines()!.length,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: screenSize.size.width / 5 * 0.05),
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return GradesGroup(
                                                        discipline: model.disciplines()![index],
                                                        gradesController: model);
                                                  }),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                              image: AssetImage('assets/images/book.png'),
                                              width: screenSize.size.width / 5 * 4),
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.5),
                                              child: AutoSizeText("Pas de notes pour cette periode.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor())),
                                            ),
                                          ),
                                          FlatButton(
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
                                            shape: RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(18.0),
                                                side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                          )
                                        ],
                                      );
                                    }
                                  }
                                  if (!model.isFetching && model.disciplines == null) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image(
                                          image: AssetImage('assets/images/totor.png'),
                                          width: screenSize.size.width / 5 * 3.5,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.5),
                                          child:
                                              AutoSizeText("Hum... on dirait que tout ne s'est pas passé comme prévu.",
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
                                    return ListView.builder(
                                        itemCount: 5,
                                        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.3),
                                        itemBuilder: (BuildContext context, int index) {
                                          return GradesGroup(
                                            gradesController: model,
                                            discipline: null,
                                          );
                                        });
                                  }
                                }),
                              ),
                              if (model.isSimulating) _buildFloatingButton(context)
                            ],
                          ))),
                ),

                //Average section
                Expanded(
                  flex: 5,
                  child: Container(
                    width: screenSize.size.width,
                    child: Consumer<GradesController>(builder: (context, model, child) {
                      Discipline? lastDiscipline;
                      if (model.disciplines != null) {
                        try {
                          lastDiscipline = model
                              .disciplines()!
                              .lastWhere((disciplinesList) => disciplinesList.periodName == model.period);
                        } catch (exception) {}

                        //If everything is ok, show stuff
                        return buildBottomBar(lastDiscipline, model);
                      }

                      //To do if it can't get the data
                      if (model.average == null) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.error,
                              color: ThemeUtils.textColor(),
                              size: screenSize.size.width / 8,
                            ),
                          ],
                        );
                      } else {
                        return SpinKitFadingFour(
                          color: Theme.of(context).primaryColorDark,
                          size: screenSize.size.width / 5 * 0.7,
                        );
                      }
                    }),
                  ),
                ),
              ]),
            );
          }),
        );
      }),
    );
  }

  Widget buildAverageContainer(String name, String average) {
    var screenSize = MediaQuery.of(context);

    return Container(
      height: screenSize.size.height / 10 * 0.45,
      width: screenSize.size.width / 5 * 1.55,
      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Text(
            name,
            style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
          )),
          Text(average,
              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()))
        ],
      ),
    );
  }

  Widget buildBottomBar(Discipline? discipline, GradesController model) {
    var screenSize = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(screenSize.size.height / 10 * 0.3),
            width: screenSize.size.width / 5 * 1.4,
            height: screenSize.size.width / 5 * 1.1,
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
                (model.average.toString() != null && !model.average.isNaN ? model.average.toStringAsFixed(2) : "-"),
                style: TextStyle(color: Colors.black, fontFamily: "Asap", fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: screenSize.size.width / 5 * 0.05,
          ),
          Expanded(
            child: Wrap(
              direction: Axis.horizontal,
              runSpacing: screenSize.size.height / 10 * 0.1,
              spacing: screenSize.size.width / 5 * 0.2,
              children: [
                buildAverageContainer("MAX", discipline?.maxClassGeneralAverage ?? "N/A"),
                buildAverageContainer("CLASSE", discipline?.classGeneralAverage ?? "N/A"),
                buildAverageContainer("RANG", discipline?.generalRank ?? "N/A"),
              ],
            ),
          )
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
      margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          child: FloatingActionButton(
            heroTag: "simulBtn",
            backgroundColor: Colors.transparent,
            child: Container(
              width: screenSize.size.width / 5 * 0.8,
              height: screenSize.size.width / 5 * 0.8,
              child: Icon(
                Icons.add,
                size: screenSize.size.width / 5 * 0.5,
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
    return Container(
      margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.2),
      child:
          CustomButtons.materialButton(context, screenSize.size.width / 5 * 3.2, screenSize.size.height / 10 * 0.5, () {
        controller.simulationReset();
      }, label: "Réinitialiser les notes", textColor: Colors.white, backgroundColor: Colors.blue),
    );
  }
}
