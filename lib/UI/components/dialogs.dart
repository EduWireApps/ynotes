import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/UI/components/dialogs/authorizationsDialog.dart';
import 'package:ynotes/UI/components/dialogs/colorPicker.dart';
import 'package:ynotes/UI/components/dialogs/persistantNotificationDialog.dart';
import 'package:ynotes/UI/components/dialogs/updateNoteDialog.dart';
import 'package:ynotes/UI/components/giffy_dialog/src/asset.dart';
import 'package:ynotes/UI/components/modalBottomSheets/writeMailBottomSheet.dart';
import 'package:ynotes/UI/screens/settingsPage.dart';
import 'package:ynotes/utils/themeUtils.dart';
import 'package:ynotes/apis/EcoleDirecte/ecoleDirecteMethods.dart';
import '../../classes.dart';
import '../../usefulMethods.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';
import 'dialogs/folderChoiceDialog.dart';
import 'dialogs/multipleChoicesDialog.dart';
import 'dialogs/numberChoiceDialog.dart';
import 'dialogs/recurringEventsDialog.dart';
import 'dialogs/specialtiesDialog.dart';
import 'dialogs/textFieldChoiceDialog.dart';
import 'dialogs/newRecipientDialog.dart';

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
                style: TextStyle(fontSize: screenSize.size.height / 10 * 0.3, fontWeight: FontWeight.w600),
                textScaleFactor: 1.0,
                textAlign: TextAlign.center,
              ),
              description: Text(hd.description[0], style: TextStyle(fontSize: screenSize.size.height / 10 * 0.2)),
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

  static Future<bool> showConfirmationDialog(BuildContext context, Function show, {String alternativeText = "Voulez vous vraiment supprimer cet élément (irréversible) ?", String alternativeButtonConfirmText = "SUPPRIMER"}) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 50,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(
        "Confirmation",
        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
      ),
      content: Text(
        alternativeText,
        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
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
          child: Text(
            alternativeButtonConfirmText.toUpperCase(),
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

  static Future<int> showNumberChoiceDialog(BuildContext context, {String text = ""}) {
    // show the dialog
    return showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return NumberChoiceDialog(text);
      },
    );
  }

  static Future<Color> showColorPicker(BuildContext context, Color defaultColor) {
    // show the dialog
    return showDialog<Color>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomColorPicker(defaultColor: defaultColor);
      },
    );
  }

  static Future<String> showTextChoiceDialog(BuildContext context, {String text = "", String defaultText = ""}) {
    // show the dialog
    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return TextFieldChoiceDialog(text, defaultText);
      },
    );
  }

  static Future<bool> showNewFolderDialog(BuildContext context, String path, List<FileInfo> files, bool selectionMode, Function callback) {
    // show the dialog
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return FolderChoiceDialog(context, path, files, selectionMode, callback);
      },
    );
  }

  static Future showMultipleChoicesDialog(BuildContext context, List choices, List<int> initialSelection, {singleChoice = false}) {
    // show the dialog
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return MultipleChoicesDialog(choices, initialSelection, singleChoice: singleChoice);
      },
    );
  }

  static Future showRecurringEventDialog(BuildContext context, String scheme) {
    // show the dialog
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return RecurringEventsDialog(scheme);
      },
    );
  }

  static Future showAuthorizationsDialog(BuildContext context, String authName, String goal) {
    // show the dialog
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AuthorizationsDialog(
          authName: authName,
          goal: goal,
        );
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

  static Future showPersistantNotificationDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return PersistantNotificationConfigDialog();
      },
    );
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

  static showSpecialtiesChoice(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          MediaQueryData screenSize;
          screenSize = MediaQuery.of(context);
          return Container(child: DialogSpecialties());
        });
  }

  static showUpdateNoteDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdateNoteDialog();
        });
  }

  static showNewRecipientDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return NewRecipientDialog();
        });
  }

  static Future writeModalBottomSheet(context, {List<Recipient> defaultListRecipients, defaultSubject}) async {
    var mailData = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return WriteMailBottomSheet(defaultRecipients: defaultListRecipients, defaultSubject: defaultSubject);
        });
    if (mailData != null) {
      await EcoleDirecteMethod.sendMail(mailData[0], mailData[1], mailData[2]).then((value) {
        print("success");
        CustomDialogs.showAnyDialog(context, "Le mail a été envoyé.");
      }).catchError((Object error) {
        CustomDialogs.showAnyDialog(context, "Le mail n'a pas été envoyé !");
      });
    }
  }
}

//The help dialog class
class HelpDialog {
  final int id;
  final GlobalKey key;
  final String title;
  final List<String> description;
  final String gifPath;
  showDialog(BuildContext context) async {
    var z = await storage.read(key: "agreedTermsAndConfiguredApp");
    //If the dialog has never been viewed
    if (!await checkAlreadyViewed() && z != null) {
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
  HelpDialog("Bienvenue !", ["""Bienvenue sur yNotes ! Nous sommes très content de vous voir ici ! Ceci est une fenêtre de tutoriel, d'autres apparaitront pour vous montrer les nouveautés ou les fonctionnalités utiles de l'application. Vous les avez déjà vues ? Passez le tutoriel !"""],
      "assets/gifs/Hello720.gif", 0),
  HelpDialog(
      "QuickMenu",
      [
        "Glissez votre doigt vers le haut sur l'icone Space pour afficher un menu rapide.",
      ],
      "assets/gifs/QuickMenu720.gif",
      1),
  HelpDialog("Épingler", ["Restez appuyé puis épinglez un devoir pour le revoir même après sa date d'échéance."], "assets/gifs/PinHomework720.gif", 2),
  HelpDialog(
      "Nouvel explorateur de téléchargements",
      [
        "Nous avons mis à jour votre explorateur de téléchargements ! Idéal pour mieux organiser vos fiches ou documents.",
      ],
      "assets/gifs/FileExplorer720.gif",
      3)
];
