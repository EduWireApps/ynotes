import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import '../../usefulMethods.dart';


class CustomDialogs {
  static void showGiffyDialog(BuildContext context, HelpDialog hd) {
    PageController controller = PageController();
    var screenSize = MediaQuery.of(context);

    //Show a dialog with a gif
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AssetGiffyDialog(
            
              image: Image.asset(hd.gifPath),
              title: Text(
                hd.title,
                style: TextStyle(fontSize: screenSize.size.height / 10 * 0.3, fontWeight: FontWeight.w600),
                textScaleFactor: 1.0,
              ),
              description: Text(hd.description[0]),
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

  static Future<bool> showConfirmationDialog(BuildContext context, File file, Function show) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 50,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(
        "Confirmation",
        style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
      ),
      content: Text(
        "Voulez vous vraiment supprimer ce fichier ?",
        style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
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
        "Bienvenue sur yNotes ! Nous sommes très content de vous voir ici !",
        "Nous vous laissons découvrir l'application comme bon vous semble. Des fenêtres comme celle ci apparaitront parfois pour aider.",
        "Vous avez déjà vu ce tutoriel ? Passez-le !"
      ],
      "assets/gifs/Hello720.gif",
      0),
  HelpDialog("QuickMenu", ["Glissez votre doigt vers le haut sur l'icone Space pour afficher un menu rapide.", "Vous accéderez rapidement à vos fichiers, et à d'autres action spéciales."], "assets/gifs/QuickMenu720.gif", 1),
  HelpDialog(
      "Épingler",
      [
        "Restez appuyé puis épinglez un devoir pour le revoir même après sa date d'échéance.",
        "Pratique pour retrouver les documents associés à ce devoir ou pour réafficher son contenu même des mois après !",
        "La fonctionnalité fonctionne hors ligne."
      ],
      "assets/gifs/PinHomework720.gif",
      2)
];
