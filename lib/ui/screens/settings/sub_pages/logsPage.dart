import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/fileUtils.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/dialogs.dart';

Future<String> getFileData() async {
  try {
    final dir = await FolderAppUtil.getDirectory();
    final File file = File('${dir.path}/logs.txt');
    String toReturn = await file.readAsString();
    return toReturn;
  } catch (e) {
    return "";
  }
}

logFile(String text) async {
  print("logging");
  try {
    final directory = await FolderAppUtil.getDirectory();
    final File file = File('${directory.path}/logs.txt');
    String existingText = await getFileData();
    await file.writeAsString(
        DateTime.now().toString() + "\n" + text + "\n\n" + existingText,
        mode: FileMode.write);
  } catch (e) {
    print(e.toString());
  }
}

removeLogFile() async {
  print("Delete logs");
  final directory = await FolderAppUtil.getDirectory();
  final File file = File('${directory.path}/logs.txt');
  await file.writeAsString("");
}

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
          actions: [
            IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () async {
                bool? val = await (CustomDialogs.showConfirmationDialog(
                    context, null,
                    alternativeText:
                        "Voulez vous vraiment supprimer l'intégralité des logs (irréversible) ?"));
                if (val ?? false) {
                  await removeLogFile();
                  setState(() {});
                }
              },
            ),
          ],
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
              child: FutureBuilder<String>(
                  future: getFileData(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                          child: Container(
                              padding: EdgeInsets.only(
                                  top: screenSize.size.height / 10 * 0.2),
                              width: screenSize.size.width / 5 * 4.5,
                              child: SingleChildScrollView(
                                padding: EdgeInsets.zero,
                                reverse: true,
                                child: SelectableText(
                                  snapshot.data ?? "",
                                  style: TextStyle(
                                      fontFamily: "Asap",
                                      color: ThemeUtils.textColor()),
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
