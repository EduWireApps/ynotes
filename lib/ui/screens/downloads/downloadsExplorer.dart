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
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes_components/ynotes_components.dart';

Future<List<FileInfo>>? filesListFuture;

List<FileInfo> selectedFiles = [];
bool selectionMode = false;

class DownloadsExplorer extends StatefulWidget {
  const DownloadsExplorer({Key? key}) : super(key: key);

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

  Widget _actionButton(BuildContext context, List<Widget> children, VoidCallback onTap) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      key: ValueKey<bool>(selectionMode),
      margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
        child: InkWell(
          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
          onTap: onTap,
          child: Container(
              height: screenSize.size.height / 10 * 0.5,
              padding: EdgeInsets.all(screenSize.size.width / 5 * 0.05),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return YPage(
      title: "Fichiers",
      isScrollable: false,
      body: Column(
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
                            : _actionButton(context, [
                                Icon(
                                  MdiIcons.arrowLeft,
                                  color: ThemeUtils.textColor(),
                                )
                              ], () async {
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
                              })),
                    //Cancel selection mode button
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: !selectionMode
                            ? Container()
                            : _actionButton(context, [
                                Icon(
                                  MdiIcons.cancel,
                                  color: ThemeUtils.textColor(),
                                )
                              ], () async {
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
                              })),

                    //New folder button
                    _actionButton(context, [
                      Icon(
                        Icons.folder,
                        color: Colors.yellow.shade200,
                      )
                    ], () async {
                      CustomDialogs.showNewFolderDialog(
                          context, (initialPath ?? "") + path, listFiles, selectionMode, refreshFileListFuture);
                      await refreshFileListFuture();
                    }),

                    //Rename button
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: (listFiles == null || listFiles!.where((element) => element.selected).length != 1)
                            ? Container()
                            : _actionButton(context, [
                                Icon(
                                  MdiIcons.cursorText,
                                  color: ThemeUtils.textColor(),
                                )
                              ], () async {
                                String? newName = await CustomDialogs.showTextChoiceDialog(context,
                                    text: "un nom pour l'élément",
                                    defaultText: await FileAppUtil.getFileNameWithExtension(
                                        listFiles!.firstWhere((element) => element.selected).element));
                                if (newName != null) {
                                  String dir = pathPackage
                                      .dirname(listFiles!.firstWhere((element) => element.selected).element.path);
                                  String newPath = pathPackage.join(dir, newName);
                                  await listFiles!.firstWhere((element) => element.selected).element.rename(newPath);
                                }
                                listFiles!.forEach((element) {
                                  setState(() {
                                    element.selected = false;
                                  });
                                });
                                await refreshFileListFuture();
                              })), //Sort button / bin button
                    _actionButton(context, [
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
                      )
                    ], () async {
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
                            actualSort = explorerSortValue.values[explorerSortValue.values.indexOf(actualSort) + 1];
                          } else {
                            actualSort = explorerSortValue.values[0];
                          }
                        });
                        sortList();
                      }
                    }),

                    //Copy to clipboard button
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: !selectionMode
                            ? Container()
                            : _actionButton(context, [
                                Icon(
                                  Icons.content_copy,
                                  color: ThemeUtils.textColor(),
                                )
                              ], () {
                                setState(() {
                                  clipboard.clear();
                                  clipboard.addAll((listFiles ?? []).where((element) => element.selected));
                                });
                              })),
                    //Past to clipboard button
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: _actionButton(context, [
                        Icon(
                          MdiIcons.contentPaste,
                          color: ThemeUtils.textColor(),
                        )
                      ], () async {
                        if (clipboard.length <= 0) {
                          return;
                        }
                        await Future.forEach(clipboard, (FileInfo element) async {
                          try {
                            await element.element.copy((initialPath ?? "") + path + "/" + (element.fileName ?? ""));
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
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenSize.size.height / 10 * 0.1,
          ),
          Expanded(
            child: FutureBuilder<List<FileInfo>>(
              future: filesListFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data ?? []).length != 0) {
                    listFiles = snapshot.data;
                    return RefreshIndicator(
                      onRefresh: refreshFileListFuture,
                      child: YShadowScrollContainer(
                        color: Theme.of(context).primaryColor,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
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
                                                : Theme.of(context).primaryColor,
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
                          )
                        ],
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
    if (await Permission.storage.request().isGranted) {
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
