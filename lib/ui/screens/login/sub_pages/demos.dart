import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/login/w/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginDemosPage extends StatefulWidget {
  const LoginDemosPage({Key? key}) : super(key: key);

  @override
  State<LoginDemosPage> createState() => _LoginDemosPageState();
}

class _LoginDemosPageState extends State<LoginDemosPage> {
  late final List<_DemoServiceBox> _demos = [
    _DemoServiceBox(
      image: const AssetImage('assets/images/icons/ecoledirecte/EcoleDirecteIcon.png'),
      imageColor: theme.colors.foregroundColor,
      name: 'Ecole Directe',
      parser: 0,
      disabled: !_canNavigate,
      onTap: _onTap(() async {
        await appSys.api!.login("john.doe", "123456", additionnalSettings: {
          "demo": true,
        });
      }),
    ),
    _DemoServiceBox(
        image: const AssetImage('assets/images/icons/pronote/PronoteIcon.png'),
        name: 'Pronote',
        parser: 1,
        disabled: !_canNavigate,
        onTap: _onTap(
          () async {
            await appSys.api!.login("demonstration", "pronotevs", additionnalSettings: {
              "url": "https://demo.index-education.net/pronote/parent.html",
              "mobileCasLogin": false,
            });
          },
        ))
  ];

  AsyncCallback _onTap(AsyncCallback callback) {
    return () async {
      setState(() {
        _canNavigate = false;
      });

      await callback();
    };
  }

  bool _canNavigate = true;

  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
        backButton: _canNavigate,
        subtitle: "Choisis un service scolaire",
        body: Column(children: [
          Opacity(opacity: _canNavigate ? 1 : 0.5, child: Column(children: spacedChildren(_demos))),
          if (!_canNavigate)
            Column(
              children: [
                YVerticalSpacer(YScale.s2),
                const YLinearProgressBar(),
              ],
            )
        ]));
  }
}

class _DemoServiceBox extends StatefulWidget {
  final AssetImage image;
  final Color? imageColor;
  final String name;
  final int parser;
  final AsyncCallback onTap;
  final bool disabled;

  const _DemoServiceBox({
    Key? key,
    required this.image,
    this.imageColor,
    required this.name,
    required this.parser,
    required this.onTap,
    required this.disabled,
  }) : super(key: key);

  @override
  __DemoServiceBoxState createState() => __DemoServiceBoxState();
}

class __DemoServiceBoxState extends State<_DemoServiceBox> {
  @override
  Widget build(BuildContext context) {
    return LoginElementBox(
      children: [
        Image(
          image: widget.image,
          height: YScale.s12,
          width: YScale.s12,
          color: widget.imageColor,
        ),
        YHorizontalSpacer(YScale.s6),
        Text(
          widget.name,
          style: TextStyle(
            fontSize: YFontSize.xl,
            color: theme.colors.foregroundColor,
            fontWeight: YFontWeight.medium,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(),
        ),
      ],
      onTap: widget.disabled
          ? () {}
          : () async {
              await setChosenParser(widget.parser);

              await appSys.initOffline();
              setState(() {
                appSys.api = apiManager(appSys.offline);
              });
              await widget.onTap();
              Navigator.pushReplacementNamed(context, "/intro");
            },
    );
  }
}
