import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SettingsPatchNotesPage extends StatefulWidget {
  const SettingsPatchNotesPage({Key? key}) : super(key: key);

  @override
  _SettingsPatchNotesPageState createState() => _SettingsPatchNotesPageState();
}

class _SettingsPatchNotesPageState extends State<SettingsPatchNotesPage> {
  String? data;

  Future<void> fetchData() async {
    final String content = await FileStorage.loadProjectAsset(AppConfig.patchNotes.textPath);
    setState(() {
      data = content;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return YPage(
        appBar: const YAppBar(title: "Notes de mise à jour"),
        body: Padding(
          padding: YPadding.p(YScale.s4),
          child: Column(
            children: [
              Image(image: AssetImage(AppConfig.patchNotes.thumbnailPath)),
              YVerticalSpacer(YScale.s8),
              Markdown(
                  data: data ?? "**Chargement en cours...**",
                  selectable: true,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // TODO: take care of styles
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                    listBullet: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                    h1: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                    h2: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                    h3: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                    h4: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                    h5: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                    h6: TextStyle(fontFamily: "Asap", color: theme.colors.foregroundColor),
                  )),
            ],
          ),
        ));
  }
}
