import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/ui/components/NEW/buttons/buttons.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YPage(
      scrollable: true,
      appBar: const YAppBar(title: "Termes et conditions", removeLeading: true),
      body: Padding(
          padding: EdgeInsets.fromLTRB(YScale.s2, YScale.s2, Platform.isWindows ? YScale.s4 : YScale.s2, YScale.s2),
          child: Column(
            children: [
              FutureBuilder<String>(
                  future: FileAppUtil.loadAsset("assets/documents/TOS_fr.txt"),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      CustomLogger.log("LOGIN", "An error occured while getting the TOS");
                      CustomLogger.error(snapshot.error);
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
              if (kDebugMode)
                YButton(
                  onPressed: () async {
                    //reset KVS
                    await KVS.deleteAll();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  text: "[DEV ONLY] Retour",
                  block: true,
                  color: YColor.danger,
                ),
              YVerticalSpacer(YScale.s2),
              
              AppButtons.legalLinks
            ],
          )),
    );
  }
}
