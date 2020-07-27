import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../usefulMethods.dart';

class LogsPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LogsPageState();
  }
}

class _LogsPageState extends State<LogsPage> {
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: new Text("Logs"),
          leading: IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            removeTop: true,
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: FutureBuilder(
                  future: getFileData(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                          child: Container(
                              height: screenSize.size.height,
                              width: screenSize.size.width / 5 * 4.5,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeBottom: true,
                                removeTop: true,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.zero,
                                  reverse: true,
                                  child: SelectableText(
                                    snapshot.data,
                                    style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                                  ),
                                ),
                              )));
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
        ));
  }
}

Future<String> getFileData() async {
  final dir = await getDirectory();
  final File file = File('${dir.path}/logs.txt');

  return await file.readAsString();
}
