import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/UI/components/giffy_dialog/src/asset.dart';
import '../../usefulMethods.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';

class CustomDialogs {
  static void showGiffyDialog(BuildContext context, HelpDialog hd) {
    PageController controller = PageController();
    var screenSize = MediaQuery.of(context);

    //Show a dialog with a gif
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset(hd.gifPath),
              title: Text(
                hd.title,
                style: TextStyle(
                    fontSize: screenSize.size.height / 10 * 0.3, fontWeight: FontWeight.w600),
                textScaleFactor: 1.0,
                textAlign: TextAlign.center,
              ),
              description: Text(hd.description[0],
                  style: TextStyle(fontSize: screenSize.size.height / 10 * 0.2)),
              buttonOkText: Text(
                "J'ai compris",
                style: TextStyle(fontFamily: "Asap", color: Colors.white),
                textScaleFactor: 1.0,
              ),
              buttonCancelText: Text(
                "Passer le tutoriel",
                style: TextStyle(fontFamily: "Asap", color: Colors.white),
                textScaleFactor: 1.0,
              ),
              onlyOkButton: false,
              onlyCancelButton: false,
              onCancelButtonPressed: () async {
                await hd.skipEveryHelpDialog();
                Navigator.pop(_);
              },
              onOkButtonPressed: () {
                Navigator.pop(_);
              },
            ));
  }

  static Future<bool> showConfirmationDialog(BuildContext context, Function show) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 50,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(
        "Confirmation",
        style:
            TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
      ),
      content: Text(
        "Voulez vous vraiment supprimer cet élément (irréversible) ?",
        style:
            TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
      ),
      actions: [
        FlatButton(
          child: const Text('ANNULER', style: TextStyle(color: Colors.green), textScaleFactor: 1.0),
          onPressed: () {
            if (show != null) {
              show();
            }

            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text(
            'SUPPRIMER',
            style: TextStyle(color: Colors.red),
            textScaleFactor: 1.0,
          ),
          onPressed: () {
            if (show != null) {
              show();
            }
            Navigator.pop(context, true);
          },
        )
      ],
    );

    // show the dialog
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<int> showNumberChoiceDialog(BuildContext context,
      {String text = ""}) {
    // show the dialog
    return showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return NumberChoice(text);
      },
    );
  }

  static Future<bool> showNewFolderDialog(BuildContext context, String path, List<FileInfo> files,
      bool selectionMode, Function callback) {
    // show the dialog
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return FolderChoiceWidget(context, path, files, selectionMode, callback);
      },
    );
  }

//Bêta purposes : show when a function is not available yet
  static showUnimplementedSnackBar(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.orange.shade200,
      isDismissible: true,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(8),
      messageText: Text(
        "Cette fonction n'est pas encore disponible pour le moment.",
        style: TextStyle(fontFamily: "Asap"),
      ),
      mainButton: FlatButton(
        onPressed: () {
          const url = 'https://view.monday.com/486453658-df7d6a346f0accba2e9d6a3c45b3f7c1';
          launchURL(url);
        },
        child: Text(
          "En savoir plus",
          style: TextStyle(color: Colors.blue, fontFamily: "Asap"),
        ),
      ),
      borderRadius: 8,
    )..show(context);
  }

  static showAnyDialog(BuildContext context, String text) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.green.shade200,
      isDismissible: true,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(8),
      messageText: Text(
        text,
        style: TextStyle(fontFamily: "Asap"),
      ),
      borderRadius: 8,
    )..show(context);
  }
}

//The help dialog class
class HelpDialog {
  final int id;
  final GlobalKey key;
  final String title;
  final List<String> description;
  final String gifPath;
  void showDialog(BuildContext context) async {
    //If the dialog has never been viewed
    if (!await checkAlreadyViewed()) {
      CustomDialogs.showGiffyDialog(context, this);
      //Set the dialog as viewed
      await this.setAlreadyViewed();
    }
  }

  ///Set if the dialog as already been watched
  setAlreadyViewed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("alreadyViewedHelpDialog" + this.id.toString(), true);
  }

  ///Check if the dialog as already been watched
  checkAlreadyViewed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool viewed = preferences.getBool("alreadyViewedHelpDialog" + this.id.toString());

    return viewed != null ? viewed : false;
  }

  ///Skip every dialogs (already seen)
  skipEveryHelpDialog() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    for (int i = 0; i < helpDialogs.length; i++) {
      await preferences.setBool("alreadyViewedHelpDialog" + i.toString(), true);
    }
  }

  ///Skip every dialogs (already seen)
  static resetEveryHelpDialog() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    for (int i = 0; i < helpDialogs.length; i++) {
      await preferences.setBool("alreadyViewedHelpDialog" + i.toString(), false);
    }
  }

  HelpDialog(this.title, this.description, this.gifPath, this.id, {this.key});
}

//Help dialogs list for the showcase
List<HelpDialog> helpDialogs = [
  HelpDialog(
      "Bienvenue !",
      [
        """Bienvenue sur yNotes ! Nous sommes très content de vous voir ici ! Ceci est une fenêtre de tutoriel, d'autres apparaitront pour vous montrer les nouveautés ou les fonctionnalités utiles de l'application. Vous les avez déjà vues ? Passez le tutoriel !"""
      ],
      "assets/gifs/Hello720.gif",
      0),
  HelpDialog(
      "QuickMenu",
      [
        "Glissez votre doigt vers le haut sur l'icone Space pour afficher un menu rapide.",
      ],
      "assets/gifs/QuickMenu720.gif",
      1),
  HelpDialog(
      "Épingler",
      ["Restez appuyé puis épinglez un devoir pour le revoir même après sa date d'échéance."],
      "assets/gifs/PinHomework720.gif",
      2),
  HelpDialog(
      "Nouvel explorateur de téléchargements",
      [
        "Nous avons mis à jour votre explorateur de téléchargements ! Idéal pour mieux organiser vos fiches ou documents.",
      ],
      "assets/gifs/FileExplorer720.gif",
      3)
];

