import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../usefulMethods.dart';
import '../spacePage.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return Container(
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
                      color: isDarkModeEnabled ? Colors.white : Colors.black),
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
                                      color: isDarkModeEnabled ? Colors.white : Colors.black),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  child: Text("Recharger",
                                      style: TextStyle(
                                        fontFamily: "Asap",
                                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                                      )),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(18.0),
                                      side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return PageView.builder(
                              itemCount: (snapshot.data.length < 8 ? snapshot.data.length : 8),
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
                                              snapshot.data[index]["title"],
                                              style: TextStyle(
                                                  fontFamily: "Asap",
                                                  fontWeight: FontWeight.bold,
                                                  color: isDarkModeEnabled
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            SizedBox(
                                              width: screenSize.size.width / 5 * 4.3,
                                              child: Text(snapshot.data[index]["content"],
                                                  style: TextStyle(
                                                      fontFamily: "Asap",
                                                      color: isDarkModeEnabled
                                                          ? Colors.white
                                                          : Colors.black),
                                                  textAlign: TextAlign.center),
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
    );
  }
}
