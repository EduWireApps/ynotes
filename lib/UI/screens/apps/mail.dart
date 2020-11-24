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
import 'package:ynotes/UI/components/modalBottomSheets/readMailBottomSheet.dart';
import 'package:ynotes/utils/themeUtils.dart';

import 'package:ynotes/utils/themeUtils.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/apis/EcoleDirecte.dart';

import '../../../models.dart';
import '../../../usefulMethods.dart';
import '../appsPage.dart';

List<Mail> localList = List();

class MailPageOld extends StatefulWidget {
  final BuildContext context;

  const MailPageOld({Key key, this.context}) : super(key: key);
  State<StatefulWidget> createState() {
    return _MailPageOldState();
  }
}

Future mailsListFuture;
String dossier = "Reçus";
enum sortValue { date, reversed_date, author }

class _MailPageOldState extends State<MailPageOld> {
  var actualSort = sortValue.date;

  _MailPageOldState();

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          mailsListFuture = localApi.app("mail");
        }));
  }

  Future<void> refreshLocalMailsList() async {
    setState(() {
      mailsListFuture = localApi.app("mail");
    });
    var realdisciplinesListFuture = await mailsListFuture;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      color: Theme.of(context).backgroundColor,
      width: screenSize.size.width,
      height: screenSize.size.height,
      child: Stack(
        children: <Widget>[
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
                          color: ThemeUtils.textColor(),
                        ),
                        FittedBox(
                          child: Text("Revenir aux applications",
                              style: TextStyle(
                                fontFamily: "Asap",
                                fontSize: 15,
                                color: ThemeUtils.textColor(),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: screenSize.size.height / 10 * 0.7,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                  width: (screenSize.size.width / 5) * 2.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                    color: Theme.of(context).primaryColorDark,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Theme.of(context).primaryColorDark,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dossier,
                            iconSize: (screenSize.size.width / 5) * 0.3,
                            iconEnabledColor: ThemeUtils.textColor(),
                            style: TextStyle(fontSize: 18, fontFamily: "Asap", color: ThemeUtils.textColor()),
                            onChanged: (String newValue) {
                              setState(() {
                                dossier = newValue;
                              });
                            },
                            focusColor: Theme.of(context).primaryColor,
                            items: <String>[
                              'Reçus',
                              'Envoyés',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18, fontFamily: "Asap", color: ThemeUtils.textColor()),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                  child: Material(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          int index = sortValue.values.indexOf(actualSort);
                          actualSort = sortValue.values[index + (index == sortValue.values.length - 1 ? -2 : 1)];
                        });
                      },
                      borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                      child: Container(
                        height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                        width: (screenSize.size.width / 5) * 0.6,
                        child: Icon(
                          case2(actualSort, {
                            sortValue.date: MdiIcons.sortAscending,
                            sortValue.reversed_date: MdiIcons.sortDescending,
                            sortValue.author: MdiIcons.account,
                          }),
                          color: ThemeUtils.textColor(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: screenSize.size.height / 10 * 1.3,
            ),
            height: screenSize.size.height / 10 * 7,
            child: RefreshIndicator(
              onRefresh: refreshLocalMailsList,
              child: FutureBuilder(
                  //Get all the mails
                  future: mailsListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      localList = getCorrespondingClasseur(dossier, snapshot.data);
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                              itemCount: localList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Material(
                                      color: localList[index].read ? Theme.of(context).primaryColor : darken(Theme.of(context).primaryColor),
                                      child: InkWell(
                                        onTap: () {
                                          mailModalBottomSheet(widget.context, localList[index], index: index);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(0),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2),
                                                child: Icon(
                                                  MdiIcons.account,
                                                  color: ThemeUtils.textColor(),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.4),
                                                width: screenSize.size.width / 5 * 4,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        localList[index].subject,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          fontFamily: "Asap",
                                                          fontSize: screenSize.size.height / 10 * 0.25,
                                                          color: ThemeUtils.textColor(),
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      localList[index].from["name"],
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: "Asap",
                                                        fontSize: screenSize.size.height / 10 * 0.2,
                                                        color: isDarkModeEnabled ? Colors.white60 : Colors.black87,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          localList[index].date,
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            fontFamily: "Asap",
                                                            fontSize: screenSize.size.height / 10 * 0.2,
                                                            color: isDarkModeEnabled ? Colors.white38 : Colors.black38,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        if (localList[index].files.length > 0)
                                                          Icon(
                                                            MdiIcons.attachment,
                                                            color: isDarkModeEnabled ? Colors.white38 : Colors.black38,
                                                          )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Divider(
                                        color: Colors.black45,
                                        height: screenSize.size.height / 10 * 0.005,
                                        thickness: screenSize.size.height / 10 * 0.005,
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Une erreur a eu lieu",
                              style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                            ),
                            FlatButton(
                              onPressed: () {
                                //Reload list
                                refreshLocalMailsList();
                              },
                              child: snapshot.connectionState != ConnectionState.waiting
                                  ? Text("Recharger",
                                      style: TextStyle(
                                        fontFamily: "Asap",
                                        color: ThemeUtils.textColor(),
                                      ))
                                  : FittedBox(child: SpinKitThreeBounce(color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4)),
                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0), side: BorderSide(color: Theme.of(context).primaryColorDark)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SpinKitFadingFour(
                        color: Theme.of(context).primaryColor,
                        size: screenSize.size.width / 5 * 0.7,
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void mailModalBottomSheet(context, Mail mail, {int index}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        context: context,
        builder: (BuildContext bc) {
          return ReadMailBottomSheet(mail, index);
        });
  }

  getCorrespondingClasseur(dossier, List<Mail> list) {
    String trad;
    List<Mail> toReturn = List<Mail>();
    switch (dossier) {
      case "Reçus":
        trad = "received";
        break;
      case "Envoyés":
        trad = "send";
        break;
    }
    print(trad);
    list.forEach((element) {
      if (element.mtype == trad) {
        toReturn.add(element);
      }
    });
    toReturn.sort((a, b) {
      DateTime datea = DateTime.parse(a.date);
      DateTime dateb = DateTime.parse(b.date);
      switch (actualSort) {
        case (sortValue.date):
          return dateb.compareTo(datea);
          break;
        case (sortValue.reversed_date):
          return datea.compareTo(dateb);
          break;
        case (sortValue.author):
          return b.from["nom"].compareTo(a.from["nom"]);
          break;
      }
    });
    return toReturn;
  }
}
