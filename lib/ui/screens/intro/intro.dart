import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ynotes/core/utils/app_colors.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/ui/screens/intro/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

// TODO: to migrate to ynotes_packages/theme
class YTColorTween extends Tween<YTColor> {
  final YTColor _begin;
  final YTColor _end;
  YTColorTween(this._begin, this._end) : super(begin: _begin, end: _end);

  @override
  YTColor lerp(double t) => YTColor(
      lightColor: Color.lerp(_begin.lightColor, _end.lightColor, t) ?? _begin.lightColor,
      backgroundColor: Color.lerp(_begin.backgroundColor, _end.backgroundColor, t) ?? _begin.backgroundColor,
      foregroundColor: Color.lerp(_begin.foregroundColor, _end.foregroundColor, t) ?? _begin.foregroundColor);
}

class TMP extends StatelessWidget {
  final double offset;
  const TMP({Key? key, required this.offset}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 0, left: 50.vw, child: Text("Offset: $offset")),
        Positioned(top: 20, left: 50.vw - (offset * 30), child: Text("OTHER"))
      ],
    );
  }
}

class TMP2 extends StatelessWidget implements IntroSlideWidget {
  @override
  final YTColor color;

  @override
  final double offset;

  const TMP2({Key? key, required this.color, required this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
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
                          fit: BoxFit.fill,
                          child: Image.asset('assets/images/pageItems/carousel/shelves/calendar.png'))),
                ),
                Transform.translate(
                  offset: Offset(70 - offset * 20, -157),
                  child: SizedBox(
                      height: 120,
                      width: 120,
                      child: FittedBox(
                          fit: BoxFit.fill, child: Image.asset('assets/images/pageItems/carousel/shelves/clock.png'))),
                ),
                Transform.translate(
                  offset: Offset(0 - offset * 400, -90),
                  child: SizedBox(
                      height: 170,
                      width: 320,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset('assets/images/pageItems/carousel/shelves/shelve1.png'))),
                ),
                Transform.translate(
                  offset: Offset(0 - offset * 300, 90),
                  child: SizedBox(
                      height: 90,
                      width: 320,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset('assets/images/pageItems/carousel/shelves/shelve2.png'))),
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
                    child: const AutoSizeText.rich(
                        TextSpan(
                          text: "...emmenez l'école",
                          children: <TextSpan>[
                            TextSpan(text: ' dans votre poche ! ', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Asap", fontSize: 30.0)))),
          )
        ],
      ),
    );
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

abstract class IntroSlideWidget extends StatelessWidget {
  @protected
  final YTColor color;

  @protected
  final double offset;

  const IntroSlideWidget({Key? key, required this.color, required this.offset}) : super(key: key);
}

class Test2 extends StatelessWidget implements IntroSlideWidget {
  @override
  final YTColor color;

  @override
  final double offset;

  const Test2({Key? key, required this.color, required this.offset}) : super(key: key);

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

class Test {
  final IntroSlideWidget Function(double offset, YTColor color) widget;
  final YTColor color;

  Test(this.widget, this.color);
}

class _IntroPageState extends State<IntroPage> {
  double _pageOffset = 0.0;
  int _pageIndex = 0;
  late final PageController _pageController = PageController(initialPage: _pageIndex);
  final Duration _duration = const Duration(milliseconds: 250);
  final Curve _curve = Curves.easeInOut;

  List<IntroSlide> get _pages {
    final List<Test> pages = [
      Test((double offset, YTColor color) => Test2(offset: offset, color: color), AppColors.blue),
      Test((double offset, YTColor color) => Test2(offset: offset, color: color), AppColors.red),
      Test((double offset, YTColor color) => Test2(offset: offset, color: color), AppColors.green),
      Test((double offset, YTColor color) => TMP2(offset: offset, color: color), AppColors.teal),
      Test((double offset, YTColor color) => Test2(offset: offset, color: color), AppColors.purple),
    ];
    return pages.asMap().entries.map((entry) {
      final int id = entry.key;
      final Test value = entry.value;
      return IntroSlide(widget: value.widget(_pageOffset - id, value.color), color: value.color);
    }).toList();
  }

  YTColor get _color {
    if (_pageOffset.toInt() + 1 < _pages.length) {
      final YTColor current = _pages[_pageOffset.toInt()].color;
      final YTColor next = _pages[_pageOffset.toInt() + 1].color;
      final YTColorTween tween = YTColorTween(current, next);
      final res = tween.lerp(_pageOffset - _pageOffset.toInt());
      return res;
    } else {
      return _pages.last.color;
    }
  }

  Color get _backgroundColor =>
      _pageOffset.toInt() + 1 < _pages.length ? _color.backgroundColor : _pages.last.color.backgroundColor;

  Color get _foregroundColor {
    final Color res =
        _pageOffset.toInt() + 1 < _pages.length ? _color.foregroundColor : _pages.last.color.foregroundColor;
    UIUtils.setSystemUIOverlayStyle(systemNavigationBarColor: res);
    return res;
  }

  Color get _lightColor => _pageOffset.toInt() + 1 < _pages.length ? _color.lightColor : _pages.last.color.lightColor;

  void _continue() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page!;
        _pageIndex = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    UIUtils.setSystemUIOverlayStyle();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onForegroundGained: () {
        UIUtils.setSystemUIOverlayStyle(systemNavigationBarColor: _foregroundColor);
      },
      child: Scaffold(
          backgroundColor: _foregroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: YPadding.p(YScale.s2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Opacity(
                        opacity: _pageIndex == _pages.length - 1 ? 0 : 1,
                        child: YButton(
                          customColor: _color,
                          onPressed: () {
                            if (_pageIndex != _pages.length - 1) {
                              _continue();
                            }
                          },
                          text: "PASSER",
                          variant: YButtonVariant.text,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _pages.length,
                        itemBuilder: (context, i) {
                          return Container(child: _pages[i].widget);
                          // return _pages[i];
                        })),
                Padding(
                    padding: YPadding.py(YScale.s2),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Opacity(
                                  opacity: _pageIndex == 0 ? 0 : 1,
                                  child: YButton(
                                      customColor: _color,
                                      onPressed: _pageIndex == 0
                                          ? () {}
                                          : () {
                                              _pageController.previousPage(duration: _duration, curve: _curve);
                                            },
                                      text: "PRÉCÉDENT",
                                      variant: YButtonVariant.text)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SmoothPageIndicator(
                                controller: _pageController, // PageController
                                count: _pages.length,
                                onDotClicked: (int i) {
                                  _pageController.animateToPage(i, duration: _duration, curve: _curve);
                                },
                                effect: WormEffect(
                                  dotHeight: YScale.s3,
                                  dotWidth: YScale.s3,
                                  dotColor: _lightColor,
                                  activeDotColor: _backgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              YButton(
                                  customColor: _color,
                                  onPressed: () {
                                    if (_pageIndex == _pages.length - 1) {
                                      _continue();
                                    } else {
                                      _pageController.nextPage(duration: _duration, curve: _curve);
                                    }
                                  },
                                  text: _pageIndex == _pages.length - 1 ? "CONTINUER" : "SUIVANT",
                                  variant: YButtonVariant.text),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          )),
    );
  }
}
