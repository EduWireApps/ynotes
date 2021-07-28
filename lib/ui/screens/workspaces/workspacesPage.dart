import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/workspaces/controller.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/custom_loader.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'package:ynotes/ui/screens/workspaces/workspacesPageWidgets/cloudFilesList.dart';
import 'package:ynotes/ui/screens/workspaces/workspacesPageWidgets/workspacesList.dart';
import 'package:ynotes_packages/theme.dart';

var actualSort = sortValue.date;

Future<List<CloudItem>?>? cloudFolderFuture;

String? cloudUsedFolder = "";

List<CloudItem>? localFoldersList;
sortByGroupMainPage(List<CloudItem> list) {
  List<CloudItem> toReturn = [];
  //Make two groups of member of and not member of

  list.forEach((element) {
    if (element.isMemberOf != null && element.isMemberOf!) {
      toReturn.add(element);
    }
  });
  list.forEach((element) {
    if (element.isMemberOf == null || !element.isMemberOf!) {
      toReturn.add(element);
    }
  });
  return toReturn;
}

enum sortValue { date, reversed_date, author }

class WorkspacesPage extends StatefulWidget {
  const WorkspacesPage({Key? key}) : super(key: key);

  State<StatefulWidget> createState() {
    return _WorkspacesPageState();
  }
}

