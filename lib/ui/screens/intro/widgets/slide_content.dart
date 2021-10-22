import 'package:flutter/material.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/utilities.dart';

class SlideContent extends StatelessWidget {
  final double offset;
  final List<Widget> children;
  final TextSpan text;

  const SlideContent({Key? key, required this.offset, required this.children, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: YPadding.p(YScale.s2),
      child: Center(
          child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(
          clipBehavior: Clip.none,
          children: children,
        ),
        YVerticalSpacer(YScale.s12),
        Transform.rotate(
          angle: offset * 0.1,
          child: RichText(
            textAlign: TextAlign.center,
            text: text,
          ),
        )
      ])),
    );
  }
}
