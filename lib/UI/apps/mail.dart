import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/apiManager.dart';

import '../../usefulMethods.dart';
import '../appsPage.dart';

class MailPage extends StatefulWidget {
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
  void initState() {}

  @override
  Widget build(BuildContext context) {
    mailsListFuture = api.app("mail");
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
                      Icon(MdiIcons.arrowLeft),
                      Text("Revenir aux applications",
                          style: TextStyle(fontFamily: "Asap", fontSize: 15)),
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
                            value: "Reçus",
                            iconSize: (screenSize.size.width / 5) * 0.3,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Asap",
                                color: isDarkModeEnabled
                                    ? Colors.white
                                    : Colors.black),
                            onChanged: (String newValue) {
                              setState(() {});
                            },
                            focusColor: Theme.of(context).primaryColor,
                            items: <String>[
                              'Reçus',
                              'Envoyés',
                              'Archivés',
                              'Autre'
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
                          height:
                              (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                          width: (screenSize.size.width / 5) * 0.6,
                          child: Icon(case2(actualSort, {
                            sortValue.date: MdiIcons.sortAscending,
                            sortValue.reversed_date: MdiIcons.sortDescending,
                            sortValue.author: MdiIcons.account,
                          }))),
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
            child: FutureBuilder(
                //Get all the mails
                future: mailsListFuture,
                builder: (context, snapshot) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Material(
                                  color: Theme.of(context).primaryColor,
                                  child: InkWell(
                                    child: Container(
                                      margin: EdgeInsets.all(0),
                                    
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left:screenSize.size.width / 5 * 0.2),
                                            child: Icon(
                                              MdiIcons.account,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left:screenSize.size.width / 5 * 0.4),
                                            width: screenSize.size.width / 5 * 4,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[

                                                Container(
                                                  
                                                  child: Text(
                                                      "Info sur la cantine miam",
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: "Asap",
                                                        fontSize:
                                                            screenSize.size.height /
                                                                10 *
                                                                0.25,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                ),
                                                Text(
                                                
                                                  "S. Tricot",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: "Asap",
                                                    fontSize:
                                                        screenSize.size.height /
                                                            10 *
                                                            0.2,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                    
                                                      "4 juin 2020",
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: "Asap",
                                                        fontSize:
                                                            screenSize.size.height /
                                                                10 *
                                                                0.2,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Icon(
                                                      MdiIcons.attachment
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
                                  height: screenSize.size.height / 10 * 0.005,
                                  thickness:
                                      screenSize.size.height / 10 * 0.005,
                                )
                              ],
                            );
                          }),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

getCorrespondingClasseur(stringName) {}
