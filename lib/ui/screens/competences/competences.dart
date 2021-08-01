import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/competences/controller.dart';
import 'package:ynotes/core/logic/grades/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'package:ynotes/ui/screens/competences/widgets/competences_group.dart';
import 'package:ynotes_packages/components.dart';


class CompetencesPage extends StatefulWidget {
  const CompetencesPage({Key? key}) : super(key: key);
  State<StatefulWidget> createState() => _CompetencesPageState();
}

class _CompetencesPageState extends State<CompetencesPage> with LayoutMixin {
  ///Start building grades box from here
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ChangeNotifierProvider<CompetencesController>.value(
        value: appSys.competencesController,
        child: Consumer<CompetencesController>(builder: (context, model, child) {
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
              
              ],
              body: Builder(builder: (context) {
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
                        onRefresh: forceRefreshCompetences,
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
                                  child: Builder(builder: (context) {
                                    if (!model.isFetching) {
                                      if (model
                                          .disciplines()!
                                          .any((CompetencesDiscipline element) => (element.assessmentsList!.length > 0))) {
                                        return Column(
                                          children: [
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
                                                      itemBuilder: (BuildContext context, int index) =>  CompetencesGroup(
                                                        discipline: model.disciplines()![index],
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
                                                  forceRefreshCompetences();
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
                                                  itemBuilder: (BuildContext context, int index) =>  CompetencesGroup(
                                                    discipline: null,
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
                              ],
                            ))),
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


  Widget buildDefaultChoice(String name, IconData icon, CompetencesController con, String filterName) {
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

  Future<void> forceRefreshCompetences() async {
    await appSys.competencesController.refresh(force: true);
  }

  void initState() {
    super.initState();
    initializeDateFormatting("fr_FR", null);
  }

  openSortBox(CompetencesController competencesController) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Container(
                width: screenSize.size.width / 5 * 3.2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildDefaultChoice("Pas de filtre", MdiIcons.borderNoneVariant, competencesController, "all"),
                    SizedBox(height: screenSize.size.height / 10 * 0.1),
                    buildDefaultChoice("Spécialités", MdiIcons.star, competencesController, "specialties"),
                    SizedBox(height: screenSize.size.height / 10 * 0.1),
                    buildDefaultChoice("Littérature", MdiIcons.bookOpenBlankVariant, competencesController, "littérature"),
                    SizedBox(height: screenSize.size.height / 10 * 0.1),
                    buildDefaultChoice(
                      "Sciences",
                      MdiIcons.atom,
                      competencesController,
                      "sciences",
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  
  }


