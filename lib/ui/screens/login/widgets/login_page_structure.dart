import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/ui/components/NEW/components.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPageStructure extends StatelessWidget {
  final String subtitle;
  final bool backButton;
  final Widget body;

  const LoginPageStructure({Key? key, required this.subtitle, this.backButton = true, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: theme.colors.backgroundColor,
          body: SafeArea(
              child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: YPadding.p(YScale.s2),
                        child: Row(
                          mainAxisAlignment: backButton ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                          children: [
                            if (backButton)
                              YButton(
                                  text: LoginContent.widgets.structure.back,
                                  onPressed: () => Navigator.pop(context),
                                  color: YColor.secondary,
                                  icon: Icons.west),
                            YButton(
                              text: LoginContent.widgets.structure.logs,
                              onPressed: () => Navigator.pushNamed(context, "/settings/logs"),
                              variant: YButtonVariant.text,
                              color: YColor.secondary,
                              invertColors: true,
                            ),
                          ],
                        ),
                      ),
                      YVerticalSpacer(YScale.s8),
                      SizedBox(
                        width: double.infinity,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Padding(
                            padding: YPadding.px(YScale.s2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(LoginContent.widgets.structure.logIn,
                                    style: TextStyle(
                                        fontSize: YFontSize.xl6,
                                        fontWeight: YFontWeight.bold,
                                        color: theme.colors.foregroundColor)),
                                Text(subtitle,
                                    style: TextStyle(
                                        fontSize: YFontSize.xl,
                                        fontWeight: YFontWeight.semibold,
                                        color: theme.colors.foregroundLightColor))
                              ],
                            ),
                          ),
                          YVerticalSpacer(YScale.s5),
                          Padding(
                            padding: YPadding.px(YScale.s2),
                            child: body,
                          ),
                          YVerticalSpacer(YScale.s3),
                          Padding(
                            padding: YPadding.px(YScale.s2),
                            child: AppButtons.legalLinks,
                          ),
                        ]),
                      ),
                      YVerticalSpacer(YScale.s8),
                      const _Contact()
                    ],
                  ),
                ),
              ),
            ),
          ))),
    );
  }
}

class _Contact extends StatelessWidget {
  static const List<_ContactItem> _items = [
    _ContactItem(icon: FontAwesomeIcons.discord, url: "https://discord.gg/pRCBs22dNX"),
    _ContactItem(icon: Icons.help_rounded, url: "https://support.ynotes.fr/"),
    _ContactItem(icon: Icons.language_rounded, url: "https://ynotes.fr/contact/"),
    _ContactItem(icon: FontAwesomeIcons.github, url: "https://github.com/EduWireApps/ynotes"),
  ];

  const _Contact({Key? key}) : super(key: key);

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
