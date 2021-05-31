import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

import '../dialogs.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

class NewRecipientDialog extends StatefulWidget {
  @override
  _NewRecipientDialogState createState() => _NewRecipientDialogState();
}

class _NewRecipientDialogState extends State<NewRecipientDialog> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController surnameController = TextEditingController(text: "");
  TextEditingController idController = TextEditingController(text: "");
  TextEditingController disciplineController = TextEditingController(text: "");
  bool isTeacher = true;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(
          horizontal: screenSize.size.width / 5 * 0.2,
          vertical: screenSize.size.height / 10 * 0.1),
      backgroundColor: ThemeUtils.darken(Theme.of(context).primaryColorDark,
          forceAmount: 0.01),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Container(
        width: screenSize.size.width / 5 * 3.2,
        height: screenSize.size.height / 10 * 4.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (nameController.text != "" &&
                    surnameController.text != '' &&
                    idController.text != "") {
                  Navigator.pop(
                      context,
                      Recipient(
                          nameController.text,
                          surnameController.text,
                          idController.text,
                          isTeacher,
                          disciplineController.text));
                } else {
                  CustomDialogs.showAnyDialog(
                      context, "Entrez un nom, un prénom et un ID");
                }
              },
              child: Container(
                width: screenSize.size.width,
                height: screenSize.size.height / 10 * 0.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            top: screenSize.size.width / 5 * 0.2),
                        height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75,
                        width: screenSize.size.width / 5 * 2,
                        child: Icon(MdiIcons.check,
                            color: ThemeUtils.textColor())),
                  ],
                ),
              ),
            ),
            Text(
              "Contact personnalisé",
              style: TextStyle(
                  fontFamily: "Asap",
                  color: ThemeUtils.textColor().withOpacity(0.5),
                  fontSize: screenSize.size.width / 5 * 0.35),
              textAlign: TextAlign.center,
            ),
            SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Professeur',
                  style: TextStyle(
                      fontFamily: "Asap",
                      color: ThemeUtils.textColor().withOpacity(0.8),
                      fontSize: screenSize.size.width / 5 * 0.25),
                ),
                value: isTeacher,
                onChanged: (nValue) {
                  setState(() {
                    isTeacher = nValue;
                  });
                }),
            SizedBox(height: screenSize.size.height / 10 * 0.1),
            Container(
              height: screenSize.size.height / 10 * 0.6,
              child: TextField(
                controller: nameController,
                style: TextStyle(
                    fontFamily: "Asap",
                    color: ThemeUtils.textColor(),
                    fontSize: screenSize.size.width / 5 * 0.35),
                decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prénom',
                  labelStyle: TextStyle(
                      fontFamily: "Asap",
                      color: ThemeUtils.textColor().withOpacity(0.5),
                      fontSize: screenSize.size.width / 5 * 0.35),
                ),
              ),
            ),
            SizedBox(height: screenSize.size.height / 10 * 0.1),
            Container(
              height: screenSize.size.height / 10 * 0.6,
              child: TextField(
                controller: surnameController,
                style: TextStyle(
                    fontFamily: "Asap",
                    color: ThemeUtils.textColor(),
                    fontSize: screenSize.size.width / 5 * 0.35),
                decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom de famille',
                  labelStyle: TextStyle(
                      fontFamily: "Asap",
                      color: ThemeUtils.textColor().withOpacity(0.5),
                      fontSize: screenSize.size.width / 5 * 0.35),
                ),
              ),
            ),
            SizedBox(height: screenSize.size.height / 10 * 0.1),
            Container(
              height: screenSize.size.height / 10 * 0.6,
              child: TextField(
                controller: disciplineController,
                style: TextStyle(
                    fontFamily: "Asap",
                    color: ThemeUtils.textColor(),
                    fontSize: screenSize.size.width / 5 * 0.35),
                decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Matière',
                  labelStyle: TextStyle(
                      fontFamily: "Asap",
                      color: ThemeUtils.textColor().withOpacity(0.5),
                      fontSize: screenSize.size.width / 5 * 0.35),
                ),
              ),
            ),
            SizedBox(height: screenSize.size.height / 10 * 0.1),
            Container(
              height: screenSize.size.height / 10 * 0.6,
              child: TextField(
                controller: idController,
                style: TextStyle(
                    fontFamily: "Asap",
                    color: ThemeUtils.textColor(),
                    fontSize: screenSize.size.width / 5 * 0.35),
                decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Identifiant unique',
                  labelStyle: TextStyle(
                      fontFamily: "Asap",
                      color: ThemeUtils.textColor().withOpacity(0.5),
                      fontSize: screenSize.size.width / 5 * 0.35),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
