import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/fileUtils.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

// ignore: must_be_immutable
class FolderChoiceDialog extends StatefulWidget {
  BuildContext context;
  String path;
  List<FileInfo>? files = [];
  bool selectionMode;
  Function callback;
  FolderChoiceDialog(this.context, this.path, this.files, this.selectionMode, this.callback);

  @override
  _FolderChoiceDialogState createState() => _FolderChoiceDialogState();
}
// ignore: must_be_immutable

class _FolderChoiceDialogState extends State<FolderChoiceDialog> {
  TextEditingController textController = TextEditingController(text: "");

  String? value = "";
  String? dropDownValue = "Aucun";
  List<String?> folderNames = [];
  List<FileInfo> filesToMove = [];
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return AlertDialog(
      elevation: 50,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(
        "Création de dossier",
        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: Container(
          height: widget.selectionMode ? screenSize.size.height / 10 * 2.5 : screenSize.size.height / 10 * 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "Donnez un nom à ce dossier",
                  style: TextStyle(fontFamily: 'Asap', color: ThemeUtils.textColor()),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                width: screenSize.size.width / 5 * 4.3,
                height: screenSize.size.height / 10 * 0.8,
                child: TextFormField(
                  controller: textController,
                  onChanged: (newValue) {
                    setState(() {
                      value = newValue;
                      if (folderNames.contains(newValue)) {
                        dropDownValue = newValue;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ThemeUtils.textColor()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ThemeUtils.textColor()),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Asap',
                    color: ThemeUtils.textColor(),
                  ),
                ),
              ),
              if (widget.selectionMode)
                Container(
                  child: Text(
                    "Utiliser un dossier existant",
                    style: TextStyle(fontFamily: 'Asap', color: ThemeUtils.textColor()),
                    textAlign: TextAlign.left,
                  ),
                ),
              if (widget.selectionMode)
                Container(
                  width: screenSize.size.width / 5 * 4.3,
                  child: DropdownButton<String>(
                    value: dropDownValue,
                    dropdownColor: Theme.of(context).primaryColor,
                    style: TextStyle(color: ThemeUtils.textColor()),
                    icon: null,
                    iconSize: 0,
                    underline: Container(
                      height: screenSize.size.height / 10 * 0.02,
                      color: ThemeUtils.textColor(),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue;
                        if (newValue != "Aucun") {
                          value = newValue;
                          textController.text = newValue!;
                        }
                      });
                    },
                    items: folderNames.map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value ?? "",
                        child: Text(
                          value ?? "",
                          style: TextStyle(fontFamily: 'Asap', color: ThemeUtils.textColor()),
                        ),
                      );
                    }).toList(),
                  ),
                )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('ANNULER', style: TextStyle(color: Colors.red), textScaleFactor: 1.0),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: Text(
            dropDownValue != "Aucun" ? "DÉPLACER" : "CRÉER",
            style: TextStyle(color: Colors.green),
            textScaleFactor: 1.0,
          ),
          onPressed: () async {
            if (widget.selectionMode) {
              await Future.forEach(filesToMove, (dynamic element) async {
                try {
                  await element.element.copy(widget.path +
                      "/" +
                      value! +
                      '/' +
                      element.fileName +
                      ((element.element is Directory) ? "/" : ""));
                  await element.element.delete(recursive: true);
                } catch (e) {
                  if (Platform.isAndroid) {
                    print("Trying with commandlines");
                    await Process.run('cp', ['-r', element.element.path, widget.path + "/" + value!]);
                    await element.element.delete(recursive: true);
                  }
                }
              });
            } else {
              await FolderAppUtil.createDirectory(widget.path + "/" + value! + "/");
            }
            await widget.callback();
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    List<FileInfo> folderList = [];
    if (widget.files != null) {
      folderList = widget.files!.where((element) => element.element is Directory).toList();

      filesToMove = widget.files!.where((element) => element.selected).toList();
    }

    folderNames.add("Aucun");

    folderList.forEach((element) {
      folderNames.add(element.fileName);
    });
    // set up the AlertDialog
  }
}
