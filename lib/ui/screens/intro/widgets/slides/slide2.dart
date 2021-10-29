import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

import '../widgets.dart';

/// Subject: notifications
class Slide2 extends StatelessWidget implements IntroSlideWidget {
  @override
  final YTColor color;

  @override
  final double offset;

  /// Subject: notifications
  const Slide2({Key? key, required this.color, required this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideContent(
        offset: offset,
        children: [
          Transform.translate(
              offset: Offset(-offset * 400, 0),
              child: Image.asset(
                "assets/images/pageItems/intro/slide2/phone.png",
              )),
          Positioned(
              top: 60,
              left: 5.vw + offset * 800,
              child: Image.asset(
                "assets/images/pageItems/intro/slide2/notif1.png",
                height: 60,
              )),
          Positioned(
              top: 260,
              left: 20.vw - offset * 2000,
              child: Image.asset(
                "assets/images/pageItems/intro/slide2/notif2.png",
                height: 100,
              )),
        ],
        text: TextSpan(
            style: TextStyle(color: color.backgroundColor, fontSize: YFontSize.xl, fontFamily: theme.fonts.primary),
            children: const [
              TextSpan(text: "Sois "),
              TextSpan(text: "notifié", style: TextStyle(fontWeight: YFontWeight.bold)),
              TextSpan(text: " en temps réel !"),
            ]));
  }
}
