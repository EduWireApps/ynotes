import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/homework/controller.dart';
import 'package:ynotes/core/legacy/theme_utils.dart';
import 'package:ynotes/app/app.dart';

class HomeworkFilterDialog extends StatefulWidget {
  const HomeworkFilterDialog({Key? key}) : super(key: key);
  @override
  _HomeworkFilterDialogState createState() => _HomeworkFilterDialogState();
}

class _HomeworkFilterDialogState extends State<HomeworkFilterDialog> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      content: SizedBox(
        width: screenSize.size.width / 5 * 3.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildDefaultChoice("Pas de filtre", MdiIcons.borderNoneVariant, homeworkFilter.all),
            SizedBox(height: screenSize.size.height / 10 * 0.1),
            buildDefaultChoice("Spécialités", MdiIcons.star, homeworkFilter.specialties),
            SizedBox(height: screenSize.size.height / 10 * 0.1),
            buildDefaultChoice("Littérature", MdiIcons.bookOpenBlankVariant, homeworkFilter.literacy),
            SizedBox(height: screenSize.size.height / 10 * 0.1),
            buildDefaultChoice("Sciences", MdiIcons.atom, homeworkFilter.sciences),
            SizedBox(height: screenSize.size.height / 10 * 0.1),
            buildDefaultChoice("Matières personnalisées", MdiIcons.pencil, homeworkFilter.custom),
          ],
        ),
      ),
    );
  }

  Widget buildDefaultChoice(String name, IconData icon, homeworkFilter filter) {
    var screenSize = MediaQuery.of(context);

    return Material(
      borderRadius: BorderRadius.circular(11),
      color: appSys.homeworkController.currentFilter == filter ? Colors.green : Theme.of(context).primaryColorDark,
      child: InkWell(
        onTap: () {
          appSys.homeworkController.currentFilter = filter;
          setState(() {});

          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(11),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(11)),
          height: screenSize.size.height / 10 * 0.8,
          child: Row(
            children: [
              Container(
                width: screenSize.size.width / 10 * 1.5,
                height: screenSize.size.width / 10 * 1.5,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Icon(
                  icon,
                  color: ThemeUtils.textColor(),
                ),
              ),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
