import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/src/response.dart' as dioResponse;
import 'package:ynotes/UI/utils/fileUtils.dart';
import '../../../usefulMethods.dart';
import '../spacePage.dart';
import 'package:dio/dio.dart' as dio;

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
        borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
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
              height: screenSize.size.height / 10 * 1.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
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

class AppNews {
  static Future<List> checkAppNews() async {
    try {
      dioResponse.Response response = await dio.Dio().get(
          "https://raw.githubusercontent.com/ModernChocolate/ynotes-website/master/src/app-src/news.json",
          options: dio.Options(responseType: dio.ResponseType.plain));
      var dir = await FolderAppUtil.getDirectory();
      File jsonfile = File(dir.path + "/news.json");
      jsonfile.writeAsString(response.data.toString());
      Map map = json.decode(response.data.toString());
      List list = map["tickets"];
      list.sort((a, b) => a["ticketnb"].compareTo(b["ticketnb"]));
      return list.reversed.toList();
    } catch (e) {
      print("AppNews error (type0) " + e.toString());
      try {
        var dir = await FolderAppUtil.getDirectory();
        File jsonfile = File(dir.path + "/news.json");
        Map map = json.decode(await jsonfile.readAsString());
        List list = map["tickets"];
        list.sort((a, b) => a["ticketnb"].compareTo(b["ticketnb"]));
        return list.reversed.toList();
      } catch (e) {
        print("AppNews error (type1) " + e.toString());
        return null;
      }
    }
  }
}
