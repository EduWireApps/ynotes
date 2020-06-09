import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';

import '../../usefulMethods.dart';
import '../appsPage.dart';

class MailPage extends StatefulWidget {
  final BuildContext context;

  const MailPage({Key key, this.context}) : super(key: key);
  State<StatefulWidget> createState() {
    return _MailPageState();
  }
}

Future mailsListFuture;
String dossier = "Reçus";
enum sortValue { date, reversed_date, author }

class _MailPageState extends State<MailPage> {
  var actualSort = sortValue.date;

  API api = APIManager();
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          mailsListFuture = api.app("mail");
        }));
  }

  Future<void> refreshLocalGradeList() async {
    setState(() {
      mailsListFuture = api.app("mail");
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
              borderRadius: BorderRadius.circular(11),
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/homePage');
                  initialRoute = '/homePage';
                },
                child: Container(
                  height: screenSize.size.height / 10 * 0.5,
                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        MdiIcons.arrowLeft,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                      ),
                      Text("Revenir aux applications",
                          style: TextStyle(
                            fontFamily: "Asap",
                            fontSize: 15,
                            color:
                                isDarkModeEnabled ? Colors.white : Colors.black,
                          )),
                    ],
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
                    borderRadius: BorderRadius.circular(11),
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
                            iconEnabledColor:
                                isDarkModeEnabled ? Colors.white : Colors.black,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Asap",
                                color: isDarkModeEnabled
                                    ? Colors.white
                                    : Colors.black),
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
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Asap",
                                      color: isDarkModeEnabled
                                          ? Colors.white
                                          : Colors.black),
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
                  margin:
                      EdgeInsets.only(left: (screenSize.size.width / 5) * 0.2),
                  child: Material(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(11),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          int index = sortValue.values.indexOf(actualSort);
                          actualSort = sortValue.values[index +
                              (index == sortValue.values.length - 1 ? -2 : 1)];
                        });
                      },
                      borderRadius: BorderRadius.circular(11),
                      child: Container(
                        height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                        width: (screenSize.size.width / 5) * 0.6,
                        child: Icon(
                          case2(actualSort, {
                            sortValue.date: MdiIcons.sortAscending,
                            sortValue.reversed_date: MdiIcons.sortDescending,
                            sortValue.author: MdiIcons.account,
                          }),
                          color:
                              isDarkModeEnabled ? Colors.white : Colors.black,
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
              onRefresh: refreshLocalGradeList,
              child: FutureBuilder(
                  //Get all the mails
                  future: mailsListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Mail> localList =
                          getCorrespondingClasseur(dossier, snapshot.data);
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
                                      color: Theme.of(context).primaryColor,
                                      child: InkWell(
                                        onTap: () {
                                          mailModalBottomSheet(
                                              widget.context, localList[index]);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(0),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left:
                                                        screenSize.size.width /
                                                            5 *
                                                            0.2),
                                                child: Icon(
                                                  MdiIcons.account,
                                                  color: isDarkModeEnabled
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left:
                                                        screenSize.size.width /
                                                            5 *
                                                            0.4),
                                                width: screenSize.size.width /
                                                    5 *
                                                    4,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        localList[index]
                                                            .subject,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontFamily: "Asap",
                                                          fontSize: screenSize
                                                                  .size.height /
                                                              10 *
                                                              0.25,
                                                          color:
                                                              isDarkModeEnabled
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      localList[index]
                                                          .from["name"],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: "Asap",
                                                        fontSize: screenSize
                                                                .size.height /
                                                            10 *
                                                            0.2,
                                                        color: isDarkModeEnabled
                                                            ? Colors.white60
                                                            : Colors.black87,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          localList[index].date,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontFamily: "Asap",
                                                            fontSize: screenSize
                                                                    .size
                                                                    .height /
                                                                10 *
                                                                0.2,
                                                            color:
                                                                isDarkModeEnabled
                                                                    ? Colors
                                                                        .white38
                                                                    : Colors
                                                                        .black38,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        if (localList[index]
                                                                .files
                                                                .length >
                                                            0)
                                                          Icon(
                                                            MdiIcons.attachment,
                                                            color:
                                                                isDarkModeEnabled
                                                                    ? Colors
                                                                        .white38
                                                                    : Colors
                                                                        .black38,
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
                                    Divider(
                                      color: Colors.black45,
                                      height:
                                          screenSize.size.height / 10 * 0.005,
                                      thickness:
                                          screenSize.size.height / 10 * 0.005,
                                    )
                                  ],
                                );
                              }),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Une erreur a eu lieu"),
                      );
                    } else {
                      return SpinKitFadingFour(
                        color: Theme.of(context).primaryColorDark,
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

  void mailModalBottomSheet(context, Mail mail) {
    MediaQueryData screenSize = MediaQuery.of(context);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        context: context,
        builder: (BuildContext bc) {
          return FutureBuilder(
              future: readMail(mail.id),
              builder: (context, snapshot) {
                String to = "";
                if (mail.to != null) {
                  mail.to.forEach((element) {
                    to += element["name"] + " - ";
                  });
                }

                return Container(
                    height: screenSize.size.height / 10 * 8.0,
                    padding: EdgeInsets.all(0),
                    child: new Column(
                      children: <Widget>[
                        Container(
                          height: screenSize.size.height / 10 * 1.0,
                          width: screenSize.size.width/5*4.8,
                          child: FittedBox(
                           
                            child: Column(
                              children: <Widget>[
                                Text(
                                  mail.subject,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Asap",
                                      fontWeight: FontWeight.bold,
                                  
                                      color: isDarkModeEnabled
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    if (mail.mtype != "send")
                                      Container(
                                         width:
                                            screenSize.size.width / 5 * 2.6,
                                        height: screenSize.size.height /
                                            10 *
                                            0.45,
                                        padding: EdgeInsets.all(
                                            screenSize.size.height /
                                                10 *
                                                0.1),
                                        decoration: ShapeDecoration(
                                            shape: StadiumBorder(),
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "de : ",
                                              style: TextStyle(
                                                  fontFamily: "Asap",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      screenSize.size.height /
                                                          10 *
                                                          0.15,
                                                  color: isDarkModeEnabled
                                                      ? Colors.white70
                                                      : Colors.black87),
                                            ),
                                            Text(
                                              mail.from["name"],
                                              style: TextStyle(
                                                  fontFamily: "Asap",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      screenSize.size.height /
                                                          10 *
                                                          0.15,
                                                  color: isDarkModeEnabled
                                                      ? Colors.white70
                                                      : Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (mail.mtype != "received")
                                      Container(
                                        padding: EdgeInsets.all(
                                            screenSize.size.height /
                                                10 *
                                                0.1),
                                        width:
                                            screenSize.size.width / 5 * 2.6,
                                        height: screenSize.size.height /
                                            10 *
                                            0.45,
                                        decoration: ShapeDecoration(
                                            shape: StadiumBorder(),
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "à : ",
                                                style: TextStyle(
                                                    fontFamily: "Asap",
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: screenSize
                                                            .size.height /
                                                        10 *
                                                        0.15,
                                                    color: isDarkModeEnabled
                                                        ? Colors.white70
                                                        : Colors.black87),
                                              ),
                                              Container(
                                                width: screenSize.size.width /
                                                    5 *
                                                    2.1,
                                                height:
                                                    screenSize.size.height /
                                                        10 *
                                                        0.45,
                                                child: Marquee(
                                                  text: to,
                                                  style: TextStyle(
                                                      fontFamily: "Asap",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: screenSize
                                                              .size.height /
                                                          10 *
                                                          0.15,
                                                      color: isDarkModeEnabled
                                                          ? Colors.white70
                                                          : Colors.black87),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: screenSize.size.width /
                                              5 *
                                              0.1),
                                      width: screenSize.size.width / 5 * 1.3,
                                      padding: EdgeInsets.all(
                                          screenSize.size.height / 10 * 0.1),
                                      height:
                                          screenSize.size.height / 10 * 0.45,
                                      decoration: ShapeDecoration(
                                          shape: StadiumBorder(),
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      child: FittedBox(
                                        child: Text(
                                          DateFormat("dd MMMM yyyy", "fr_FR")
                                              .format(
                                                  DateTime.parse(mail.date)),
                                          style: TextStyle(
                                              fontFamily: "Asap",
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  screenSize.size.height /
                                                      10 *
                                                      0.15,
                                              color: isDarkModeEnabled
                                                  ? Colors.white70
                                                  : Colors.black87),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: screenSize.size.width / 5 * 4.8,
                          height: screenSize.size.height / 10 * 4,
                          child: (snapshot.hasData)
                              ? SingleChildScrollView(
                                  child: HtmlWidget(snapshot.data, hyperlinkColor: Colors.blue.shade300,  onTapUrl: (url) async {
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw "Unable to launch url";
                                      }
                                  }, textStyle: TextStyle(color: isDarkModeEnabled
                                                  ? Colors.white
                                                  : Colors.black),))
                              : SpinKitFadingFour(
                                  color: Theme.of(context).primaryColorDark,
                                  size: screenSize.size.width / 5 * 0.7,
                                ),
                        )
                      ],
                    ));
              });
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
