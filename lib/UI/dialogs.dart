import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import '../usefulMethods.dart';
void showGiffyDialog(BuildContext context, String title, String description,Image image)
{
  var screenSize = MediaQuery.of(context);
  //Show a dialog with a gif
  showDialog(
  context: context,builder: (_) => AssetGiffyDialog(
    image: Image.asset("test"),
    title: Text( title ,
            style: TextStyle(
            fontSize: screenSize.size.height/10*1.5, fontWeight: FontWeight.w600),
    ),
    description: Text(
      description,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Asap"),
        ),
    entryAnimation: EntryAnimation.LEFT,
    onOkButtonPressed: () {},
  ) );
}
//Bêta purposes : show when a function is not available yet
showUnimplementedSnackBar(BuildContext context) {
  Flushbar(
    flushbarPosition: FlushbarPosition.BOTTOM,
    backgroundColor: Colors.green.shade200,
    isDismissible: true,
    duration: Duration(seconds: 2),
    margin: EdgeInsets.all(8),
    messageText: Text(
      "Cette fonction n'est pas encore disponible pour le moment.",
      style: TextStyle(fontFamily: "Asap"),
    ),
    mainButton: FlatButton(
      onPressed: () {
        const url = 'https://flutter.dev';
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

showAnyDialog(BuildContext context, String text) {
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