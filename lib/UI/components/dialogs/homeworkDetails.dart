import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:ynotes/UI/screens/summary/summaryPage.dart';
import 'package:ynotes/UI/screens/summary/summaryPageWidgets/quickHomework.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/utils/themeUtils.dart';
import 'package:html/parser.dart';

class DialogHomework extends StatefulWidget {
  final Homework hw;

  const DialogHomework(this.hw);
  State<StatefulWidget> createState() {
    return _DialogHomeworkState();
  }
}

class _DialogHomeworkState extends State<DialogHomework> {
  initState() {
    super.initState();
  }

  HighlightMap highlightMap;
  int segmentedControlIndex = 0;
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(backgroundColor: Colors.yellow.shade100);

    var document = parse(segmentedControlIndex == 0 ? widget.hw.contenu : widget.hw.contenuDeSeance);

    String parsedHtml = parse(document.body.text).documentElement.text;
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
              RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: CircleBorder(),
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
          if (widget.hw.contenuDeSeance != null && widget.hw.contenuDeSeance != "")
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
                  child: AutoSizeText(
                    parsedHtml,
                    style: TextStyle(fontSize: 20, fontFamily: "Asap", color: ThemeUtils.textColor()),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder(
              future: getColor(this.widget.hw.codeMatiere),
              initialData: 0,
              builder: (context, snapshot) {
                Color color = Color(snapshot.data);
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
                            this.widget.hw.matiere,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: "Asap",
                                color: isDarkModeEnabled ? Colors.grey.shade200 : Colors.black54,
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
}
