import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SchoolServiceBox extends StatefulWidget {
  final Metadata metadata;

  const SchoolServiceBox(this.metadata, {Key? key}) : super(key: key);

  @override
  _SchoolServiceBoxState createState() => _SchoolServiceBoxState();
}

class _SchoolServiceBoxState extends State<SchoolServiceBox> {
  AssetImage get image => AssetImage(widget.metadata.imagePath);

  @override
  Widget build(BuildContext context) {
    return LoginElementBox(
      backgroundColor: widget.metadata.color.backgroundColor,
      children: [
        Image(
          image: image,
          height: YScale.s12,
          width: YScale.s12,
          color: widget.metadata.coloredLogo ? widget.metadata.color.foregroundColor : null,
        ),
        YHorizontalSpacer(YScale.s6),
        Flexible(
          child: Text(
            widget.metadata.name,
            style: TextStyle(
              fontSize: YFontSize.xl,
              color: widget.metadata.color.foregroundColor,
              fontWeight: YFontWeight.medium,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.metadata.beta)
          Padding(
            padding: YPadding.pl(YScale.s4),
            child: YBadge(
              text: LoginContent.widgets.schoolService.beta,
              color: YColor.danger,
            ),
          )
      ],
      onTap: () {
        setState(() {
          schoolApi = schoolApiManager(widget.metadata.api);
        });
        Navigator.pushNamed(context, widget.metadata.loginRoute);
      },
    );
  }
}
