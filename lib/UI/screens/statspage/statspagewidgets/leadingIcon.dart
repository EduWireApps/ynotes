import 'package:flutter/material.dart';
import 'package:ynotes/utils/themeUtils.dart';

class LeadingAndSubtitle extends StatefulWidget {
  final Widget leading;
  final String subtitle;
  final Color color;
  const LeadingAndSubtitle({Key key, @required this.leading, @required this.subtitle, this.color}) : super(key: key);
  @override
  _LeadingAndSubtitleState createState() => _LeadingAndSubtitleState();
}

class _LeadingAndSubtitleState extends State<LeadingAndSubtitle> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
      decoration: BoxDecoration(
          border: Border.all(color: widget.color ?? ThemeUtils.textColor()), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          widget.leading,
          Text(
            widget.subtitle,
            style: TextStyle(
                fontFamily: "Asap",
                color: widget.color ?? ThemeUtils.textColor(),
                fontWeight: FontWeight.w200,
                fontSize: 14),
          )
        ],
      ),
    );
  }
}
