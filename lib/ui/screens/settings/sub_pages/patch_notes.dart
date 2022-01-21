import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
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
                  onTapLink: (_, url, __) => url == null ? null : launch(url),
                  styleSheet: MarkdownStyleSheet(
                      p: theme.texts.body1,
                      h1: theme.texts.title.copyWith(fontSize: YFontSize.xl4),
                      h2: theme.texts.title.copyWith(fontSize: YFontSize.xl2),
                      h3: theme.texts.title.copyWith(fontSize: YFontSize.xl),
                      h4: theme.texts.title.copyWith(fontSize: YFontSize.lg),
                      h5: theme.texts.title.copyWith(fontSize: YFontSize.lg),
                      h6: theme.texts.title.copyWith(fontSize: YFontSize.lg),
                      a: TextStyle(color: theme.colors.primary.backgroundColor, fontWeight: YFontWeight.semibold),
                      pPadding: YPadding.pb(YScale.s4),
                      listBullet: theme.texts.body1.copyWith(color: theme.colors.foregroundColor),
                      listBulletPadding: YPadding.pb(YScale.s12),
                      listIndent: YScale.s4,
                      blockSpacing: YScale.s2)),
            ],
          ),
        ));
  }
}
