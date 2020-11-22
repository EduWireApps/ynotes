import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';
import 'package:ynotes/utils/themeUtils.dart';

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
                      p: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                      listBullet: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                      h1: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                      h2: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                      h3: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                      h4: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                      h5: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                      h6: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
