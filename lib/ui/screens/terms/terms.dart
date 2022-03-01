import 'dart:io';

import 'package:flutter/material.dart';

import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/ui/components/components.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YPage(
      appBar: const YAppBar(title: "Termes et conditions", removeLeading: true),
      body: Padding(
          padding: YPadding.p(YScale.s2),
          child: Column(
            children: [
              FutureBuilder<String>(
                  future: FileStorage.loadProjectAsset("assets/documents/TOS_fr.txt"),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      Logger.log("LOGIN", "An error occured while getting the TOS");
                      Logger.error(snapshot.error, stackHint:"NQ==");
                    }
                    return Text(
                      snapshot.data.toString(),
                      style: theme.texts.body1,
                      textAlign: TextAlign.justify,
                    );
                  }),
              YVerticalSpacer(YScale.s8),
              YButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, (Platform.isAndroid || Platform.isIOS) ? "/intro" : "/intro/config");
                  },
                  text: "J'ACCEPTE",
                  block: true,
                  size: YButtonSize.large),
              YVerticalSpacer(YScale.s2),
              AppButtons.legalLinks
            ],
          )),
    );
  }
}
