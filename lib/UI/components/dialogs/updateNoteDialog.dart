import 'package:auto_size_text/auto_size_text.dart';
import 'package:battery_optimization/battery_optimization.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/screens/agendaPageWidgets/agenda.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';
import 'package:ynotes/background.dart';
import 'package:ynotes/main.dart';
import '../../../notifications.dart';
import '../../../usefulMethods.dart';

class UpdateNoteDialog extends StatefulWidget {
  @override
  _UpdateNoteDialogState createState() => _UpdateNoteDialogState();
}

class _UpdateNoteDialogState extends State<UpdateNoteDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMarkDownText();
  }

  static const String markdownText = "updateNoteAssets/updateNote.md";
  static const String thumbnail = "updateNoteAssets/0_9thumbnail.png";
  String markdown;
  getMarkDownText() async {
    var value = await FileAppUtil.loadAsset("assets/$markdownText");
    setState(() {
      markdown = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.all(0.0),
      backgroundColor: darken(Theme.of(context).primaryColorDark, forceAmount: 0.01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Container(
        width: screenSize.size.width / 5 * 4.7,
        height: screenSize.size.height / 10 * 7,
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.black),
                width: screenSize.size.width / 5 * 4.7,
                height: MediaQuery.of(context).size.height / 10 * 1.7,
                child: Image(
                  image: AssetImage(
                    'assets/$thumbnail',
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 10 * 5.3,
                child: Markdown(
                    selectable: true,
                    data: markdown,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                      listBullet: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                      h1: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                      h2: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                      h3: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                      h4: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                      h5: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                      h6: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