class FolderChoiceWidget extends StatefulWidget {
  BuildContext context;
  String path;
  List<FileInfo> files = List();
  bool selectionMode;
  Function callback;
  FolderChoiceWidget(this.context, this.path, this.files, this.selectionMode, this.callback);

  @override
  _FolderChoiceWidgetState createState() => _FolderChoiceWidgetState();
}

class _FolderChoiceWidgetState extends State<FolderChoiceWidget> {
  TextEditingController textController = TextEditingController(text: "");

  String value = "";
  String dropDownValue = "Aucun";
  List<String> folderNames = List();
  List<FileInfo> filesToMove = List();
  @override
  void initState() {
    // TODO: implement initState
    List<FileInfo> folderList = List();
    if (widget.files != null) {
      folderList = widget.files.where((element) => element.element is Directory).toList();

      filesToMove = widget.files.where((element) => element.selected).toList();
    }

    folderNames.add("Aucun");

    folderList.forEach((element) {
      folderNames.add(element.fileName);
    });
    // set up the AlertDialog
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return AlertDialog(
      elevation: 50,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(
        "Création de dossier",
        style:
            TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
      ),
      content: Container(
        height: widget.selectionMode
            ? screenSize.size.height / 10 * 2.5
            : screenSize.size.height / 10 * 1.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "Donnez un nom à ce dossier",
                style: TextStyle(
                    fontFamily: 'Asap', color: isDarkModeEnabled ? Colors.white : Colors.black),
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
                    borderSide: BorderSide(color: isDarkModeEnabled ? Colors.white : Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: isDarkModeEnabled ? Colors.white : Colors.black),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Asap',
                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (widget.selectionMode)
              Container(
                child: Text(
                  "Utiliser un dossier existant",
                  style: TextStyle(
                      fontFamily: 'Asap', color: isDarkModeEnabled ? Colors.white : Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
            if (widget.selectionMode)
              Container(
                width: screenSize.size.width / 5 * 4.3,
                child: DropdownButton<String>(
                  value: dropDownValue,
                  dropdownColor: Theme.of(context).primaryColor,
                  style: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black),
                  icon: null,
                  iconSize: 0,
                  underline: Container(
                    height: screenSize.size.height / 10 * 0.02,
                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropDownValue = newValue;
                      if (newValue != "Aucun") {
                        value = newValue;
                        textController.text = newValue;
                      }
                    });
                  },
                  items: folderNames.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value ?? "",
                      child: Text(
                        value ?? "",
                        style: TextStyle(
                            fontFamily: 'Asap',
                            color: isDarkModeEnabled ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              )
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: const Text('ANNULER', style: TextStyle(color: Colors.red), textScaleFactor: 1.0),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: Text(
            dropDownValue != "Aucun" ? "DÉPLACER" : "CRÉER",
            style: TextStyle(color: Colors.green),
            textScaleFactor: 1.0,
          ),
          onPressed: () async {
            if (widget.selectionMode) {
              await Future.forEach(filesToMove, (element) async {
                try {
                  await element.element.copy(widget.path +
                      "/" +
                      value +
                      '/' +
                      element.fileName +
                      ((element.element is Directory) ? "/" : ""));
                  await element.element.delete(recursive: true);
                } catch (e) {
                  if (Platform.isAndroid) {
                    print("Trying with commandlines");
                    await Process.run(
                        'cp', ['-r', element.element.path, widget.path + "/" + value]);
                    await element.element.delete(recursive: true);
                  }
                }
              });
            } else {
              await FolderAppUtil.createDirectory(widget.path + "/" + value + "/");
            }
            await widget.callback();
            Navigator.pop(context, true);
          },
        )
      ],
    );
    ;
  }
}

class NumberChoice extends StatefulWidget {
  final String unit;


  const NumberChoice(this.unit);
  @override
  _NumberChoiceState createState() => _NumberChoiceState();
}

class _NumberChoiceState extends State<NumberChoice> {
  TextEditingController textController = TextEditingController(text: "");
  int value;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return AlertDialog(
      elevation: 50,
      backgroundColor: Theme.of(context).primaryColor,
      content: Container(
        height: screenSize.size.height / 10 * 1.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "Choisir ${widget.unit}",
                style: TextStyle(
                    fontFamily: 'Asap', color: isDarkModeEnabled ? Colors.white : Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: screenSize.size.width / 5 * 4.3,
              height: screenSize.size.height / 10 * 0.8,
              child: TextFormField(
                controller: textController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: isDarkModeEnabled ? Colors.white : Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: isDarkModeEnabled ? Colors.white : Colors.black),
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    value = int.parse(newValue);
                  });
                },
                style: TextStyle(
                  fontFamily: 'Asap',
                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: const Text('ANNULER', style: TextStyle(color: Colors.red), textScaleFactor: 1.0),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        FlatButton(
          child: Text(
            "VALIDER",
            style: TextStyle(color: Colors.green),
            textScaleFactor: 1.0,
          ),
          onPressed: () async {
            Navigator.pop(context, value);
          },
        )
      ],
    );
  }
}
