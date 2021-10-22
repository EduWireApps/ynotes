import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

import '../widgets.dart';

class Slide3 extends StatelessWidget implements IntroSlideWidget {
  @override
  final YTColor color;

  @override
  final double offset;

  const Slide3({Key? key, required this.color, required this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideContent(
        offset: offset,
        children: [
          Positioned(
              top: 0,
              left: 0 - offset * 100,
              child: Image.asset(
                "assets/images/pageItems/intro/slide3/page2.png",
                height: 300,
              )),
          SizedBox(
            height: 50.vh,
            child: Transform.translate(
                offset: Offset(-offset * 400, 0),
                child: Image.asset(
                  "assets/images/pageItems/intro/slide3/page1.png",
                )),
          ),
          Positioned(
              bottom: 0,
              right: 10.vw - offset * 50,
              child: Image.asset(
                "assets/images/pageItems/intro/slide3/man.png",
                height: 300,
              )),
          Positioned(
              bottom: 50,
              left: 10.vw - offset * 120,
              child: Image.asset(
                "assets/images/pageItems/intro/slide3/lock.png",
                height: 100,
              )),
        ],
        text: TextSpan(
            text: "yNotes, c'est ",
            style: TextStyle(color: color.backgroundColor, fontSize: YFontSize.xl, fontFamily: theme.fonts.primary),
            children: const [
              TextSpan(text: "sécurisé", style: TextStyle(fontWeight: YFontWeight.bold)),
              TextSpan(text: ", tes données restent sur "),
              TextSpan(text: "ton", style: TextStyle(fontWeight: YFontWeight.bold)),
              TextSpan(text: " appareil."),
            ]));
  }
}
