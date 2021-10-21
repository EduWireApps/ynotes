import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';

import '../widgets.dart';

class Slide1 extends StatelessWidget implements IntroSlideWidget {
  @override
  final YTColor color;

  @override
  final double offset;

  const Slide1({Key? key, required this.color, required this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 0, left: 50.vw, child: Text("Offset: $offset", style: TextStyle(color: color.backgroundColor))),
        Positioned(
            top: 20, left: 50.vw - (offset * 30), child: Text("OTHER", style: TextStyle(color: color.backgroundColor))),
      ],
    );
  }
}
