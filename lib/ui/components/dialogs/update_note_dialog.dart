import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes_packages/theme.dart';

class UpdateNoteDialog extends StatefulWidget {
  const UpdateNoteDialog({Key? key}) : super(key: key);

  @override
  _UpdateNoteDialogState createState() => _UpdateNoteDialogState();
}

class _UpdateNoteDialogState extends State<UpdateNoteDialog> {
  static const String markdownText = "documents/updateNoteAssets/updateNote.md";

  static const String thumbnail = "documents/updateNoteAssets/0_14thumbnail.png";
  String? markdown;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(0.0),
      backgroundColor: ThemeUtils.darken(Theme.of(context).primaryColorDark, forceAmount: 0.01),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Container(
        width: screenSize.size.width / 5 * 4.7,
        height: screenSize.size.height / 10 * 7,
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.black),
                width: screenSize.size.width / 5 * 4.7,
                height: MediaQuery.of(context).size.height / 10 * 1.7,
                child: const Image(
                  image: AssetImage(
                    'assets/$thumbnail',
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10 * 5.3,
                child: Markdown(
                    selectable: true,
                    data: markdown ?? "",
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                      listBullet: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                      h1: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                      h2: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                      h3: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                      h4: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                      h5: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                      h6: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getMarkDownText() async {
    var value = await FileAppUtil.loadAsset("assets/$markdownText");
    setState(() {
      markdown = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getMarkDownText();
  }
}
