import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogsPageState();
  }
}

class _LogsPageState extends State<LogsPage> {
  String search = "";
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder<List<YLog>>(
        future: CustomLogger.getAllLogs(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<YLog> filteredLogs = snapshot.data!.where((log) {
              return log.category.toUpperCase().contains(search.toUpperCase());
            }).toList();
            return SizedBox(
              height: screenSize.size.height,
              width: screenSize.size.width,
              child: Column(
                children: [
                  Padding(
                    padding: YPadding.p(YScale.s2),
                    child: YFormField(
                        type: YFormFieldInputType.text,
                        label: "Filtrer",
                        properties: YFormFieldProperties(textInputAction: TextInputAction.search),
                        onChanged: (onChange) {
                          print(onChange);
                          setState(() {
                            search = onChange;
                          });
                        }),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: filteredLogs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(generateTitle(snapshot.data![index]), style: theme.texts.body1),
                            subtitle: Text(filteredLogs[index].comment,
                                maxLines: 3, overflow: TextOverflow.ellipsis, style: theme.texts.body2),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: theme.colors.primary.foregroundColor,
                              ),
                              onPressed: () async {
                                YLog log = filteredLogs[index];
                                await showDialog(
                                    context: context,
                                    builder: (_) => YDialogBase(
                                          title: "Actions",
                                          body: Column(
                                            children: [
                                              if (log.stacktrace != null)
                                                ListTile(
                                                  title: const Text('Copier la stack-trace'),
                                                  onTap: () {
                                                    Clipboard.setData(
                                                        ClipboardData(text: snapshot.data![index].stacktrace));
                                                  },
                                                ),
                                              ListTile(
                                                title: const Text('Copier en tant que JSON'),
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(text: jsonEncode(snapshot.data![index])));
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
                  ),
                ],
              ),
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
