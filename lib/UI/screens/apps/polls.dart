import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/main.dart';
import '../../../models.dart';
import '../../../usefulMethods.dart';
import '../appsPage.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';

class PollsAndInfosPage extends StatefulWidget {
  @override
  _PollsAndInfosPageState createState() => _PollsAndInfosPageState();
}

List<PollInfo> pollsList = List();
Future pollsFuture;

class _PollsAndInfosPageState extends State<PollsAndInfosPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshPolls();
  }

  Future<void> refreshPolls({bool forced = false}) async {
    setState(() {
      pollsFuture = localApi.app("polls", action: "get", args: (forced) ? "forced" : null);
    });
    var realFuture = await pollsFuture;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      width: screenSize.size.width,
      height: screenSize.size.height,
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: [
          Positioned(
            left: screenSize.size.width / 5 * 0.2,
            top: screenSize.size.height / 10 * 0.1,
            child: Material(
              borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/homePage');
                  initialRoute = '/homePage';
                },
                child: Container(
                  height: screenSize.size.height / 10 * 0.5,
                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                  child: FittedBox(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          MdiIcons.arrowLeft,
                          color: isDarkModeEnabled ? Colors.white : Colors.black,
                        ),
                        FittedBox(
                          child: Text("Revenir aux applications",
                              style: TextStyle(
                                fontFamily: "Asap",
                                fontSize: 15,
                                color: isDarkModeEnabled ? Colors.white : Colors.black,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.only(
                  top: screenSize.size.height / 10 * 0.7,
                ),
                height: screenSize.size.height / 10 * 8.8,
                width: (screenSize.size.width / 5) * 4.6,
                child: FutureBuilder(
                    future: pollsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null && snapshot.data.length != 0) {
                        SchedulerBinding.instance.addPostFrameCallback((_) => mounted
                            ? setState(() {
                                pollsList = snapshot.data;
                              })
                            : null);

                        return RefreshIndicator(
                          onRefresh: () => refreshPolls(forced: true),
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: pollsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: Card(
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(11),
                                      child: ExpansionTile(
                                        backgroundColor: Colors.transparent,
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              snapshot.data[index].title + " - " + DateFormat("dd/MM/yyyy").format(snapshot.data[index].datedebut),
                                              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black),
                                            ),
                                            AutoSizeText(
                                              snapshot.data[index].auteur,
                                              style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                                            ),
                                          ],
                                        ),
                                        children: [
                                          Column(
                                            children: [
                                              _buildPollQuestion(snapshot.data[index], screenSize),
                                              FittedBox(
                                                child: Row(
                                                  children: [
                                                    CircularCheckBox(
                                                      onChanged: (value) async {
                                                        await refreshPolls(forced: true);
                                                        setState(() {
                                                          pollsList[index].read = value;
                                                        });

                                                        String userID = pollsList[index].data["public"]["V"]["N"];
                                                        //Pass args (that's messy but it works lel)
                                                        await localApi.app("polls", action: "read", args: pollsList[index].id + "/" + pollsList[index].title + "/" + value.toString() + "/" + userID);
                                                      },
                                                      value: pollsList[index].read,
                                                    ),
                                                    AutoSizeText(
                                                      "J'ai pris connaissance de cette information",
                                                      style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      } else {
                        return SpinKitFadingFour(
                          color: Theme.of(context).primaryColorDark,
                        );
                      }
                    })),
          )
        ],
      ),
    );
  }

  Widget _buildPollQuestion(var data, screenSize) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < data.questions.length; i++) {
      Map mapQuestions = jsonDecode(data.questions[i]);
      list.add(Container(
        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
        child: Column(
          children: [
            HtmlWidget(mapQuestions["texte"]["V"], bodyPadding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1), textStyle: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black, fontFamily: "Asap"), onTapUrl: (url) async {
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
      if (data["reponse"] != null && data["reponse"]["V"] != null && data["reponse"]["V"]["valeurReponse"] != null && data["reponse"]["V"]["valeurReponse"]["V"] != null) {
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
}
