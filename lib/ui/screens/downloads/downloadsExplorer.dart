import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart' as pathPackage;
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/core/utils/fileUtils.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/usefulMethods.dart';

Future<List<FileInfo>>? filesListFuture;

List<FileInfo> selectedFiles = [];
bool selectionMode = false;

class DownloadsExplorer extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldState;

  const DownloadsExplorer({Key? key, required this.parentScaffoldState}) : super(key: key);

  @override
  _DownloadsExplorerState createState() => _DownloadsExplorerState();
}

enum explorerSortValue { date, reversed_date, name }

class _DownloadsExplorerState extends State<DownloadsExplorer> {
  String path = "";
  String? initialPath = "";
  var actualSort = explorerSortValue.date;
  List<FileInfo> clipboard = [];

  List<FileInfo>? listFiles;
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Scaffold(
      appBar: new AppBar(
          title: new Text(
            "Fichiers",
            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
          ),
          leading: TextButton(
            style: TextButton.styleFrom(primary: Colors.transparent),
            child: Icon(MdiIcons.menu, color: ThemeUtils.textColor()),
            onPressed: () async {
              widget.parentScaffoldState.currentState?.openDrawer();
            },
          ),
          backgroundColor: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        width: screenSize.size.width,
        child: Column(
          children: <Widget>[
            SizedBox(
              child: Container(
                height: screenSize.size.height / 10 * 0.5,
                margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                width: screenSize.size.width,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: (initialPath ?? "") + path == initialPath
                            ? Container()
                            : Container(
                                key: ValueKey<bool>(selectionMode),
                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2),
                                child: Material(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                    onTap: () async {
                                      if ((initialPath ?? "") + path != initialPath) {
                                        var splits = path.split("/");
                                        print(splits.length);
                                        if (splits.length > 1) {
                                          var finalList = splits.sublist(1, splits.length - 1);
                                          var concatenate = StringBuffer();

                                          finalList.forEach((item) {
                                            concatenate.write(r'/' + item);
                                          });

                                          setState(() {
                                            path = concatenate.toString();
                                          });
                                          if (path == initialPath) {
                                            await getInitialPath();
                                          }

                                          await refreshFileListFuture();
                                        } else {
                                          setState(() {
                                            path = "";
                                          });

                                          await refreshFileListFuture();
                                        }
                                        listFiles ??
                                            [].forEach((element) {
                                              setState(() {
                                                element.selected = false;
                                              });
                                            });
                                        await refreshFileListFuture();
                                      }
                                    },
                                    child: Container(
                                        height: screenSize.size.height / 10 * 0.5,
                                        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.arrowLeft,
                                                color: ThemeUtils.textColor(),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                      ),
                      //Cancel selection mode button
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: !selectionMode
                            ? Container()
                            : Container(
                                key: ValueKey<bool>(selectionMode),
                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                child: Material(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                    onTap: () async {
                                      setState(() {
                                        selectionMode = false;
                                      });
                                      listFiles ??
                                          [].forEach((element) {
                                            setState(() {
                                              element.selected = false;
                                            });
                                          });
                                      await refreshFileListFuture();
                                    },
                                    child: Container(
                                        height: screenSize.size.height / 10 * 0.5,
                                        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.cancel,
                                                color: ThemeUtils.textColor(),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                      ),

                      //New folder button
                      Container(
                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                        child: Material(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                            onTap: () async {
                              CustomDialogs.showNewFolderDialog(
                                  context, (initialPath ?? "") + path, listFiles, selectionMode, refreshFileListFuture);

                              await refreshFileListFuture();
                            },
                            child: Container(
                                height: screenSize.size.height / 10 * 0.5,
                                padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.folder,
                                        color: Colors.yellow.shade200,
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),

                      //Rename button
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: (listFiles == null || listFiles!.where((element) => element.selected).length != 1)
                            ? Container()
                            : Container(
                                key: ValueKey<List?>(listFiles),
                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                child: Material(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                    onTap: () async {
                                      String? newName = await CustomDialogs.showTextChoiceDialog(context,
                                          text: "un nom pour l'élément",
                                          defaultText: await FileAppUtil.getFileNameWithExtension(
                                              listFiles!.firstWhere((element) => element.selected).element));
                                      if (newName != null) {
                                        String dir = pathPackage
                                            .dirname(listFiles!.firstWhere((element) => element.selected).element.path);
                                        String newPath = pathPackage.join(dir, newName);
                                        await listFiles!
                                            .firstWhere((element) => element.selected)
                                            .element
                                            .rename(newPath);
                                      }
                                      listFiles!.forEach((element) {
                                        setState(() {
                                          element.selected = false;
                                        });
                                      });
                                      await refreshFileListFuture();
                                    },
                                    child: Container(
                                        height: screenSize.size.height / 10 * 0.5,
                                        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.cursorText,
                                                color: ThemeUtils.textColor(),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                      ), //Sort button / bin button
                      Container(
                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                        child: Material(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                            onTap: () async {
                              if (selectionMode) {
                                bool response = await (CustomDialogs.showConfirmationDialog(context, null)) ?? false;
                                if (response) {
                                  await Future.forEach(listFiles!.where((element) => element.selected),
                                      (dynamic fileinfo) async {
                                    await FileAppUtil.remove(fileinfo.element);
                                  });
                                  await refreshFileListFuture();
                                }
                              } else {
                                setState(() {
                                  if ((explorerSortValue.values.indexOf(actualSort) + 1) <=
                                      explorerSortValue.values.length - 1) {
                                    actualSort =
                                        explorerSortValue.values[explorerSortValue.values.indexOf(actualSort) + 1];
                                  } else {
                                    actualSort = explorerSortValue.values[0];
                                  }
                                });
                                sortList();
                              }
                            },
                            child: Container(
                                height: screenSize.size.height / 10 * 0.5,
                                padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 200),
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          return ScaleTransition(child: child, scale: animation);
                                        },
                                        child: selectionMode
                                            ? Icon(
                                                Icons.delete,
                                                key: ValueKey<bool>(selectionMode),
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                case2(actualSort, {
                                                  explorerSortValue.date: MdiIcons.sortClockAscending,
                                                  explorerSortValue.reversed_date: MdiIcons.sortClockDescending,
                                                  explorerSortValue.name: MdiIcons.sortAlphabeticalAscending,
                                                }),
                                                color: ThemeUtils.textColor(),
                                              ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),

                      //Copy to clipboard button
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: !selectionMode
                            ? Container()
                            : Container(
                                key: ValueKey<bool>(selectionMode),
                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                child: Material(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                    onTap: () {
                                      setState(() {
                                        clipboard.clear();
                                        clipboard.addAll((listFiles ?? []).where((element) => element.selected));
                                      });
                                    },
                                    child: Container(
                                        height: screenSize.size.height / 10 * 0.5,
                                        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.content_copy,
                                                color: ThemeUtils.textColor(),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                      ),
                      //Past to clipboard button
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: Container(
                          key: ValueKey<bool>(selectionMode),
                          margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                          child: Material(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                              onTap: !(clipboard.length > 0)
                                  ? null
                                  : () async {
                                      await Future.forEach(clipboard, (FileInfo element) async {
                                        try {
                                          await element.element
                                              .copy((initialPath ?? "") + path + "/" + (element.fileName ?? ""));
                                        } catch (e) {
                                          print(e);
                                          if (Platform.isAndroid) {
                                            print("try to paste");
                                            var result = await Process.run(
                                                'cp', ['-r', element.element.path, (initialPath ?? "") + path + "/"]);
                                            print(result.stdout);
                                          }
                                        }
                                      });

                                      await refreshFileListFuture();
                                    },
                              child: Container(
                                  height: screenSize.size.height / 10 * 0.5,
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Opacity(
                                          opacity: clipboard.length > 0 ? 1.0 : 0.6,
                                          child: Icon(
                                            MdiIcons.contentPaste,
                                            color: ThemeUtils.textColor(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
              child: Divider(
                thickness: screenSize.size.height / 10 * 0.02,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<FileInfo>>(
                future: filesListFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if ((snapshot.data ?? []).length != 0) {
                      listFiles = snapshot.data;
                      return Container(
                        child: RefreshIndicator(
                          onRefresh: refreshFileListFuture,
                          child: ListView.builder(
                            padding: EdgeInsets.all(0.0),
                            itemCount: listFiles!.length,
                            itemBuilder: (context, index) {
                              final item = listFiles![index].fileName!;
                              return Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(color: Colors.red),
                                confirmDismiss: (direction) async {
                                  setState(() {});
                                  return await CustomDialogs.showConfirmationDialog(context, null) == true;
                                },
                                onDismissed: (direction) async {
                                  await FileAppUtil.remove(listFiles![index].element);

                                  setState(() {
                                    listFiles!.removeAt(index);
                                  });
                                },
                                key: Key(item),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      ConstrainedBox(
                                        constraints: new BoxConstraints(
                                          minHeight: screenSize.size.height / 10 * 0.8,
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: (screenSize.size.height / 10 * 0.008)),
                                          child: Material(
                                            color: listFiles![index].selected
                                                ? Colors.blue
                                                : Theme.of(context).primaryColorDark,
                                            child: InkWell(
                                              splashColor: Color(0xff525252),
                                              onLongPress: () {
                                                setState(() {
                                                  selectionMode = true;
                                                  listFiles![index].selected = true;
                                                });
                                              },
                                              onTap: () async {
                                                if (selectionMode) {
                                                  print(selectedFiles.length);
                                                  listFiles![index].selected = !listFiles![index].selected;
                                                  setState(() {});
                                                } else {
                                                  if (listFiles![index].element is Directory) {
                                                    setState(() {
                                                      path = path + "/" + listFiles![index].fileName!;
                                                    });
                                                    await refreshFileListFuture();
                                                  } else {
                                                    await FileAppUtil.openFile(listFiles![index].element.path);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: screenSize.size.width / 5 * 0.25,
                                                    vertical: screenSize.size.height / 10 * 0.2),
                                                child: Container(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      Icon(
                                                        (listFiles![index].element is Directory)
                                                            ? MdiIcons.folder
                                                            : MdiIcons.file,
                                                        color: (listFiles![index].element is Directory)
                                                            ? Colors.yellow.shade100
                                                            : ThemeUtils.textColor().withOpacity(0.5),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            width: screenSize.size.width / 5 * 3.25,
                                                            child: Text(
                                                              (snapshot.data ?? [])[index].fileName ?? "",
                                                              style: TextStyle(
                                                                  fontFamily: "Asap",
                                                                  fontSize: screenSize.size.height / 10 * 0.2,
                                                                  color: ThemeUtils.textColor()),
                                                            ),
                                                          ),
                                                          if ((snapshot.data ?? [])[index].lastModifiedDate != null)
                                                            FittedBox(
                                                              child: Text(
                                                                DateFormat("yyyy-MM-dd HH:mm").format(
                                                                    (snapshot.data ?? [])[index].lastModifiedDate!),
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(
                                                                    fontFamily: "Asap",
                                                                    fontSize: screenSize.size.height / 10 * 0.2,
                                                                    color: ThemeUtils.isThemeDark
                                                                        ? Colors.white.withOpacity(0.5)
                                                                        : Colors.black.withOpacity(0.5)),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: screenSize.size.height / 10 * 7.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: screenSize.size.height / 10 * 1.2),
                              child: FittedBox(
                                child: Icon(
                                  MdiIcons.downloadOffOutline,
                                  color: ThemeUtils.textColor(),
                                  size: screenSize.size.width / 5 * 1.5,
                                ),
                              ),
                            ),
                            Text(
                              "Aucun élément.",
                              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 15),
                            )
                          ],
                        ),
                      );
                    }
                  } else {
                    if (snapshot.hasError) {
                      print("Erreur " + (snapshot.error as String));
                    }
                    return SpinKitFadingFour(
                      color: Theme.of(context).primaryColorDark,
                      size: screenSize.size.width / 5 * 1,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getInitialPath() async {
    var a = await FolderAppUtil.getDirectory(download: true);
    setState(() {
      initialPath = a + "/yNotesDownloads";
      path = "";
    });
    await refreshFileListFuture();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) => mounted
        ? setState(() {
            getInitialPath();
          })
        : null);
    sortList();
    setState(() {
      actualSort = explorerSortValue.date;
    });
  }

  Future<void> refreshFileListFuture() async {
    if (Platform.isLinux || await Permission.storage.request().isGranted) {
      selectionMode = false;
      setState(() {
        filesListFuture = FileAppUtil.getFilesList(initialPath! + path);
      });
      await filesListFuture;
      sortList();
    }
  }

  sortList() {
    if (listFiles != null) {
      switch (actualSort) {
        case explorerSortValue.name:
          setState(() {
            (listFiles ?? []).sort((a, b) => (a.fileName!.toLowerCase()).compareTo(b.fileName!.toLowerCase()));
          });

          break;
        case explorerSortValue.date:
          setState(() {
            try {
              (listFiles ?? []).sort((a, b) {
                if (a.lastModifiedDate != null && b.lastModifiedDate != null) {
                  return a.lastModifiedDate!.compareTo(b.lastModifiedDate!);
                } else {
                  return 0;
                }
              });
            } catch (e) {
              print(e);
            }
          });

          break;
        case explorerSortValue.reversed_date:
          setState(() {
            try {
              (listFiles ?? []).sort((a, b) {
                if (a.lastModifiedDate != null && b.lastModifiedDate != null) {
                  return b.lastModifiedDate!.compareTo(a.lastModifiedDate!);
                } else {
                  return 0;
                }
              });
            } catch (e) {}
          });

          break;
      }
    }
  }
}
