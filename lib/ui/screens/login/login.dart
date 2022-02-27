import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
      backButton: false,
      subtitle: LoginContent.login.subtitle,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: double.infinity,
            decoration: BoxDecoration(color: theme.colors.danger.lightColor, borderRadius: YBorderRadius.xl),
            padding: EdgeInsets.symmetric(vertical: YScale.s4, horizontal: YScale.s6),
            child: Text(
              """Lors du téléchargement de la 0.15, toutes vos données locales ont été supprimées. Cette étape contraignante est nécessaire pour permettre à yNotes d'atteindre la 1.0.\n\nMerci de votre compréhension !""",
              style: theme.texts.body1.copyWith(color: theme.colors.danger.foregroundColor),
              textAlign: TextAlign.justify,
            )),
        YVerticalSpacer(YScale.s10),
        ...spacedChildren(schoolApis.map((e) => SchoolServiceBox(e.metadata)).toList()),
        Padding(
          padding: YPadding.pt(YScale.s1),
          child: YButton(
            text: LoginContent.login.missingService,
            variant: YButtonVariant.text,
            onPressed: () async {
              await YDialogs.showInfo(
                  context,
                  YInfoDialog(
                    title: LoginContent.login.missingService,
                    body: Text(LoginContent.login.dialogBody, style: theme.texts.body1),
                    confirmLabel: "OK",
                  ));
            },
          ),
        ),
      ]),
    );
  }
}
