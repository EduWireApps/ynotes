import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/shared/downloadController.dart';
import 'package:ynotes/core/utils/fileUtils.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/customLoader.dart';

import '../../../main.dart';
import '../../../usefulMethods.dart';

String cloudUsedFolder = "";

class CloudPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CloudPageState();
  }
}

Future cloudFolderFuture;

String dossier = "Reçus";
enum sortValue { date, reversed_date, author }
bool isLoading = false;
var actualSort = sortValue.date;
List<CloudItem> localFoldersList;
String path = "/";

class _CloudPageState extends State<CloudPage> {
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          refreshLocalCloudItemsList();
        }));
  }

  Future<void> refreshLocalCloudItemsList() async {
    setState(() {
      cloudFolderFuture = appSys.api.app("cloud", args: path, action: "CD");
      isLoading = true;
    });
    var realdisciplinesListFuture = await cloudFolderFuture;
    setState(() {
      isLoading = false;
    });
  }

  //Change directory action
  changeDirectory(CloudItem item) async {
    print(path);
    setState(() {
      cloudFolderFuture = appSys.api.app("cloud", args: path, action: "CD", folder: item);
      isLoading = true;
    });
    var realdisciplinesListFuture = await cloudFolderFuture;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      height: screenSize.size.height,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                        duration: Duration(milliseconds: 250),
                        height: screenSize.size.height / 10 * 0.5,
                        width: screenSize.size.width,
                        child: Opacity(
                          opacity: path == "/" ? 0.4 : 1,
                          child: Material(
                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                            color: Theme.of(context).primaryColorDark,
                            child: InkWell(
                              onTap: path == "/"
                                  ? null
                                  : () {
                                      if (path != "/") {
                                        var splits = path.split("/");
                                        print(splits.length);
                                        if (splits.length > 2) {
                                          var finalList = splits.sublist(1, splits.length - 2);
                                          var concatenate = StringBuffer();

                                          finalList.forEach((item) {
                                            concatenate.write(r'/' + item);
                                          });
                                          print(concatenate);
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
                                padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
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
                      Container(
                        margin: EdgeInsets.only(
                          top: screenSize.size.height / 10 * 0.2,
                        ),
                        height: screenSize.size.height / 10 * 8.3,
                        child: RefreshIndicator(
                          onRefresh: refreshLocalCloudItemsList,
                          child: FutureBuilder(
                              future: cloudFolderFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                  localFoldersList = snapshot.data;
                                  if (path == "/" && isLoading == false) {
                                    localFoldersList = sortByGroupMainPage(localFoldersList);
                                  }

                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child: ListView.builder(
                                          addRepaintBoundaries: false,
                                          itemCount: localFoldersList.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                //Separator
                                                if (path == "/" &&
                                                    isLoading == false &&
                                                    index != 0 &&
                                                    localFoldersList[index - 1].isMemberOf != null &&
                                                    localFoldersList[index].isMemberOf != null &&
                                                    index != localFoldersList.length - 1 &&
                                                    localFoldersList[index - 1].isMemberOf &&
                                                    !localFoldersList[index].isMemberOf)
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
                                                      style:
                                                          TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
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
                                                            if (localFoldersList[index].type == "FOLDER") {
                                                              if (path == "/") {
                                                                cloudUsedFolder = localFoldersList[index].id;
                                                              }
                                                              setState(() {
                                                                path += localFoldersList[index].title + "/";
                                                              });
                                                              changeDirectory(localFoldersList[index]);
                                                            }
                                                            if (localFoldersList[index].type == "FILE") {
                                                              if (await model
                                                                  .fileExists(localFoldersList[index].title)) {
                                                                await FileAppUtil.openFile(
                                                                    localFoldersList[index].title,
                                                                    usingFileName: true);
                                                              } else {
                                                                model.download(Document(localFoldersList[index].title,
                                                                    localFoldersList[index].id, "CLOUD", 0));
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(
                                                                vertical: screenSize.size.height / 10 * 0.1),
                                                            margin: EdgeInsets.all(0),
                                                            child: Row(
                                                              children: <Widget>[
                                                                FutureBuilder(
                                                                    future:
                                                                        model.fileExists(localFoldersList[index].title),
                                                                    initialData: false,
                                                                    builder: (context, snapshot) {
                                                                      return Container(
                                                                        margin: EdgeInsets.only(
                                                                            left: screenSize.size.width / 5 * 0.2),
                                                                        child: Icon(
                                                                          (localFoldersList[index].type == "FOLDER")
                                                                              ? MdiIcons.folder
                                                                              : (snapshot.data ||
                                                                                      model.downloadProgress == 100
                                                                                  ? MdiIcons.fileCheck
                                                                                  : MdiIcons.file),
                                                                          color: ((localFoldersList[index].type ==
                                                                                  "FOLDER")
                                                                              ? Colors.yellow.shade600
                                                                              : ThemeUtils.isThemeDark
                                                                                  ? Colors.grey.shade300
                                                                                  : Colors.grey.shade400),
                                                                        ),
                                                                      );
                                                                    }),
                                                                Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: screenSize.size.width / 5 * 0.4),
                                                                  width: screenSize.size.width / 5 * 4,
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Container(
                                                                        child: Text(
                                                                          localFoldersList[index].title,
                                                                          textAlign: TextAlign.start,
                                                                          style: TextStyle(
                                                                            fontFamily: "Asap",
                                                                            fontSize:
                                                                                screenSize.size.height / 10 * 0.25,
                                                                            color: ThemeUtils.textColor(),
                                                                          ),
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                      if (localFoldersList[index].author != "")
                                                                        Text(
                                                                          localFoldersList[index].author,
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
                                                                      if (localFoldersList[index].date != null)
                                                                        Row(
                                                                          children: <Widget>[
                                                                            Text(
                                                                              localFoldersList[index].date.toString(),
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
                                          }),
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
                                        FlatButton(
                                          onPressed: () {
                                            //Reload list
                                            refreshLocalCloudItemsList();
                                          },
                                          child: Text("Recharger",
                                              style: TextStyle(
                                                fontFamily: "Asap",
                                                color: ThemeUtils.textColor(),
                                              )),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(18.0),
                                              side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: CustomLoader(screenSize.size.width / 5 * 2.5,
                                        screenSize.size.width / 5 * 2.5, Theme.of(context).primaryColorDark),
                                  );
                                }
                              }),
                        ),
                      ),
                      if (isLoading)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15), color: Colors.black.withOpacity(0.4)),
                          margin: EdgeInsets.only(
                            top: screenSize.size.height / 10 * 1.35,
                          ),
                          height: screenSize.size.height / 10 * 7,
                          child: SpinKitFadingFour(
                            color: Colors.white60,
                            size: screenSize.size.width / 5 * 0.7,
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Sort in the main page
sortByGroupMainPage(List<CloudItem> list) {
  List<CloudItem> toReturn = List();
  //Make two groups of member of and not member of

  list.forEach((element) {
    if (element.isMemberOf != null && element.isMemberOf) {
      toReturn.add(element);
    }
  });
  list.forEach((element) {
    if (element.isMemberOf == null || !element.isMemberOf) {
      toReturn.add(element);
    }
  });
  return toReturn;
}
