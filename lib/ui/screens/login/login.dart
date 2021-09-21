import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static final List<_SchoolServiceBox> _services = [
    _SchoolServiceBox(
        image: const AssetImage('assets/images/icons/ecoledirecte/EcoleDirecteIcon.png'),
        imageColor: theme.colors.foregroundColor,
        name: 'Ecole Directe',
        route: '/login/ecoledirecte',
        index: 0),
    const _SchoolServiceBox(
        image: AssetImage('assets/images/icons/pronote/PronoteIcon.png'),
        name: 'Pronote',
        route: '/login/pronote',
        index: 1),
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
        backButton: false,
        subtitle: "Choisis ton service scolaire",
        body: Padding(
          padding: YPadding.px(YScale.s2),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ..._children,
            Padding(
              padding: YPadding.pt(YScale.s1),
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

class _SchoolServiceBox extends StatefulWidget {
  final AssetImage image;
  final Color? imageColor;
  final String name;
  final String route;
  final bool beta;
  final int index;

  const _SchoolServiceBox(
      {Key? key,
      required this.image,
      this.imageColor,
      required this.name,
      required this.route,
      this.beta = false,
      required this.index})
      : super(key: key);

  @override
  __SchoolServiceBoxState createState() => __SchoolServiceBoxState();
}

class __SchoolServiceBoxState extends State<_SchoolServiceBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: YBorderRadius.xl,
      onTap: () async {
        await setChosenParser(widget.index);
        await appSys.initOffline();
        setState(() {
          appSys.api = apiManager(appSys.offline);
        });
        Navigator.pushNamed(context, widget.route);
      },
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colors.backgroundLightColor,
          borderRadius: YBorderRadius.xl,
        ),
        padding: EdgeInsets.symmetric(vertical: YScale.s2, horizontal: YScale.s4),
        child: Row(
          children: [
            Image(
              image: widget.image,
              height: YScale.s12,
              width: YScale.s12,
              color: widget.imageColor,
            ),
            YHorizontalSpacer(YScale.s6),
            Flexible(
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: YFontSize.xl,
                  color: theme.colors.foregroundColor,
                  fontWeight: YFontWeight.medium,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.beta)
              Padding(
                padding: YPadding.pl(YScale.s4),
                child: const YBadge(text: "En bêta"),
              )
          ],
        ),
      ),
    );
  }
}
