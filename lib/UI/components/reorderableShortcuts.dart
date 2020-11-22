import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/utils/themeUtils.dart';
import 'package:ynotes/usefulMethods.dart';

class ReorderableShortcuts extends StatefulWidget {
  @override
  _ReorderableShortcutsState createState() => _ReorderableShortcutsState();
}

List<String> alphabetList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

class _ReorderableShortcutsState extends State<ReorderableShortcuts> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      height: screenSize.size.height / 10 * 0.8,
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(1000)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.menu,
            color: ThemeUtils.textColor(),
          ),
          SizedBox(
            width: screenSize.size.width / 5 * 0.1,
          ),
          Container(
            width: screenSize.size.width / 5 * 4,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: List.generate(
                150,
                (index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: FlatButton(
                      focusColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).primaryColor,
                      child: Icon(MdiIcons.tab),
                      onPressed: () {},
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
