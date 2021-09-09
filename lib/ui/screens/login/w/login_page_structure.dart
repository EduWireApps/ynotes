import 'package:flutter/material.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPageStructure extends StatelessWidget {
  final String? backRouteName;

  const LoginPageStructure({Key? key, this.backRouteName}) : super(key: key);

  BoxConstraints _heightBoxConstraints(BuildContext context) =>
      BoxConstraints(minHeight: MediaQuery.of(context).size.height, maxHeight: MediaQuery.of(context).size.height);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.colors.backgroundColor,
        body: SafeArea(
            child: ConstrainedBox(
          constraints: _heightBoxConstraints(context),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: _heightBoxConstraints(context).copyWith(maxWidth: 600),
                child: Padding(
                  padding: YPadding.px(YScale.s2),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: YPadding.py(YScale.s2),
                        child: Row(
                          mainAxisAlignment:
                              backRouteName != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                          children: [
                            if (backRouteName != null)
                              YButton(
                                  text: "Retour",
                                  onPressed: () {},
                                  color: YColor.secondary,
                                  icon: Icons.arrow_back_ios_new_rounded),
                            YButton(
                              text: "Logs",
                              onPressed: () {},
                              color: YColor.secondary,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Column(
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
                          YVerticalSpacer(YScale.s12),
                          Column(
                            children: [Text("boxes")],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text("help + legal")],
                          ),
                        ]),
                      ),
                      Row(
                        children: [Text("Contact")],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )));
  }
}
