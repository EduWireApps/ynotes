import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:ynotes/core/apis/ecole_directe.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/shared/download_controller.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/ui/components/custom_loader.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'package:ynotes_packages/components.dart';

var actualSort = sortValue.date;

Future<List<CloudItem>?>? cloudFolderFuture;

String? cloudUsedFolder = "";

String dossier = "Reçus";
bool isLoading = false;
List<CloudItem>? localFoldersList;
String path = "/";
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

class CloudPage extends StatefulWidget {
  const CloudPage({Key? key}) : super(key: key);

  State<StatefulWidget> createState() {
    return _CloudPageState();
  }
}

enum sortValue { date, reversed_date, author }

//Sort in the main page
class _CloudPageState extends State<CloudPage> with LayoutMixin {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return YPage(
        title: "Cloud",
        isScrollable: false,
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedContainer(
                margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                duration: Duration(milliseconds: 250),
                height: screenSize.size.height / 10 * 0.5,
                width: screenSize.size.width,
                child: Opacity(
                  opacity: path == "/" ? 0.4 : 1,
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColorDark,
                    child: InkWell(
                      onTap: path == "/"
                          ? null
                          : () {
                              if (path != "/") {
                                var splits = path.split("/");
                                CustomLogger.log("CLOUD", "Splits length: ${splits.length}");
                                if (splits.length > 2) {
                                  var finalList = splits.sublist(1, splits.length - 2);
                                  var concatenate = StringBuffer();

                                  finalList.forEach((item) {
                                    concatenate.write(r'/' + item);
                                  });
                                  CustomLogger.log("CLOUD", "Concatenate: $concatenate");
                                  setState(() {
                                    path = concatenate.toString() + '/';
                                  });
                                } else {
                                  setState(() {
                                    path = "/";
                                  });
                                }
                                changeDirectory(null);
                              }
                            },
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
                                color: ThemeUtils.textColor(),
                              ),
                              Text("Retour",
                                  style: TextStyle(
                                    fontFamily: "Asap",
                                    fontSize: 15,
                                    color: ThemeUtils.textColor(),
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
                  onRefresh: refreshLocalCloudItemsList,
                  child: FutureBuilder<List<CloudItem>?>(
                      future: cloudFolderFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                          localFoldersList = snapshot.data;
                          if (path == "/" && isLoading == false) {
                            localFoldersList = sortByGroupMainPage(localFoldersList!);
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: YShadowScrollContainer(
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
                                          if (path == "/" &&
                                              isLoading == false &&
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
                                              builder: (context, model, child) {
                                                return Material(
                                                  color: Theme.of(context).primaryColor,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      if (localFoldersList![index].type == "FOLDER") {
                                                        if (path == "/") {
                                                          cloudUsedFolder = localFoldersList![index].id;
                                                        }
                                                        setState(() {
                                                          path += localFoldersList![index].title! + "/";
                                                        });
                                                        changeDirectory(localFoldersList![index]);
                                                      }
                                                      if (localFoldersList![index].type == "FILE") {
                                                        if (await model.fileExists(localFoldersList![index].title)) {
                                                          await FileAppUtil.openFile(localFoldersList![index].title,
                                                              usingFileName: true);
                                                        } else {
                                                          model.download(Document(
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
                                                              future: model.fileExists(localFoldersList![index].title),
                                                              initialData: false,
                                                              builder: (context, snapshot) {
                                                                return Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: screenSize.size.width / 5 * 0.2),
                                                                  child: Icon(
                                                                    (localFoldersList![index].type == "FOLDER")
                                                                        ? MdiIcons.folder
                                                                        : (snapshot.data! ||
                                                                                model.downloadProgress == 100
                                                                            ? MdiIcons.fileCheck
                                                                            : MdiIcons.file),
                                                                    color: ((localFoldersList![index].type == "FOLDER")
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
                                                                            fontSize: screenSize.size.height / 10 * 0.2,
                                                                            color: ThemeUtils.isThemeDark
                                                                                ? Colors.white38
                                                                                : Colors.black38,
                                                                          ),
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ],
                                                                    ),

                                                                  //File downloading
                                                                  if (model.isDownloading &&
                                                                      model.downloadProgress != null &&
                                                                      model.downloadProgress < 100)
                                                                    Container(
                                                                        width: screenSize.size.width / 5 * 4,
                                                                        child: LinearProgressIndicator(
                                                                          value: model.downloadProgress,
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
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Une erreur a eu lieu",
                                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
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
                                      refreshLocalCloudItemsList();
                                    },
                                    child: !(snapshot.connectionState == ConnectionState.waiting)
                                        ? Text("Recharger",
                                            style: TextStyle(
                                              fontFamily: "Asap",
                                              color: ThemeUtils.textColor(),
                                            ))
                                        : FittedBox(
                                            child: SpinKitThreeBounce(
                                                color: Theme.of(context).primaryColorDark,
                                                size: screenSize.size.height / 10 * 1.8)),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: CustomLoader(screenSize.size.width / 10 * 1.8, screenSize.size.width / 5 * 2.5,
                                Theme.of(context).primaryColorDark),
                          );
                        }
                      }),
                ),
              ),
              if (isLoading)
                SpinKitFadingFour(
                  color: Colors.white60,
                  size: screenSize.size.width / 5 * 0.7,
                ),
            ],
          ),
        ));
  }

  changeDirectory(CloudItem? item) async {
    CustomLogger.log("CLOUD", "New path: $path");
    setState(() {
      cloudFolderFuture = getCloud(path, "CD", item);
      isLoading = true;
    });
    await cloudFolderFuture;
    isLoading = false;
  }

  //Change directory action
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
          refreshLocalCloudItemsList();
        }));
  }

  Future<void> refreshLocalCloudItemsList() async {
    setState(() {
      cloudFolderFuture = getCloud(path, "CD", null);

      isLoading = true;
    });
    await cloudFolderFuture;
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }
}
