import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SchoolServiceBox extends StatefulWidget {
  final AssetImage? image;
  final Color? imageColor;
  final String name;
  final String route;
  final bool beta;
  final int? parser;

  const SchoolServiceBox(
      {Key? key, this.image, this.imageColor, required this.name, required this.route, this.beta = false, this.parser})
      : super(key: key);

  @override
  _SchoolServiceBoxState createState() => _SchoolServiceBoxState();
}

class _SchoolServiceBoxState extends State<SchoolServiceBox> {
  @override
  Widget build(BuildContext context) {
    return LoginElementBox(
      children: [
        if (widget.image == null) YVerticalSpacer(YScale.s12),
        if (widget.image != null)
          Image(
            image: widget.image!,
            height: YScale.s12,
            width: YScale.s12,
            color: widget.imageColor,
          ),
        if (widget.image != null) YHorizontalSpacer(YScale.s6),
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
            child: YBadge(text: LoginContent.widgets.schoolService.beta),
          )
      ],
      onTap: () async {
        if (widget.parser != null) {
          await setChosenParser(widget.parser!);
        }
        await appSys.initOffline();
        setState(() {
          appSys.api = apiManager(appSys.offline);
        });
        Navigator.pushNamed(context, widget.route);
      },
    );
  }
}
