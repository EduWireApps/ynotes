import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/screens/settingsPage.dart';
import 'package:ynotes/UI/screens/spacePageWidgets/downloadsExplorer.dart';
import 'package:ynotes/usefulMethods.dart';

import 'package:ynotes/UI/components/dialogs.dart';

class SpacePage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _SpacePageState();
  }
}

int segmentedControlGroupValue = 0;

class _SpacePageState extends State<SpacePage> with TickerProviderStateMixin {
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    final Map<int, Widget> spaceTabs = <int, Widget>{
      0: Text("Outils",
          style: TextStyle(
              color: isDarkModeEnabled ? Colors.white : Colors.black,
              fontFamily: "Asap",
              fontWeight: FontWeight.bold,
              fontSize: screenSize.size.width / 5 * 0.2)),
      1: Text("Organisation",
          style: TextStyle(
              color: isDarkModeEnabled ? Colors.white : Colors.black,
              fontFamily: "Asap",
              fontWeight: FontWeight.bold,
              fontSize: screenSize.size.width / 5 * 0.2))
    };

    return Container(
      width: screenSize.size.width / 5 * 3.2,
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(11),
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(router(SettingsPage()));
                },
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.2),
                  width: screenSize.size.width / 5 * 4.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.settings,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                      ),
                      Container(
                        child: Text(
                          "Accéder aux préférences",
                          style: TextStyle(
                              color: isDarkModeEnabled ? Colors.white : Colors.black,
                              fontFamily: "Asap",
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize.size.width / 5 * 0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    top: screenSize.size.height / 10 * 0.2,
                    bottom: screenSize.size.height / 10 * 0.4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Theme.of(context).primaryColorDark,
                ),
                height: screenSize.size.height / 10 * 7.5,
                padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: screenSize.size.height / 10 * 0.1,
                      ),
                      CupertinoSlidingSegmentedControl(
                        thumbColor: Theme.of(context).primaryColor,
                        backgroundColor: darken(Theme.of(context).primaryColorDark)
                        ,
                          groupValue: segmentedControlGroupValue,
                          children: spaceTabs,
                          onValueChanged: (i) {
                            setState(() {
                              segmentedControlGroupValue = i;
                            });
                          }),
                      SizedBox(
                        height: screenSize.size.height / 10 * 0.1,
                      ),
                      //Documents
                      Container(
                        height: screenSize.size.height / 10 * 6.8,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              DownloadsExplorer(),
                              //News
                              Container(
                            
                                margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Theme.of(context).primaryColor,
                                ),
                                width: screenSize.size.width / 5 * 4.5,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          width: screenSize.size.width / 5 * 4.5,
                                          margin: EdgeInsets.all(screenSize.size.width / 5 * 0.2),
                                          child: Text(
                                            "Actualité",
                                            style: TextStyle(
                                                fontFamily: "Asap",
                                                fontWeight: FontWeight.bold,
                                                color: isDarkModeEnabled
                                                    ? Colors.white
                                                    : Colors.black),
                                            textAlign: TextAlign.left,
                                          )),
                                      Container(
                                        height: screenSize.size.height / 10 * 1.8,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(11),
                                          child: FutureBuilder(
                                              future: AppNews.checkAppNews(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data == null) {
                                                    return Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            "Une erreur a eu lieu",
                                                            style: TextStyle(
                                                                fontFamily: "Asap",
                                                                color: isDarkModeEnabled
                                                                    ? Colors.white
                                                                    : Colors.black),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () {
                                                              setState(() {});
                                                            },
                                                            child: Text("Recharger",
                                                                style: TextStyle(
                                                                  fontFamily: "Asap",
                                                                  color: isDarkModeEnabled
                                                                      ? Colors.white
                                                                      : Colors.black,
                                                                )),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius.circular(18.0),
                                                                side: BorderSide(
                                                                    color: Theme.of(context)
                                                                        .primaryColorDark)),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return PageView.builder(
                                                        itemCount: (snapshot.data.length < 8
                                                            ? snapshot.data.length
                                                            : 8),
                                                        scrollDirection: Axis.horizontal,
                                                        itemBuilder: (context, index) {
                                                          return SingleChildScrollView(
                                                            child: CupertinoScrollbar(
                                                              child: Container(
                                                              
                                                                child: SingleChildScrollView(
                                                                  child: Column(
                                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      Text(
                                                                        snapshot.data[index]
                                                                            ["title"],
                                                                        style: TextStyle(
                                                                            fontFamily: "Asap",
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: isDarkModeEnabled
                                                                                ? Colors.white
                                                                                : Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            screenSize.size.width /
                                                                                5 *
                                                                                4.3,
                                                                        child: Text(
                                                                            snapshot.data[index]
                                                                                ["content"],
                                                                            style: TextStyle(
                                                                                fontFamily: "Asap",
                                                                                color:
                                                                                    isDarkModeEnabled
                                                                                        ? Colors
                                                                                            .white
                                                                                        : Colors
                                                                                            .black),
                                                                            textAlign:
                                                                                TextAlign.center),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  }
                                                } else {
                                                  return SpinKitFadingFour(
                                                    color: Theme.of(context).primaryColorDark,
                                                    size: screenSize.size.width / 5 * 1,
                                                  );
                                                }
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //News
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
