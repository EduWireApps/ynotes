import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/utils/themeUtils.dart';

class SchoolLifePage extends StatefulWidget {
  @override
  _SchoolLifePageState createState() => _SchoolLifePageState();
}

List<Mail> localList = List();
Future mailsListFuture;
String dossier = "Reçus";
enum sortValue { date, reversed_date, author }
List<PollInfo> pollsList = List();
Future pollsFuture;

class _SchoolLifePageState extends State<SchoolLifePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // refreshPolls();
  }

  /*
  Future<void> refreshPolls({bool forced = false}) async {
    setState(() {
      pollsFuture = localApi.app("polls", action: "get", args: (forced) ? "forced" : null);
    });
    var realFuture = await pollsFuture;
  }
  */

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      width: screenSize.size.width,
      height: screenSize.size.height,
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                height: screenSize.size.height / 10 * 8.8,
                width: (screenSize.size.width / 5) * 4.6,
                child: Text("Hey")),
          )
        ],
      ),
    );
  }
}

Widget _buildPollQuestion(var data, screenSize) {
  List<Widget> list = new List<Widget>();
  for (var i = 0; i < data.questions.length; i++) {
    Map mapQuestions = jsonDecode(data.questions[i]);
    list.add(Container(
      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
      child: Column(
        children: [
          HtmlWidget(mapQuestions["texte"]["V"],
              textStyle: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"), onTapUrl: (url) async {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw "Unable to launch url";
            }
          }),
          _buildPollChoices(mapQuestions, screenSize, data)
        ],
      ),
    ));
  }
  return new Column(children: list);
}

Widget _buildPollChoices(Map data, screenSize, PollInfo pollinfo) {
  List choices = data["listeChoix"]["V"];
  List response = List();
  try {
    if (data["reponse"] != null &&
        data["reponse"]["V"] != null &&
        data["reponse"]["V"]["valeurReponse"] != null &&
        data["reponse"]["V"]["valeurReponse"]["V"] != null) {
      response = jsonDecode(data["reponse"]["V"]["valeurReponse"]["V"]);
    }
  } catch (e) {
    print(e);
  }
  //user info
  List<Widget> list = new List<Widget>();
  for (var i = 0; i < choices.length; i++) {
    list.add(Container(
        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
        child: Row(
          children: [
            CircularCheckBox(
              value: response.contains(i + 1),
              /* onChanged: (value) async {
                  await refreshPolls(forced: true);
                  await localApi.app("polls", action: "answer", args: jsonEncode(data) + "/ynsplit" + jsonEncode(pollinfo.data) + "/ynsplit" + (i + 1).toString());
                },*/
            ),
            Text(choices[i]["L"])
          ],
        )));
  }
  return new Column(children: list);
}
