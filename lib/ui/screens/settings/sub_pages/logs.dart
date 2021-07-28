import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/theme_utils.dart';

class LogsPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LogsPageState();
  }
}

class _LogsPageState extends State<LogsPage> {
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder<String>(
        future: CustomLogger.loadLogAsString(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: Container(
                    padding: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                    width: screenSize.size.width / 5 * 4.5,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      reverse: true,
                      child: SelectableText(
                        snapshot.data ?? "",
                        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                      ),
                    )));
          } else {
            return Container();
          }
        });
  }
}
