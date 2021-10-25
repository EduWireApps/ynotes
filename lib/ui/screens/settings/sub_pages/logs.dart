import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes_packages/components.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogsPageState();
  }
}

class _LogsPageState extends State<LogsPage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder<List<YLog>>(
        future: CustomLogger.getAllLogs(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: screenSize.size.height,
              width: screenSize.size.width,
              child: ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(generateTitle(snapshot.data![index])),
                      subtitle: Text(snapshot.data![index].comment),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () async {
                          YLog log = snapshot.data![index];
                          await showDialog(
                              context: context,
                              builder: (_) => YDialogBase(
                                    title: "Actions",
                                    body: Column(
                                      children: [
                                        if (log.stacktrace != null)
                                          ListTile(
                                            title: Text('Copier la stack-trace'),
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(text: snapshot.data![index].stacktrace));
                                            },
                                          ),
                                        ListTile(
                                          title: Text('Copier en tant que JSON'),
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(text: jsonEncode(snapshot.data![index])));
                                          },
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                      ),
                      isThreeLine: true,
                    );
                  }),
            );
          } else {
            return Container();
          }
        });
  }

  generateTitle(YLog log) {
    String parsedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(log.date);
    return log.category + " - " + parsedDate;
  }
}
