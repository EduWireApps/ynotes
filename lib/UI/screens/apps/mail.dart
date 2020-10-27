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
import 'package:ynotes/classes.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/main.dart';
import '../../../models.dart';
import '../../../usefulMethods.dart';
import '../appsPage.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';
import 'package:html/parser.dart';

List<Mail> localList = List();

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

  _MailPageState();

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
                            iconEnabledColor: isDarkModeEnabled ? Colors.white : Colors.black,
                            style: TextStyle(fontSize: 18, fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
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
                                  style: TextStyle(fontSize: 18, fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
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
                          color: isDarkModeEnabled ? Colors.white : Colors.black,
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
                                                  color: isDarkModeEnabled ? Colors.white : Colors.black,
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
                                                          color: isDarkModeEnabled ? Colors.white : Colors.black,
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
                              style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
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
                                        color: isDarkModeEnabled ? Colors.white : Colors.black,
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
          return MailModalBottomSheet(mail, index);
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

class MailModalBottomSheet extends StatefulWidget {
  final Mail mail;
  final int index;

  const MailModalBottomSheet(this.mail, this.index, {Key key}) : super(key: key);

  @override
  _MailModalBottomSheetState createState() => _MailModalBottomSheetState();
}

class _MailModalBottomSheetState extends State<MailModalBottomSheet> {
  bool monochromatic = false;

  getMonochromaticColors(String html) {
    if (!monochromatic) {
      return html;
    }
    String color = isDarkModeEnabled ? "white" : "black";
    String finalHTML = html.replaceAll("color", "taratata");
    return finalHTML;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder(
        future: readMail(this.widget.mail.id, this.widget.mail.read),
        builder: (context, snapshot) {
          String to = "";
          if (this.widget.mail.to != null) {
            this.widget.mail
              ..to.forEach((element) {
                to += element["name"] + " - ";
              });
          }
          if (snapshot.hasData && this.widget.mail.read == false) {
            SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
                  localList[this.widget.index].read = true;
                }));
          }
          return Container(
              height: screenSize.size.height / 10 * 8.0,
              padding: EdgeInsets.all(0),
              child: new Column(
                children: <Widget>[
                  Container(
                    height: screenSize.size.height / 10 * 1.0,
                    width: screenSize.size.width / 5 * 4.8,
                    child: FittedBox(
                      child: Column(
                        children: <Widget>[
                          Text(
                            this.widget.mail.subject,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (this.widget.mail.mtype != "send")
                                Container(
                                  width: screenSize.size.width / 5 * 2.6,
                                  height: screenSize.size.height / 10 * 0.45,
                                  padding: EdgeInsets.all(screenSize.size.height / 10 * 0.1),
                                  decoration: ShapeDecoration(shape: StadiumBorder(), color: Theme.of(context).primaryColorDark),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "de : ",
                                        style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: screenSize.size.height / 10 * 0.15, color: isDarkModeEnabled ? Colors.white70 : Colors.black87),
                                      ),
                                      Text(
                                        this.widget.mail.from["name"],
                                        style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: screenSize.size.height / 10 * 0.15, color: isDarkModeEnabled ? Colors.white70 : Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                              if (this.widget.mail.mtype != "received")
                                Container(
                                  padding: EdgeInsets.all(screenSize.size.height / 10 * 0.1),
                                  width: screenSize.size.width / 5 * 2.6,
                                  height: screenSize.size.height / 10 * 0.45,
                                  decoration: ShapeDecoration(shape: StadiumBorder(), color: Theme.of(context).primaryColorDark),
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "à : ",
                                          style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: screenSize.size.height / 10 * 0.15, color: isDarkModeEnabled ? Colors.white70 : Colors.black87),
                                        ),
                                        Container(
                                          width: screenSize.size.width / 5 * 2.1,
                                          height: screenSize.size.height / 10 * 0.45,
                                          child: Marquee(
                                            text: to,
                                            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: screenSize.size.height / 10 * 0.15, color: isDarkModeEnabled ? Colors.white70 : Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                width: screenSize.size.width / 5 * 1.3,
                                padding: EdgeInsets.all(screenSize.size.height / 10 * 0.1),
                                height: screenSize.size.height / 10 * 0.45,
                                decoration: ShapeDecoration(shape: StadiumBorder(), color: Theme.of(context).primaryColorDark),
                                child: FittedBox(
                                  child: Text(
                                    DateFormat("dd MMMM yyyy", "fr_FR").format(DateTime.parse(this.widget.mail.date)),
                                    style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: screenSize.size.height / 10 * 0.15, color: isDarkModeEnabled ? Colors.white70 : Colors.black87),
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
                            child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: screenSize.size.width / 5 * 0.2),
                                height: screenSize.size.height / 10 * 0.5,
                                width: screenSize.size.width / 5 * 3.5,
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColorDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(8),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      monochromatic = !monochromatic;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(monochromatic ? MdiIcons.eye : MdiIcons.eyeOutline, color: isDarkModeEnabled ? Colors.white : Colors.black),
                                      SizedBox(
                                        width: screenSize.size.width / 5 * 0.15,
                                      ),
                                      Text(
                                        monochromatic ? "Lecteur normal" : "Lecteur monochrome",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18, fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              HtmlWidget(
                                getMonochromaticColors(snapshot.data),
                                hyperlinkColor: Colors.blue.shade300,
                                onTapUrl: (url) async {
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw "Unable to launch url";
                                  }
                                },
                                textStyle: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 75),
                                width: screenSize.size.width / 5 * 4.4,
                                height: this.widget.mail.files.length * (screenSize.size.height / 10 * 0.7),
                                child: ListView.builder(
                                    itemCount: this.widget.mail.files.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.2),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.1),
                                          color: Color(0xff5FA9DA),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.5),
                                            child: Container(
                                              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0, color: Colors.transparent))),
                                              width: screenSize.size.width / 5 * 4.4,
                                              height: screenSize.size.height / 10 * 0.7,
                                              child: Stack(
                                                children: <Widget>[
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Container(
                                                      margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                                      width: screenSize.size.width / 5 * 2.8,
                                                      child: ClipRRect(
                                                        child: Marquee(text: this.widget.mail.files[index].libelle, blankSpace: screenSize.size.width / 5 * 0.2, style: TextStyle(fontFamily: "Asap", color: Colors.white)),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: screenSize.size.width / 5 * 0.1,
                                                    top: screenSize.size.height / 10 * 0.11,
                                                    child: Container(
                                                      height: screenSize.size.height / 10 * 0.5,
                                                      decoration: BoxDecoration(color: darken(Color(0xff5FA9DA)), borderRadius: BorderRadius.circular(50)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: <Widget>[
                                                          if ((this.widget.mail.files[index].libelle).contains("pdf"))
                                                            IconButton(
                                                              icon: Icon(
                                                                MdiIcons.eyeOutline,
                                                                color: Colors.white,
                                                              ),
                                                              onPressed: () {
                                                                // do something
                                                              },
                                                            ),
                                                          if ((this.widget.mail.files[index].libelle).contains("pdf"))
                                                            VerticalDivider(
                                                              width: 2,
                                                              color: Color(0xff5FA9DA),
                                                            ),
                                                          ViewModelBuilder<DownloadModel>.reactive(
                                                              viewModelBuilder: () => DownloadModel(),
                                                              builder: (context, model, child) {
                                                                return FutureBuilder(
                                                                    future: model.fileExists(this.widget.mail.files[index].libelle),
                                                                    initialData: false,
                                                                    builder: (context, snapshot) {
                                                                      if (snapshot.data == false) {
                                                                        if (model.isDownloading) {
                                                                          /// If download is in progress or connecting
                                                                          if (model.downloadProgress == null || model.downloadProgress < 100) {
                                                                            return Container(
                                                                              padding: EdgeInsets.symmetric(
                                                                                horizontal: screenSize.size.width / 5 * 0.2,
                                                                              ),
                                                                              child: Center(
                                                                                child: SizedBox(
                                                                                  width: screenSize.size.width / 5 * 0.3,
                                                                                  height: screenSize.size.width / 5 * 0.3,
                                                                                  child: CircularProgressIndicator(
                                                                                    backgroundColor: Colors.green,
                                                                                    strokeWidth: screenSize.size.width / 5 * 0.05,
                                                                                    value: model.downloadProgress,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }

                                                                          ///Download is ended
                                                                          else {
                                                                            return Container(
                                                                                child: IconButton(
                                                                              icon: Icon(
                                                                                MdiIcons.check,
                                                                                color: Colors.green,
                                                                              ),
                                                                              onPressed: () async {
                                                                                FileAppUtil.openFile(this.widget.mail.files[index].libelle, usingFileName: true);
                                                                              },
                                                                            ));
                                                                          }
                                                                        }

                                                                        ///Isn't downloading
                                                                        if (!model.isDownloading) {
                                                                          return IconButton(
                                                                            icon: Icon(
                                                                              MdiIcons.fileDownloadOutline,
                                                                              color: Colors.white,
                                                                            ),
                                                                            onPressed: () async {
                                                                              await model.download(this.widget.mail.files[index]);
                                                                            },
                                                                          );
                                                                        }
                                                                      }

                                                                      ///If file already exists
                                                                      else {
                                                                        return Container(
                                                                            child: IconButton(
                                                                          icon: Icon(
                                                                            MdiIcons.check,
                                                                            color: Colors.green,
                                                                          ),
                                                                          onPressed: () async {
                                                                            FileAppUtil.openFile(this.widget.mail.files[index].libelle, usingFileName: true);
                                                                          },
                                                                        ));
                                                                      }
                                                                    });
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ))
                        : SpinKitFadingFour(
                            color: Theme.of(context).primaryColorDark,
                            size: screenSize.size.width / 5 * 0.7,
                          ),
                  )
                ],
              ));
        });
  }
}
