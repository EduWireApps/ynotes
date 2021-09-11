import 'package:flutter/material.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final List<_SchoolServiceBox> _services = [
    _SchoolServiceBox(
        image: AssetImage('assets/images/icons/ecoledirecte/EcoleDirecteIcon.png'),
        imageColor: theme.colors.foregroundColor,
        name: 'Ecole Directe',
        route: '/login/ecoledirecte'),
    _SchoolServiceBox(
      image: AssetImage('assets/images/icons/pronote/PronoteIcon.png'),
      name: 'Pronote',
      route: '/login/pronote',
    ),
    // LA VIE SCOLAIRE, beta = true
  ];

  List<Widget> get _children {
    List<Widget> _els = [];
    final int _length = _services.length;

    for (int i = 0; i < _length + _length - 1; i++) {
      _els.add(i % 2 == 0 ? _services[i ~/ 2] : YVerticalSpacer(YScale.s2));
    }

    return _els;
  }

  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
        body: Padding(
      padding: YPadding.px(YScale.s2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ..._children,
        Padding(
          padding: YPadding.pt(YScale.s2),
          child: YButton(
            text: "Je ne vois pas mon service",
            variant: YButtonVariant.text,
            onPressed: () async {
              await YDialogs.showInfo(
                  context,
                  YInfoDialog(
                    title: "Je ne vois pas mon service",
                    body: Text(
                        "Si tu ne vois pas ton service scolaire dans la liste, c'est que yNotes ne le prend pas en charge. Mais si tu sais coder et que tu as envie de l'ajouter, nous t'invitons à prendre contact avec nous sur Github ou Discord.",
                        style: theme.texts.body1),
                    confirmLabel: "OK",
                  ));
            },
          ),
        )
      ]),
    ));
  }
}

class _SchoolServiceBox extends StatelessWidget {
  final AssetImage image;
  final Color? imageColor;
  final String name;
  final String route;
  final bool beta;

  const _SchoolServiceBox(
      {Key? key, required this.image, this.imageColor, required this.name, required this.route, this.beta = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: YBorderRadius.xl,
      onTap: () => Navigator.pushNamed(context, route),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colors.backgroundLightColor,
          borderRadius: YBorderRadius.xl,
        ),
        padding: EdgeInsets.symmetric(vertical: YScale.s2, horizontal: YScale.s4),
        child: Row(
          children: [
            Image(
              image: image,
              height: YScale.s12,
              width: YScale.s12,
              color: imageColor,
            ),
            YHorizontalSpacer(YScale.s6),
            Flexible(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: YFontSize.xl,
                  color: theme.colors.foregroundColor,
                  fontWeight: YFontWeight.medium,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (beta)
              Padding(
                padding: YPadding.pl(YScale.s4),
                child: YBadge(text: "En bêta"),
              )
          ],
        ),
      ),
    );
  }
}
