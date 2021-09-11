import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPageStructure extends StatelessWidget {
  final String? backRouteName;
  final Widget body;

  const LoginPageStructure({Key? key, this.backRouteName, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.colors.backgroundColor,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: YPadding.p(YScale.s2),
                      child: Row(
                        mainAxisAlignment:
                            backRouteName != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                        children: [
                          if (backRouteName != null)
                            YButton(
                                text: "Retour",
                                onPressed: () {},
                                color: YColor.secondaryDark,
                                icon: Icons.arrow_back_ios_new_rounded),
                          YButton(
                            text: "Logs",
                            onPressed: () {},
                            variant: YButtonVariant.text,
                            color: YColor.secondaryLight,
                          ),
                        ],
                      ),
                    ),
                    YVerticalSpacer(YScale.s16),
                    Container(
                      width: double.infinity,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: YPadding.px(YScale.s2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Connexion",
                                  style: TextStyle(
                                      fontSize: YFontSize.xl6,
                                      fontWeight: YFontWeight.bold,
                                      color: theme.colors.foregroundColor)),
                              Text("Choisis ton service scolaire",
                                  style: TextStyle(
                                      fontSize: YFontSize.xl,
                                      fontWeight: YFontWeight.semibold,
                                      color: theme.colors.foregroundLightColor))
                            ],
                          ),
                        ),
                        YVerticalSpacer(YScale.s10),
                        body,
                        YVerticalSpacer(YScale.s6),
                        Padding(
                          padding: YPadding.px(YScale.s2),
                          child: YButton(
                              text: "Mentions légales",
                              onPressed: () async {
                                await showDialog(context: context, builder: (_) => LoginLegalLinksDialog());
                              },
                              variant: YButtonVariant.text,
                              color: YColor.secondaryLight),
                        ),
                      ]),
                    ),
                    YVerticalSpacer(YScale.s16),
                    _Contact()
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}

class _Contact extends StatelessWidget {
  const _Contact({Key? key}) : super(key: key);

  static const List<_ContactItem> _items = [
    _ContactItem(icon: FontAwesomeIcons.discord, url: "https://discord.gg/pRCBs22dNX"),
    _ContactItem(icon: Icons.help_rounded, url: "https://support.ynotes.fr/"),
    _ContactItem(icon: Icons.language_rounded, url: "https://ynotes.fr/contact/"),
    _ContactItem(icon: FontAwesomeIcons.github, url: "https://github.com/EduWireApps/ynotes"),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final item in _items)
          Expanded(
            child: InkWell(
                onTap: () => launch(item.url),
                child: Ink(
                  padding: YPadding.py(YScale.s4),
                  child: Icon(item.icon, color: theme.colors.foregroundLightColor, size: YScale.s6),
                )),
          )
      ],
    );
  }
}

class _ContactItem {
  final IconData icon;
  final String url;

  const _ContactItem({required this.icon, required this.url});
}
