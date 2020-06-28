import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import '../usefulMethods.dart';

class CustomDialogs {
  static void showGiffyDialog(BuildContext context, HelpDialog hd) {
    var screenSize = MediaQuery.of(context);
    //Show a dialog with a gif
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset(hd.gifPath),
              title: Text(
                hd.title,
                style: TextStyle(fontSize: screenSize.size.height / 10 * 0.3, fontWeight: FontWeight.w600),
              ),
              description: Text(
                hd.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Asap",
                  fontSize: screenSize.size.height / 10 * 0.2,
                ),
              ),
              buttonOkText: Text(
                "J'ai compris",
                style: TextStyle(fontFamily: "Asap", color: Colors.white),
              ),
              onlyOkButton: true,
              entryAnimation: EntryAnimation.LEFT,
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
          child: const Text(
            'ANNULER',
            style: TextStyle(color: Colors.green),
          ),
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
          //const url = 'https://flutter.dev';
          //launchURL(url);
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
  final GlobalKey key;
  final String title;
  final String description;
  final String gifPath;
  HelpDialog(this.title, this.description, this.gifPath, {this.key});
}

//Help dialogs list for the showcase
List<HelpDialog> helpDialogs = [
  HelpDialog("QuickMenu", "Glissez votre doigt vers le haut sur l'icone Space pour afficher un menu rapide.", "assets/gifs/QuickMenu720.gif"),
  HelpDialog("Epingler", "Restez appuyé puis épinglez un devoir pour le revoir même après sa date d'échéance.", "assets/gifs/QuickMenu720.gif")
];
