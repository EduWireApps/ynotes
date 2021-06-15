import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';

class DialogHomework extends StatefulWidget {
  final Homework? hw;

  const DialogHomework(this.hw);
  State<StatefulWidget> createState() {
    return _DialogHomeworkState();
  }
}

class _DialogHomeworkState extends State<DialogHomework> {
  int segmentedControlIndex = 0;

  Widget build(BuildContext context) {
    var document = parse(segmentedControlIndex == 0
        ? (widget.hw!.rawContent) ?? "Non chargé"
        : (widget.hw!.sessionRawContent) ?? "Non chargé");

    String parsedHtml = parse(document.body!.text).documentElement!.text;
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return Container(
      height: screenSize.size.height / 10 * 6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  shape: CircleBorder(),
                ),
                onPressed: () {
                  Share.share(parsedHtml);
                },
                child: Container(
                    padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                    child: Icon(
                      MdiIcons.share,
                      color: ThemeUtils.textColor(),
                      size: screenSize.size.width / 5 * 0.5,
                    )),
              ),
            ],
          ),
          if (widget.hw!.sessionRawContent != null && widget.hw!.sessionRawContent != "")
            Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                width: screenSize.size.width / 5 * 4.5,
                child: CupertinoSegmentedControl<int>(
                    onValueChanged: (i) {
                      setState(() {
                        segmentedControlIndex = i;
                      });
                    },
                    groupValue: segmentedControlIndex,
                    children: <int, Widget>{
                      0: Text(
                        'A faire',
                        style: TextStyle(fontFamily: "Asap"),
                      ),
                      1: Text(
                        'Contenu',
                        style: TextStyle(fontFamily: "Asap"),
                        textAlign: TextAlign.center,
                      ),
                    }),
              ),
            ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenSize.size.height / 10 * 3.5),
            child: Container(
              margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
              width: screenSize.size.width / 5 * 4.5,
              padding: EdgeInsets.all(screenSize.size.height / 10 * 0.2),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15)),
              child: Material(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: SelectableText(
                    parsedHtml,
                    style: TextStyle(fontSize: 20, fontFamily: "Asap", color: ThemeUtils.textColor()),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder<int>(
              future: getColor(this.widget.hw!.disciplineCode),
              initialData: 0,
              builder: (context, snapshot) {
                return Material(
                  type: MaterialType.transparency,
                  child: Container(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                      width: screenSize.size.width / 5 * 4.5,
                      padding: EdgeInsets.all(screenSize.size.height / 10 * 0.2),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15)),
                      child: Column(
                        children: [
                          Text(
                            this.widget.hw!.discipline ?? "",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: "Asap",
                                color: ThemeUtils.textColor().withOpacity(0.5),
                                fontSize: screenSize.size.height / 10 * 0.25),
                          ),
                        ],
                      )),
                );
              }),
        ],
      ),
    );
  }

  initState() {
    super.initState();
  }
}
