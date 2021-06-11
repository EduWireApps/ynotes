import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/apis/EcoleDirecte.dart';
import 'package:ynotes/core/logic/mails/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/customLoader.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/textField.dart';
import 'package:ynotes/ui/mixins/layoutMixin.dart';
import 'package:ynotes/ui/screens/mail/mailPageWidgets/readMailBottomSheet.dart';
import 'package:ynotes/usefulMethods.dart';

String? dossier = "Reçus";

List<Mail> localList = [];
StreamSubscription? loginconnexion;
late Future<List<Mail>?>? mailsListFuture;
Future<void> mailModalBottomSheet(context, Mail mail, {int? index}) async {
  await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return ReadMailBottomSheet(mail);
      });
}

class MailPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldState;

  const MailPage({Key? key, required this.parentScaffoldState}) : super(key: key);

  @override
  _MailPageState createState() => _MailPageState();
}

enum sortValue { date, reversed_date, author }

class _MailPageState extends State<MailPage> with Layout {
  TextEditingController searchCon = TextEditingController();
  var actualSort = sortValue.date;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return Scaffold(
      appBar: new AppBar(
          title: new Text(
            "Messagerie",
            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
          ),
          leading: !isLargeScreen
              ? TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                  child: Icon(MdiIcons.menu, color: ThemeUtils.textColor()),
                  onPressed: () async {
                    widget.parentScaffoldState.currentState?.openDrawer();
                  },
                )
              : null,
          backgroundColor: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        color: Theme.of(context).backgroundColor,
        height: screenSize.size.height,
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: refreshLocalMailsList,
              child: ChangeNotifierProvider<MailsController>.value(
                value: appSys.mailsController,
                child: Consumer<MailsController>(builder: (context, model, child) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                        height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                        width: (screenSize.size.width / 5) * 2.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Theme.of(context).primaryColor,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: dossier,
                                      iconEnabledColor: ThemeUtils.textColor(),
                                      style: TextStyle(fontSize: 18, fontFamily: "Asap", color: ThemeUtils.textColor()),
                                      onChanged: (String? newValue) {
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
                                                fontSize: 18, fontFamily: "Asap", color: ThemeUtils.textColor()),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              width: screenSize.size.width / 5 * 0.003,
                              thickness: screenSize.size.width / 5 * 0.003,
                              color: ThemeUtils.textColor(),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                child: Material(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        int index = sortValue.values.indexOf(actualSort);
                                        actualSort =
                                            sortValue.values[index + (index == sortValue.values.length - 1 ? -2 : 1)];
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
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: CustomTextField(searchCon, "Chercher un mail", false, Icons.search, false)),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                          child: Builder(
                              //Get all the mails

                              builder: (context) {
                            if (!model.loading || !(model.mails == null)) {
                              localList = getCorrespondingClasseur(dossier, model.mails);
                              return ClipRRect(
                                child: MediaQuery.removePadding(
                                  removeTop: true,
                                  context: context,
                                  child: ListView.builder(
                                      itemCount: filterMails(localList).length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Material(
                                                color: filterMails(localList)[index].read ?? false
                                                    ? Theme.of(context).backgroundColor
                                                    : Theme.of(context).primaryColor,
                                                child: InkWell(
                                                    onTap: () async {
                                                      await mailModalBottomSheet(context, filterMails(localList)[index],
                                                          index: index);
                                                      refreshLocalMailsList(forceReload: false);
                                                    },
                                                    child: Container(
                                                        height: screenSize.size.height / 10 * 1,
                                                        margin: EdgeInsets.all(0),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Container(
                                                              margin: EdgeInsets.only(
                                                                  left: screenSize.size.width / 5 * 0.2),
                                                              child: Icon(
                                                                MdiIcons.account,
                                                                color: ThemeUtils.textColor(),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                margin: EdgeInsets.only(
                                                                    left: screenSize.size.width / 5 * 0.1),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Container(
                                                                      child: Text(
                                                                        filterMails(localList)[index].subject ?? "",
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
                                                                      filterMails(localList)[index].from?["name"] ?? "",
                                                                      textAlign: TextAlign.start,
                                                                      style: TextStyle(
                                                                        fontFamily: "Asap",
                                                                        fontSize: screenSize.size.height / 10 * 0.2,
                                                                        color: ThemeUtils.isThemeDark
                                                                            ? Colors.white60
                                                                            : Colors.black87,
                                                                      ),
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                    Row(
                                                                      children: <Widget>[
                                                                        Text(
                                                                          filterMails(localList)[index].date!,
                                                                          textAlign: TextAlign.start,
                                                                          style: TextStyle(
                                                                            fontFamily: "Asap",
                                                                            fontSize:
                                                                                screenSize.size.height / 10 * 0.25,
                                                                            color: ThemeUtils.textColor(),
                                                                          ),
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            if (!(filterMails(localList)[index].read ?? true))
                                                              Expanded(child: Container(width: 10, color: Colors.blue))
                                                          ],
                                                        )))),
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
                            } else {
                              return SizedBox(
                                width: screenSize.size.width,
                                height: screenSize.size.height,
                                child: Center(
                                  child: CustomLoader(screenSize.size.width / 5 * 2.5, screenSize.size.width / 5 * 2.5,
                                      Theme.of(context).primaryColor),
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            if (!Platform.isLinux)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(
                      right: screenSize.size.width / 5 * 0.1, bottom: screenSize.size.height / 10 * 0.4),
                  child: _buildFloatingButton(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  filterMails(List<Mail>? mails) {
    if (mails != null && mails.length != 0) {
      return mails
          .where((element) =>
              (element.subject ?? "").toUpperCase().contains(searchCon.text.toUpperCase()) ||
              (element.content ?? "").toUpperCase().contains(searchCon.text.toUpperCase()) ||
              element.from.toString().toUpperCase().contains(searchCon.text.toUpperCase()))
          .toList();
    }
    return mails;
  }

  List<Mail> getCorrespondingClasseur(dossier, List<Mail>? list) {
    String? trad;
    List<Mail> toReturn = [];
    switch (dossier) {
      case "Reçus":
        trad = "received";
        break;
      case "Envoyés":
        trad = "send";
        break;
    }
    if (list != null) {
      list.forEach((element) {
        if (element.mtype == trad) {
          toReturn.add(element);
        }
      });
      toReturn.sort((a, b) {
        DateTime datea = DateTime.parse(a.date!);
        DateTime dateb = DateTime.parse(b.date!);
        switch (actualSort) {
          case (sortValue.date):
            return dateb.compareTo(datea);
          case (sortValue.reversed_date):
            return datea.compareTo(dateb);
          case (sortValue.author):
            return b.from?["nom"].compareTo(a.from?["nom"]);
        }
        return 1;
      });
      return toReturn;
    } else {
      return toReturn;
    }
  }

  void initState() {
    super.initState();
    mailsListFuture = (appSys.api as APIEcoleDirecte?)?.getMails();
    refreshLocalMailsList();
    refreshLocalMailsList(forceReload: true);

    searchCon.addListener(() {
      setState(() {});
    });
  }

  Future<void> refreshLocalMailsList({forceReload = true}) async {
    await appSys.mailsController.refresh(force: forceReload);
  }

  _buildFloatingButton(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
        child: FloatingActionButton(
      heroTag: "btn1",
      backgroundColor: Colors.transparent,
      child: Container(
        width: 120,
        height: 120,
        padding: EdgeInsets.all(5),
        child: FittedBox(
          child: Center(
            child: Icon(
              Icons.mail_outline,
              size: 80,
            ),
          ),
        ),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff100A30)),
      ),
      onPressed: () async {
        await CustomDialogs.writeModalBottomSheet(context);
      },
    ));
  }
}
