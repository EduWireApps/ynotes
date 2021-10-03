import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPronotePage extends StatelessWidget {
  const LoginPronotePage({Key? key}) : super(key: key);

  static final List<_MethodBox> _methods = [
    const _MethodBox(
        title: "QR Code", subtitle: "Cheese !", route: "/login/pronote/qrcode", icon: Icons.qr_code_scanner_rounded),
    const _MethodBox(
        title: "Géolocalisation", subtitle: "On sait où tu es", route: "/login/pronote/geolocation", icon: Icons.place),
    _MethodBox(
        title: "Url",
        subtitle: "Pose les termes",
        route: "/login/pronote/url",
        icon: MdiIcons.cursorText,
        supported: !(kIsWeb || Platform.isWindows || Platform.isLinux)),
  ];

  List<Widget> get _children {
    List<Widget> _els = [];
    final int _length = _methods.length;

    for (int i = 0; i < _length + _length - 1; i++) {
      _els.add(i % 2 == 0 ? _methods[i ~/ 2] : YVerticalSpacer(YScale.s2));
    }

    return _els;
  }

  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
      subtitle: "Choisis un moyen de connexion",
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _children),
    );
  }
}

class _MethodBox extends StatefulWidget {
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final bool supported;

  const _MethodBox(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.route,
      required this.icon,
      this.supported = true})
      : super(key: key);

  @override
  __SchoolServiceBoxState createState() => __SchoolServiceBoxState();
}

class __SchoolServiceBoxState extends State<_MethodBox> {
  Widget opacity(Widget child) => Opacity(opacity: widget.supported ? 1 : 0.5, child: child);

  @override
  Widget build(BuildContext context) {
    return LoginElementBox(
        children: [
          opacity(Icon(
            widget.icon,
            color: theme.colors.foregroundLightColor,
            size: YScale.s12,
          )),
          YHorizontalSpacer(YScale.s4),
          Flexible(
            child: opacity(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: YFontSize.xl,
                    color: theme.colors.foregroundColor,
                    fontWeight: YFontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: YFontSize.lg,
                    color: theme.colors.foregroundLightColor,
                    fontWeight: YFontWeight.medium,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )),
          ),
          YHorizontalSpacer(YScale.s4),
          if (!widget.supported)
            YBadge(text: "Indisponible sur ${Platform.operatingSystem.capitalize()}", color: YColor.danger)
        ],
        onTap: widget.supported
            ? () async {
                Navigator.pushNamed(context, widget.route);
              }
            : null);
  }
}
