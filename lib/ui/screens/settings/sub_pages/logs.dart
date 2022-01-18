// TODO: rework (lazy loading list)

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ynotes/legacy/logging_utils/logging_utils.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SettingsLogsPage extends StatefulWidget {
  const SettingsLogsPage({Key? key}) : super(key: key);

  @override
  _SettingsLogsPageState createState() => _SettingsLogsPageState();
}

class _SettingsLogsPageState extends State<SettingsLogsPage> {
  late Future<List<YLog>> logsFuture;

  int? _categoryId;
  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Logs"),
        onRefresh: refreshLogs,
        body: FutureBuilder(
          future: LogsManager.getCategories(),
          builder: (_, AsyncSnapshot<List<String>> snapshot) {
            List<YConfirmationDialogOption<int>> _options = [];
            List<String>? _categories;
            if (snapshot.hasData) {
              _categories = snapshot.data!..sort((a, b) => a.compareTo(b));
              _options = _categories.asMap().entries.map((entry) {
                final int i = entry.key;
                final String category = entry.value;
                return YConfirmationDialogOption<int>(
                  value: i,
                  label: category,
                );
              }).toList();
            }
            return Column(
              children: [
                if (_options.isNotEmpty)
                  Padding(
                    padding: YPadding.p(YScale.s2),
                    child: YFormField(
                        type: YFormFieldInputType.options,
                        expandable: false,
                        label: "Filtrer par catégorie",
                        properties: YFormFieldProperties(textInputAction: TextInputAction.search),
                        onChanged: _onSearchChanged,
                        options: _options),
                  ),
                Padding(
                  padding: YPadding.py(YScale.s4),
                  child: FutureBuilder(
                      future: logsFuture,
                      builder: (_, AsyncSnapshot<List<YLog>> snapshot) {
                        if (snapshot.hasData) {
                          final List<YLog> logs = snapshot.data!;
                          final List<YLog> filteredLogs = _categoryId == null
                              ? logs
                              : logs.where((log) => log.category == _categories![_categoryId!]).toList();
                          if (filteredLogs.isEmpty) {
                            return Text("Aucun log disponible.", style: theme.texts.body1);
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: YScale.s6, left: YScale.s2),
                                child: Text("${filteredLogs.length} log${filteredLogs.length > 1 ? 's' : ''}",
                                    style: theme.texts.body1),
                              ),
                              ListView.builder(
                                  itemCount: filteredLogs.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final YLog log = filteredLogs[index];
                                    return ListTile(
                                        title: Text(_generateTitle(log),
                                            style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor)),
                                        subtitle: Text(
                                          log.comment,
                                          style: theme.texts.body2,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Icon(Icons.copy_rounded, color: theme.colors.foregroundLightColor),
                                        onTap: () {
                                          if (log.stacktrace == null) {
                                            Clipboard.setData(ClipboardData(text: jsonEncode(log)));
                                            YSnackbars.success(context, message: "Copié !", hasIcon: false);
                                          } else {
                                            YModalBottomSheets.show(
                                                context: context,
                                                child: Column(
                                                  children: [
                                                    if (kDebugMode)
                                                      ListTile(
                                                        title: Text("Print le JSON", style: theme.texts.body1),
                                                        leading: Icon(Icons.code_rounded,
                                                            color: theme.colors.foregroundLightColor),
                                                        onTap: () {
                                                          Logger.logWrapped("JSON", "", jsonEncode(log));
                                                        },
                                                      ),
                                                    ListTile(
                                                      title: Text("Copier en tant que JSON", style: theme.texts.body1),
                                                      leading: Icon(Icons.code_rounded,
                                                          color: theme.colors.foregroundLightColor),
                                                      onTap: () {
                                                        Clipboard.setData(ClipboardData(text: jsonEncode(log)));
                                                        Navigator.pop(context);
                                                        YSnackbars.success(context, message: "Copié !", hasIcon: false);
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: Text("Copier la stack-trace", style: theme.texts.body1),
                                                      leading: Icon(Icons.bug_report_rounded,
                                                          color: theme.colors.foregroundLightColor),
                                                      onTap: () {
                                                        Clipboard.setData(
                                                            ClipboardData(text: jsonEncode(log.stacktrace)));
                                                        Navigator.pop(context);
                                                        YSnackbars.success(context, message: "Copié !", hasIcon: false);
                                                      },
                                                    )
                                                  ],
                                                ));
                                          }
                                        });
                                  }),
                              /*...filteredLogs
                                  .map((log) => ListTile(
                                      title: Text(_generateTitle(log),
                                          style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor)),
                                      subtitle: Text(
                                        log.comment,
                                        style: theme.texts.body2,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Icon(Icons.copy_rounded, color: theme.colors.foregroundLightColor),
                                      onTap: () {
                                        if (log.stacktrace == null) {
                                          Clipboard.setData(ClipboardData(text: jsonEncode(log)));
                                          YSnackbars.success(context, message: "Copié !", hasIcon: false);
                                        } else {
                                          YModalBottomSheets.show(
                                              context: context,
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    title: Text("Copier en tant que JSON", style: theme.texts.body1),
                                                    leading: Icon(Icons.code_rounded,
                                                        color: theme.colors.foregroundLightColor),
                                                    onTap: () {
                                                      Clipboard.setData(ClipboardData(text: jsonEncode(log)));
                                                      Navigator.pop(context);
                                                      YSnackbars.success(context, message: "Copié !", hasIcon: false);
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: Text("Copier la stack-trace", style: theme.texts.body1),
                                                    leading: Icon(Icons.bug_report_rounded,
                                                        color: theme.colors.foregroundLightColor),
                                                    onTap: () {
                                                      Clipboard.setData(
                                                          ClipboardData(text: jsonEncode(log.stacktrace)));
                                                      Navigator.pop(context);
                                                      YSnackbars.success(context, message: "Copié !", hasIcon: false);
                                                    },
                                                  )
                                                ],
                                              ));
                                        }
                                      }))
                                  .toList()*/
                            ],
                          );
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Chargement...", style: theme.texts.body1),
                              YVerticalSpacer(YScale.s2),
                              const SizedBox(width: 250, child: YLinearProgressBar())
                            ],
                          ),
                        );
                      }),
                ),
              ],
            );
          },
        ));
  }

  @override
  initState() {
    super.initState();
    refreshLogs();
  }

  Future<void> refreshLogs() async {
    setState(() {
      logsFuture = LogsManager.getLogs();
    });
    await logsFuture;
  }

  String _generateTitle(YLog log) {
    String parsedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(log.date);
    return "${log.category} - $parsedDate";
  }

  _onSearchChanged(String value) {
    setState(() {
      _categoryId = value.isEmpty ? null : int.parse(value[0]);
    });
  }
}
