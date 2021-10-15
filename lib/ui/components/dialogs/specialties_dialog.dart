import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/custom_loader.dart';

class DialogSpecialties extends StatefulWidget {
  const DialogSpecialties({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DialogSpecialtiesState();
  }
}

class _DialogSpecialtiesState extends State<DialogSpecialties> {
  List<String?>? chosenSpecialties = [];
  dynamic classe;
  late Future<List<Discipline>?> disciplinesFuture;

  @override
  Widget build(BuildContext context) {
    List disciplines = [];

    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return SizedBox(
      height: screenSize.size.height / 10 * 4,
      child: FutureBuilder<List<Discipline>?>(
          future: disciplinesFuture,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container();
            }
            if (snapshot.hasData) {
              for (var element in (snapshot.data ?? [])) {
                if (!disciplines.contains(element.disciplineName)) {
                  disciplines.add(element.disciplineName);
                }
              }

              return AlertDialog(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  contentPadding: const EdgeInsets.only(top: 10.0),
                  content: SizedBox(
                      height: screenSize.size.height / 10 * 4,
                      width: screenSize.size.width / 5 * 4,
                      child: ShaderMask(
                        shaderCallback: (Rect rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                            stops: [0.0, 0.15, 0.8, 1.0], // 10% purple, 80% transparent, 10% purple
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: Center(
                            child: (disciplines.isNotEmpty)
                                ? ListView.builder(
                                    padding: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.35),
                                    itemCount: disciplines.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            if (chosenSpecialties!.contains(disciplines[index])) {
                                              setState(() {
                                                chosenSpecialties!
                                                    .removeWhere((element) => element == disciplines[index]);
                                              });
                                              CustomLogger.log(
                                                  "DIALOGS", "(Specialties) Chosen specialties: $chosenSpecialties");
                                              setChosenSpecialties();
                                            } else {
                                              if (chosenSpecialties!.length < 6) {
                                                setState(() {
                                                  chosenSpecialties!.add(disciplines[index]);
                                                });
                                                setChosenSpecialties();
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: screenSize.size.width / 5 * 4,
                                            padding: EdgeInsets.symmetric(
                                              vertical: screenSize.size.height / 10 * 0.1,
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Checkbox(
                                                  side: const BorderSide(width: 1, color: Colors.white),
                                                  fillColor:
                                                      MaterialStateColor.resolveWith(ThemeUtils.getCheckBoxColor),
                                                  onChanged: (value) {
                                                    if (chosenSpecialties!.contains(disciplines[index])) {
                                                      setState(() {
                                                        chosenSpecialties!
                                                            .removeWhere((element) => element == disciplines[index]);
                                                      });
                                                      CustomLogger.log("DIALOGS",
                                                          "(Specialties) Chosen specialties: $chosenSpecialties");
                                                      setChosenSpecialties();
                                                    } else {
                                                      if (chosenSpecialties!.length < 6) {
                                                        setState(() {
                                                          chosenSpecialties!.add(disciplines[index]);
                                                        });
                                                        setChosenSpecialties();
                                                      }
                                                    }
                                                  },
                                                  shape: const CircleBorder(),
                                                  value: chosenSpecialties!.contains(disciplines[index]),
                                                ),
                                                SizedBox(
                                                  width: screenSize.size.width / 5 * 3,
                                                  child: AutoSizeText(
                                                    disciplines[index],
                                                    style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(MdiIcons.information, color: ThemeUtils.textColor()),
                                        AutoSizeText(
                                          "Pas assez de données pour générer votre liste de spécialités.",
                                          style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  )),
                      )));
            } else {
              return CustomLoader(
                  screenSize.size.width / 5 * 1.5, screenSize.size.width / 5 * 1.5, Theme.of(context).primaryColorDark);
            }
          }),
    );
  }

  getChosenSpecialties() async {
    final prefs = await (SharedPreferences.getInstance());
    if (prefs.getStringList("listSpecialties") != null) {
      setState(() {
        chosenSpecialties = prefs.getStringList("listSpecialties");
      });
    }
  }

  @override
  initState() {
    super.initState();
    getChosenSpecialties();
    setState(() {
      disciplinesFuture = appSys.api!.getGrades(forceReload: true);
    });
  }

  setChosenSpecialties() async {
    final prefs = await (SharedPreferences.getInstance());
    if (chosenSpecialties != null && chosenSpecialties!.every((element) => element != null)) {
      prefs.setStringList("listSpecialties", chosenSpecialties!.cast<String>());
    }
    CustomLogger.log(
        "DIALOGS", "(Specialties) Chosen specialties (from prefs): ${prefs.getStringList("listSpecialties")}");
  }
}
