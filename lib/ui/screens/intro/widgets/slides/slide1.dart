import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

import '../widgets.dart';

class Slide1 extends StatelessWidget implements IntroSlideWidget {
  @override
  final YTColor color;

  @override
  final double offset;

  const Slide1({Key? key, required this.color, required this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideContent(
        offset: offset,
        children: [
          Transform.translate(
              offset: Offset(-offset * 600, 0),
              child: Image.asset(
                "assets/images/pageItems/intro/slide1/background.png",
              )),
          Positioned(
              bottom: 0,
              left: 40.vw - offset * 200,
              child: Image.asset(
                "assets/images/pageItems/intro/slide1/woman.png",
                height: 300,
              )),
          Positioned(
              top: 60,
              left: 25.vw - offset * 100,
              child: Image.asset(
                "assets/images/pageItems/intro/slide1/bubble.png",
                height: 80,
              )),
        ],
        text: TextSpan(
            text: "Pssst...tu savais que ",
            style: TextStyle(color: color.backgroundColor, fontSize: YFontSize.xl, fontFamily: theme.fonts.primary),
            children: const [
              TextSpan(text: "yNotes", style: TextStyle(fontWeight: YFontWeight.bold)),
              TextSpan(text: " ça se prononçait "),
              TextSpan(
                  text: "why notes", style: TextStyle(fontWeight: YFontWeight.semibold, fontStyle: FontStyle.italic)),
              TextSpan(children: [
                TextSpan(text: " ("),
                TextSpan(text: "/waɪ nəʊts/", style: TextStyle(fontStyle: FontStyle.italic, fontFamily: "")),
                TextSpan(text: " ) ?")
              ])
            ]));
  }
}
