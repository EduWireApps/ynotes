import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/workspaces/controller.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/columnGenerator.dart';

class WorkSpacesList extends StatefulWidget {
  final WorkspacesController controller;
  const WorkSpacesList({Key? key, required this.controller}) : super(key: key);

  @override
  _WorkSpacesListState createState() => _WorkSpacesListState();
}

class _WorkSpacesListState extends State<WorkSpacesList> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          if (!appSys.settings.user.workspacesPage.readExplanation) buildExplanation(),
          SizedBox(height: screenSize.size.height / 10 * 0.1),
          buildSpace("Mes espaces de travail",
              widget.controller.workspaces?.where((element) => (element.isMemberOf ?? false)).toList()),
          SizedBox(height: screenSize.size.height / 10 * 0.1),
          buildSpace("Autres espaces de travail",
              widget.controller.workspaces?.where((element) => (!(element.isMemberOf ?? true))).toList())
        ],
      ),
    );
  }

  Widget buildExplanation() {
    var screenSize = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: screenSize.size.height / 10 * 0.1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: ThemeUtils.darken(Theme.of(context).primaryColor, forceAmount: 0.1)),
      child: Column(
        children: [
          Icon(MdiIcons.accountGroup, color: ThemeUtils.textColor().withOpacity(0.7)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "Les espaces de travail vous permettent de travailler en collaboration avec d'autres personnes appartenant au groupe de travail notamment en partageant des fichiers dans un cloud collectif et à l'aide de post its. Nous avons ajouté quelques fonctionnalités pour vous aider à travailler de manière plus efficace !",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: "Asap",
                color: ThemeUtils.textColor().withOpacity(0.7),
              ),
            ),
          ),
          CustomButtons.materialButton(context, null, null, () {
            appSys.settings.user.workspacesPage.readExplanation = true;
            appSys.saveSettings();
            setState(() {});
          }, label: "J'ai compris", padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5))
        ],
      ),
    );
  }

  Widget buildSpace(String spaceName, List<Workspace>? workspaces) {
    var screenSize = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: screenSize.size.height / 10 * 0.1),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).primaryColor),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spaceName,
            textAlign: TextAlign.start,
            style:
                TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w500, fontSize: 29, color: ThemeUtils.textColor()),
          ),
          //Do not remove (expands horizontally)
          Row(
            children: [
              Expanded(
                child: Container(),
              )
            ],
          ),
          SizedBox(
            height: screenSize.size.height / 10 * 0.05,
          ),
          Builder(
            builder: (context) {
              if (workspaces == null || workspaces.length == 0) {
                return Center(child: Text("Pas d'espace de travail"));
              } else {
                return ColumnBuilder(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    itemCount: workspaces.length,
                    itemBuilder: (context, index) {
                      Workspace workspace = workspaces[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
                        child: Material(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: () {},
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: screenSize.size.height / 10 * 0.1),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(workspace.title ?? "Espace sans titre",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor())),
                                          if (workspace.author != null && workspace.author != "")
                                            Text(
                                              workspace.author!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontFamily: "Asap", color: ThemeUtils.textColor().withOpacity(0.7)),
                                            )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            },
          )
        ],
      ),
    );
  }
}
