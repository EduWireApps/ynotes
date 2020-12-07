import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:ynotes/UI/components/quickMenu.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/utils/themeUtils.dart';
import 'dart:ui' as ui;

import '../../../classes.dart';

class ShareBox extends StatefulWidget {
  final Grade grade;

  const ShareBox(this.grade, {Key key}) : super(key: key);
  @override
  _ShareBoxState createState() => _ShareBoxState();
}

class _ShareBoxState extends State<ShareBox> {
  GlobalKey _globalKey = new GlobalKey();
  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      final directory = (await getExternalStorageDirectory()).path;
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);

      final RenderBox box = context.findRenderObject();
      Share.shareFiles(['$directory/screenshot.png'], subject: '', text: '', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate;
    if (chosenParser == 0) {
      parsedDate = DateTime.parse(widget.grade.date);
    } else {
      parsedDate = DateFormat("dd/MM/yyyy").parse(widget.grade.date);
    }
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        height: screenSize.size.height / 10 * 4,
        width: screenSize.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Partager cette note",
              style: TextStyle(fontFamily: "Asap", color: Colors.white),
            ),
            RepaintBoundary(
              key: _globalKey,
              child: Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      child: Stack(
                        children: [
                          Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                            FutureBuilder(
                                initialData: 0,
                                future: getColor(widget.grade.codeMatiere),
                                builder: (context, snapshot) {
                                  return Container(
                                      child: Center(
                                        child: Text(
                                          widget.grade.libelleMatiere,
                                          style: TextStyle(fontFamily: "Asap", color: Colors.black),
                                        ),
                                      ),
                                      width: screenSize.size.width / 5 * 5,
                                      height: screenSize.size.height / 10 * 0.5,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)), color: Color(snapshot.data)));
                                }),
                            Container(
                              width: screenSize.size.width / 5 * 5,
                              height: screenSize.size.height / 10 * 2,
                              decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)), color: Theme.of(context).primaryColor),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Note du " + DateFormat("dd MMMM yyyy", "fr_FR").format(parsedDate),
                                      style: TextStyle(
                                        fontFamily: "Asap",
                                        color: ThemeUtils.textColor(),
                                      )),
                                  Text(widget.grade.devoir, style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                  SizedBox(
                                    height: screenSize.size.height / 10 * 0.2,
                                  ),
                                  Text("Ma note :", style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.w300, fontSize: screenSize.size.height / 10 * 0.2), textAlign: TextAlign.center),
                                  Container(
                                    width: screenSize.size.width / 5 * 2,
                                    height: screenSize.size.height / 10 * 0.6,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)), color: Theme.of(context).primaryColorDark),
                                    child: Center(
                                      child: AutoSizeText.rich(
                                        //MARK
                                        TextSpan(
                                          text: widget.grade.valeur,
                                          style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.3),
                                          children: <TextSpan>[
                                            if (widget.grade.noteSur != "20")

                                              //MARK ON
                                              TextSpan(text: '/' + widget.grade.noteSur, style: TextStyle(color: ThemeUtils.textColor(), fontWeight: FontWeight.bold, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                          Positioned(
                            bottom: screenSize.size.height / 10 * 0.1,
                            right: screenSize.size.width / 5 * 0.1,
                            child: Image(
                              image: AssetImage('assets/images/LogoYNotes.png'),
                              color: ThemeUtils.spaceColor(),
                              height: screenSize.size.height / 10 * 0.3,
                              width: screenSize.size.width / 5 * 0.4,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  shape: CircleBorder(),
                  onPressed: () async {
                    await _capturePng();
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
            )
          ],
        ),
      ),
    );
  }
}

shareBox(Grade grade, Discipline discipline) {}
