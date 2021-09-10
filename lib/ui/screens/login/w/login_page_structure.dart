import 'package:flutter/material.dart';
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
              constraints: BoxConstraints(maxWidth: 600),
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
                            color: YColor.secondaryDark,
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
                        YButton(
                            text: "Mentions légales",
                            onPressed: () {},
                            variant: YButtonVariant.text,
                            color: YColor.secondaryLight),
                      ]),
                    ),
                    YVerticalSpacer(YScale.s16),
                    Row(
                      children: [Text("Contact", style: theme.texts.body1)],
                    )
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