//Sort in the main page
class _WorkspacesPageState extends State<WorkspacesPage> with LayoutMixin {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return YPage(
        title: "Espaces de travail",
        isScrollable: false,
        body: ChangeNotifierProvider<WorkspacesController>.value(
          value: appSys.workspacesController,
          child: Consumer<WorkspacesController>(builder: (context, model, child) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                        duration: Duration(milliseconds: 250),
                        height: screenSize.size.height / 10 * 0.5,
                        width: screenSize.size.width,
                        child: Opacity(
                          opacity: model.path == "/" ? 0.4 : 1,
                          child: Material(
                            borderRadius: BorderRadius.circular(12),
                            color: theme.colors.neutral.shade300,
                            child: InkWell(
                              onTap: model.path == "/" ? null : model.back(),
                              child: Container(
                                height: screenSize.size.height / 10 * 0.5,
                                padding: EdgeInsets.all(5),
                                child: FittedBox(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        MdiIcons.arrowLeft,
                                        color: theme.colors.neutral.shade400,
                                      ),
                                      Text("Retour",
                                          style: TextStyle(
                                            fontFamily: "Asap",
                                            fontSize: 15,
                                            color: theme.colors.neutral.shade400,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: refreshWorkspacesList,
                          child: Builder(builder: (context) {
                            if (!model.loading) {
                              if (model.path == "/") {
                                return WorkSpacesList(
                                  controller: model,
                                );
                              } else {
                                return CloudFilesList();
                              }
                              /*
                              return YShadowScrollContainer(
                                color: Theme.of(context).backgroundColor,
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      addRepaintBoundaries: false,
                                      itemCount: localFoldersList!.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            //Separator
                                            if (model.path == "/" &&
                                                index != 0 &&
                                                localFoldersList![index - 1].isMemberOf != null &&
                                                localFoldersList![index].isMemberOf != null &&
                                                index != localFoldersList!.length - 1 &&
                                                localFoldersList![index - 1].isMemberOf! &&
                                                !localFoldersList![index].isMemberOf!)
                                              Row(children: <Widget>[
                                                Expanded(
                                                  child: new Container(
                                                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                                      child: Divider(
                                                        color: ThemeUtils.textColor(),
                                                        height: 36,
                                                      )),
                                                ),
                                                Text(
                                                  "Autres clouds",
                                                  style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
                                                ),
                                                Expanded(
                                                  child: new Container(
                                                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                                                      child: Divider(
                                                        color: ThemeUtils.textColor(),
                                                        height: 36,
                                                      )),
                                                ),
                                              ]),
                                            //Item builder
                                            ViewModelBuilder<DownloadController>.reactive(
                                                viewModelBuilder: () => DownloadController(),
                                                builder: (context, downloadModel, child) {
                                                  return Material(
                                                    color: Theme.of(context).primaryColor,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        model.changeFolder(localFoldersList![index]);
                                                        /*if (localFoldersList![index].type == "FOLDER") {
                                                              if (model.path == "/") {
                                                                cloudUsedFolder = localFoldersList![index].id;
                                                              }
                                                              setState(() {
                                                                model.path += localFoldersList![index].title! + "/";
                                                              });
                                                              changeDirectory(localFoldersList![index]);
                                                            }*/
                                                        if (localFoldersList![index].type == "FILE") {
                                                          if (await downloadModel
                                                              .fileExists(localFoldersList![index].title)) {
                                                            await FileAppUtil.openFile(localFoldersList![index].title,
                                                                usingFileName: true);
                                                          } else {
                                                            downloadModel.download(Document(
                                                                documentName: localFoldersList![index].title,
                                                                id: localFoldersList![index].id,
                                                                type: "CLOUD",
                                                                length: 0));
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: screenSize.size.height / 10 * 0.1),
                                                        margin: EdgeInsets.all(0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            FutureBuilder<bool>(
                                                                future: downloadModel
                                                                    .fileExists(localFoldersList![index].title),
                                                                initialData: false,
                                                                builder: (context, snapshot) {
                                                                  return Container(
                                                                    margin: EdgeInsets.only(
                                                                        left: screenSize.size.width / 5 * 0.2),
                                                                    child: Icon(
                                                                      (localFoldersList![index].type == "FOLDER")
                                                                          ? MdiIcons.folder
                                                                          : (snapshot.data! ||
                                                                                  downloadModel.downloadProgress == 100
                                                                              ? MdiIcons.fileCheck
                                                                              : MdiIcons.file),
                                                                      color:
                                                                          ((localFoldersList![index].type == "FOLDER")
                                                                              ? Colors.yellow.shade600
                                                                              : ThemeUtils.isThemeDark
                                                                                  ? Colors.grey.shade300
                                                                                  : Colors.grey.shade400),
                                                                    ),
                                                                  );
                                                                }),
                                                            Expanded(
                                                              child: Container(
                                                                margin: EdgeInsets.only(
                                                                    left: screenSize.size.width / 5 * 0.1),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Container(
                                                                      child: Text(
                                                                        localFoldersList![index].title!,
                                                                        textAlign: TextAlign.start,
                                                                        style: TextStyle(
                                                                          fontFamily: "Asap",
                                                                          fontSize: screenSize.size.height / 10 * 0.25,
                                                                          color: ThemeUtils.textColor(),
                                                                        ),
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    if (localFoldersList![index].author != "")
                                                                      Text(
                                                                        localFoldersList![index].author!,
                                                                        textAlign: TextAlign.start,
                                                                        style: TextStyle(
                                                                          fontFamily: "Asap",
                                                                          fontSize: screenSize.size.height / 10 * 0.2,
                                                                          color: ThemeUtils.isThemeDark
                                                                              ? Colors.white60
                                                                              : Colors.black87,
                                                                        ),
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    if (localFoldersList![index].date != null)
                                                                      Row(
                                                                        children: <Widget>[
                                                                          Text(
                                                                            localFoldersList![index].date.toString(),
                                                                            textAlign: TextAlign.start,
                                                                            style: TextStyle(
                                                                              fontFamily: "Asap",
                                                                              fontSize:
                                                                                  screenSize.size.height / 10 * 0.2,
                                                                              color: ThemeUtils.isThemeDark
                                                                                  ? Colors.white38
                                                                                  : Colors.black38,
                                                                            ),
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),

                                                                    //File downloading
                                                                    if (downloadModel.isDownloading &&
                                                                        downloadModel.downloadProgress != null &&
                                                                        downloadModel.downloadProgress < 100)
                                                                      Container(
                                                                          width: screenSize.size.width / 5 * 4,
                                                                          child: LinearProgressIndicator(
                                                                            value: downloadModel.downloadProgress,
                                                                          ))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                            Container(
                                              child: Divider(
                                                color: Colors.black45,
                                                height: screenSize.size.height / 10 * 0.005,
                                                thickness: screenSize.size.height / 10 * 0.005,
                                              ),
                                            )
                                          ],
                                        );
                                      })
                                ],
                              );*/
                            } else {
                              return Center(
                                child: CustomLoader(screenSize.size.width / 10 * 1.8, screenSize.size.width / 5 * 2.5,
                                    Theme.of(context).primaryColorDark),
                              );
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ));
  }

  //Change directory action
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
          refreshWorkspacesList();
        }));
  }

  Future<void> refreshWorkspacesList() async {
    await appSys.workspacesController.refresh(force: true);
  }
}
