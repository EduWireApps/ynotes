import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import '../usefulMethods.dart';

class CustomDialogs {
  static void showGiffyDialog(
      BuildContext context, String title, String description, Image image) {
    var screenSize = MediaQuery.of(context);
    //Show a dialog with a gif
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
              image: image,
              title: Text(
                title,
                style: TextStyle(
                    fontSize: screenSize.size.height / 10 * 0.3,
                    fontWeight: FontWeight.w600),
              ),
              description: Text(
                description,
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
              onOkButtonPressed: () {},
            ));
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
class helpDialog 
{
final GlobalKey key;
final String title;
final String description;

  helpDialog(this.title, this.description,{this.key});

}
//Help dialogs list for the showcase
List<helpDialog> helpDialogs = [
helpDialog("QuickMenu", "Glissez votre doigt vers le haut sur l'icone Space pour afficher un menu rapide."),
helpDialog("Epingler", "Restez appuyé puis épinglez un devoir pour le revoir même après sa date d'échéance.")
];