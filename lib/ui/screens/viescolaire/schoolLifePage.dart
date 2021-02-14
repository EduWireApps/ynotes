import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

class SchoolLifePage extends StatefulWidget {
  @override
  _SchoolLifePageState createState() => _SchoolLifePageState();
}

Future schoolLifeFuture;

class _SchoolLifePageState extends State<SchoolLifePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // refreshPolls();
  }

  Widget buildCircle(SchoolLifeTicket ticket) {
    IconData icon;
    if (ticket.type == "absence") {
      icon = MdiIcons.alert;
    }
    return CircleAvatar(
      child: Icon(icon),
    );
  }

  Widget buildTicket(SchoolLifeTicket ticket) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      width: screenSize.size.width / 5 * 4.2,
      child: Card(
        child: Row(
          children: [
            buildCircle(ticket),
            Column(
              children: [
                Text(ticket.libelle),
                Text(ticket.motif),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildNoTickets() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.stamper,
              size: screenSize.size.width / 5 * 1.2,
              color: ThemeUtils.textColor(),
            ),
            Text(
              "Pas de données.",
              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
        width: screenSize.size.width,
        height: screenSize.size.height,
        color: Theme.of(context).backgroundColor,
        child: FutureBuilder(
            future: schoolLifeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                if (snapshot.data != null) {
                  return buildNoTickets();
                } else {
                  return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return buildTicket(SchoolLifeTicket("a", "a", "a", "a", false));
                      });
                }
              } else {
                return Center(child: SpinKitFadingFour(color: Theme.of(context).primaryColor));
              }
            }));
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
