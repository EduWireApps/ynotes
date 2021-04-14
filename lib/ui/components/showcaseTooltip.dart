import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

class ShowCaseToolTip extends StatelessWidget {
  final String title;
  final String desc;
  const ShowCaseToolTip({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Card(
        color: Theme.of(context).primaryColorDark,
        child: Container(
          width: screenSize.size.width / 5 * 4.5,
          padding: EdgeInsets.symmetric(
              horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.1),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    MdiIcons.information,
                    color: ThemeUtils.textColor(),
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: ThemeUtils.textColor()),
                  ),
                ],
              ),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
              ),
            ],
          ),
        ));
  }
}
