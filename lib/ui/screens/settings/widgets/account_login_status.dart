import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/shared/login_controller.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class AccountLoginStatus extends StatefulWidget {
  final LoginController controller;

  const AccountLoginStatus({Key? key, required this.controller}) : super(key: key);

  @override
  _AccountLoginStatusState createState() => _AccountLoginStatusState();
}

class _AccountLoginStatusState extends State<AccountLoginStatus> {
  final String loggedTitle = "Tout va bien vous êtes connecté !";

  final String loggedLabel = "Les petits oiseaux chantent et le ciel est bleu.";
  final String offlineTitle = "Vous êtes hors ligne";

  final String offlineLabel = "Vous pouvez accéder à vos données hors ligne.";
  final String loggedOffTitle = "Vous êtes déconnecté";

  final String loggedOffLabel = "Nous vous connectons...";
  final String errorTitle = "Oups ! Une erreur s'est produite.";

  final String errorLabel =
      "Consultez tout d'abord l'erreur ci-dessous. Reconnectez-vous maintenant ou dans quelques minutes. Si le problème persiste, contactez le support.";
  String get label {
    switch (state) {
      case loginStatus.loggedIn:
        return loggedLabel;
      case loginStatus.loggedOff:
        return loggedOffLabel;
      case loginStatus.error:
        return errorLabel;
      case loginStatus.offline:
        return offlineLabel;
    }
  }

  loginStatus get state => widget.controller.actualState;

  String get title {
    switch (state) {
      case loginStatus.loggedIn:
        return loggedTitle;
      case loginStatus.loggedOff:
        return loggedOffTitle;
      case loginStatus.error:
        return errorTitle;
      case loginStatus.offline:
        return offlineTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: widget.controller.color.backgroundColor,
      minVerticalPadding: YScale.s2,
      leading: Container(
        height: YScale.s12,
        width: YScale.s12,
        padding: YPadding.p(YScale.s2),
        decoration: BoxDecoration(
          borderRadius: YBorderRadius.full,
          color: widget.controller.color.lightColor,
        ),
        child: FittedBox(child: widget.controller.icon),
      ),
      title: Text(
        title,
        textAlign: TextAlign.start,
        style: theme.texts.body1.copyWith(
          color: widget.controller.color.foregroundColor,
          fontWeight: YFontWeight.semibold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YVerticalSpacer(YScale.s1),
          Text(
            label,
            textAlign: TextAlign.start,
            style: theme.texts.body1.copyWith(
              color: widget.controller.color.foregroundColor,
            ),
          ),
          if ([loginStatus.error, loginStatus.loggedOff].contains(state)) errorDetails(context)
        ],
      ),
    );
  }

  Widget errorDetails(BuildContext context) {
    return Column(
      children: [
        if (widget.controller.logs.isNotEmpty)
          Column(
            children: [
              YVerticalSpacer(YScale.s2),
              Container(
                  padding: YPadding.p(YScale.s2),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colors.backgroundColor,
                    borderRadius: YBorderRadius.lg,
                  ),
                  child: Text(widget.controller.logs, style: theme.texts.body1)),
            ],
          ),
        YVerticalSpacer(YScale.s4),
      ],
    );
  }
}
