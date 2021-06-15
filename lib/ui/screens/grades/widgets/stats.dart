import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/theme_utils.dart';

class ImpactStat extends StatefulWidget {
  final double? impact;
  final String? label;

  const ImpactStat({Key? key, this.impact, this.label}) : super(key: key);
  @override
  _ImpactState createState() => _ImpactState();
}

class _ImpactState extends State<ImpactStat> {
  getAdaptedColor() {
    if (widget.impact!.isNaN || widget.impact == null || widget.impact == 0) {
      return Colors.grey;
    }
    if (widget.impact! < 0) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  getText() {
    if (widget.impact!.isNaN || widget.impact == null || widget.impact == 0) {
      return "+0.0";
    } else {
      return (widget.impact! < 0 ? "" : "+") + widget.impact!.toStringAsFixed(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      width: screenSize.size.width,
      height: screenSize.size.height / 10 * 1,
      padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            width: screenSize.size.width / 5 * 0.8,
            height: screenSize.size.width / 5 * 0.8,
            padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
            decoration: BoxDecoration(color: getAdaptedColor(), borderRadius: BorderRadius.circular(20)),
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getText(),
                    style: TextStyle(
                      fontFamily: "Asap",
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: screenSize.size.height / 10 * 0.5,
            width: screenSize.size.width / 5 * 3,
            padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: AutoSizeText(
                    widget.label ?? "",
                    maxLines: 2,
                    style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w600, color: ThemeUtils.textColor()),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
