import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/shared/login_controller.dart';
import 'package:ynotes/core/utils/bugreport_utils.dart';
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
  loginStatus get state => widget.controller.actualState;

  YTColor get color {
    switch (state) {
      case loginStatus.loggedIn:
        return theme.colors.success;
      case loginStatus.loggedOff:
        return theme.colors.secondary;
      case loginStatus.error:
        return theme.colors.danger;
      case loginStatus.offline:
        return theme.colors.warning;
    }
  }

  Widget get icon {
    switch (state) {
      case loginStatus.loggedIn:
        return Icon(Icons.check_rounded, color: color.foregroundColor);
      case loginStatus.loggedOff:
        return SpinKitThreeBounce(color: color.foregroundColor);
      case loginStatus.error:
        return Icon(Icons.new_releases_rounded, color: color.foregroundColor);
      case loginStatus.offline:
        return Icon(MdiIcons.networkStrengthOff, color: color.foregroundColor);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color.backgroundColor,
      minVerticalPadding: YScale.s2,
      leading: Container(
        height: YScale.s12,
        width: YScale.s12,
        padding: YPadding.p(YScale.s2),
        decoration: BoxDecoration(
          borderRadius: YBorderRadius.full,
          color: color.lightColor,
        ),
        child: FittedBox(child: icon),
      ),
      title: Text(
        title,
        textAlign: TextAlign.start,
        style: theme.texts.body1.copyWith(
          color: color.foregroundColor,
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
              color: color.foregroundColor,
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
        Row(
          children: [
            YButton(onPressed: () => widget.controller.login(), text: "Reconnexion", color: YColor.success),
            YHorizontalSpacer(YScale.s2),
            YButton(
              onPressed: () => BugReportUtils.report(),
              text: "Support",
              color: state == loginStatus.error ? YColor.danger : YColor.secondary,
              invertColors: true,
            ),
          ],
        )
      ],
    );
  }
}
