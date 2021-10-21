import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:vector_math/vector_math_64.dart';

import '../widgets.dart';

class Slide2 extends StatelessWidget implements IntroSlideWidget {
  @override
  final YTColor color;

  @override
  final double offset;

  const Slide2({Key? key, required this.color, required this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(200 - offset * 20, 57),
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: FittedBox(
                        fit: BoxFit.fill, child: Image.asset('assets/images/pageItems/carousel/shelves/calendar.png'))),
              ),
              Transform.translate(
                offset: Offset(70 - offset * 20, -157),
                child: SizedBox(
                    height: 120,
                    width: 120,
                    child: FittedBox(
                        fit: BoxFit.fill, child: Image.asset('assets/images/pageItems/carousel/shelves/clock.png'))),
              ),
              Transform(
                transform: Matrix4.translationValues(0 - offset * 400, -90, 0)..rotateZ(offset * 0.1),
                child: SizedBox(
                    height: 170,
                    width: 320,
                    child: FittedBox(
                        fit: BoxFit.fill, child: Image.asset('assets/images/pageItems/carousel/shelves/shelve1.png'))),
              ),
              // Transform.translate(
              //   offset: Offset(0 - offset * 400, -90),
              //   child: SizedBox(
              //       height: 170,
              //       width: 320,
              //       child: FittedBox(
              //           fit: BoxFit.fill,
              //           child: Image.asset('assets/images/pageItems/carousel/shelves/shelve1.png'))),
              // ),
              Transform.translate(
                offset: Offset(0 - offset * 300, 90),
                child: SizedBox(
                    height: 90,
                    width: 320,
                    child: FittedBox(
                        fit: BoxFit.fill, child: Image.asset('assets/images/pageItems/carousel/shelves/shelve2.png'))),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 15,
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: Transform.translate(
              offset: Offset(-offset * 200, 0),
              child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  width: 50,
                  height: 140.0,
                  child: AutoSizeText.rich(
                      const TextSpan(
                        text: "...emmenez l'école",
                        children: <TextSpan>[
                          TextSpan(text: ' dans votre poche ! ', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "Asap", fontSize: 30.0, color: color.backgroundColor)))),
        )
      ],
    );
  }
}
