import 'package:flutter/material.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class AccountLoginStatus extends StatefulWidget {
  final AuthModule module;

  const AccountLoginStatus(this.module, {Key? key}) : super(key: key);

  @override
  _AccountLoginStatusState createState() => _AccountLoginStatusState();
}

class _AccountLoginStatusState extends State<AccountLoginStatus> {
  AuthStatus get status => widget.module.status;

  final String loggedTitle = "Tout va bien vous êtes connecté !";
  final String loggedLabel = "Les petits oiseaux chantent et le ciel est bleu.";

  final String offlineTitle = "Vous êtes hors ligne";
  final String offlineLabel = "Vous pouvez accéder à vos données hors ligne.";

  final String loggedOffTitle = "Vous êtes déconnecté";
  final String loggedOffLabel = "Nous vous connectons...";

  final String errorTitle = "Oups ! Une erreur s'est produite.";
  final String errorLabel =
      "Consultez tout d'abord l'erreur ci-dessous. Reconnectez-vous maintenant ou dans quelques minutes. Si le problème persiste, contactez le support.";

  String get title {
    switch (status) {
      case AuthStatus.authenticated:
        return loggedTitle;
      case AuthStatus.unauthenticated:
        return loggedOffTitle;
      case AuthStatus.error:
        return errorTitle;
      case AuthStatus.offline:
        return offlineTitle;
    }
  }

  String get label {
    switch (status) {
      case AuthStatus.authenticated:
        return loggedLabel;
      case AuthStatus.unauthenticated:
        return loggedOffLabel;
      case AuthStatus.error:
        return errorLabel;
      case AuthStatus.offline:
        return offlineLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: widget.module.color.backgroundColor,
      minVerticalPadding: YScale.s2,
      leading: Container(
        height: YScale.s12,
        width: YScale.s12,
        padding: YPadding.p(YScale.s2),
        decoration: BoxDecoration(
          borderRadius: YBorderRadius.full,
          color: widget.module.color.lightColor,
        ),
        child: FittedBox(child: widget.module.icon),
      ),
      title: Text(
        title,
        textAlign: TextAlign.start,
        style: theme.texts.body1.copyWith(
          color: widget.module.color.foregroundColor,
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
              color: widget.module.color.foregroundColor,
            ),
          ),
          if ([AuthStatus.error, AuthStatus.unauthenticated].contains(status)) errorDetails(context)
        ],
      ),
    );
  }

  Widget errorDetails(BuildContext context) {
    return Column(
      children: [
        if (widget.module.logs != null)
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
                  child: Text(widget.module.logs!, style: theme.texts.body1)),
            ],
          ),
        YVerticalSpacer(YScale.s4),
        Row(
          children: [
            YButton(
                onPressed: () async => await widget.module.loginFromOffline(),
                text: "Reconnexion",
                color: YColor.success),
            YHorizontalSpacer(YScale.s2),
            YButton(
              onPressed: () => BugReport.report(),
              text: "Support",
              color: status == AuthStatus.error ? YColor.danger : YColor.secondary,
              invertColors: true,
            ),
          ],
        )
      ],
    );
  }
}
