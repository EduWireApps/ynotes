import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/drag_handle.dart';

///Bottom windows with some infos on the discipline and the possibility to change the discipline color
void contactBottomSheet(context) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return LoginContactModalBottomSheet();
      });
}

class LoginContactModalBottomSheet extends StatefulWidget {
  const LoginContactModalBottomSheet();

  @override
  _LoginContactModalBottomSheetState createState() => _LoginContactModalBottomSheetState();
}

class _LoginContactModalBottomSheetState extends State<LoginContactModalBottomSheet> {
  final List<_SpecialRoute> specialIcons = [
    _SpecialRoute(
        title: "Discord",
        icon: FontAwesomeIcons.discord,
        onTap: () async => await launch("https://discord.gg/pRCBs22dNX")),
    _SpecialRoute(
        title: "Github",
        icon: FontAwesomeIcons.github,
        onTap: () async => await launch("https://github.com/EduWireApps/ynotes")),
    _SpecialRoute(
        title: "Nous contacter", icon: Icons.mail, onTap: () async => await launch("https://ynotes.fr/contact/")),
    _SpecialRoute(
        title: "Centre d'aide", icon: Icons.help, onTap: () async => await launch("https://support.ynotes.fr/")),
  ];
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                color: Theme.of(context).primaryColor),
            padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: screenSize.size.height / 10 * 0.1,
                ),
                DragHandle(),
                Row(
                  children: [Spacer()],
                ),
                SizedBox(
                  height: screenSize.size.height / 10 * 0.1,
                ),
                _buildContactWays(),
                SizedBox(
                  height: screenSize.size.height / 10 * 0.1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildContactWays() {
    return Row(children: [
      for (final e in specialIcons)
        Expanded(
            child: IconButton(
          icon: Icon(e.icon),
          color: ThemeUtils.isThemeDark ? Colors.white : Colors.black87,
          onPressed: e.onTap,
        ))
    ]);
  }
}

class _SpecialRoute {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _SpecialRoute({required this.title, required this.icon, required this.onTap});
}
