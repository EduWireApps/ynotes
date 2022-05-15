import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/ui/screens/intro/widgets/slides/slides.dart';
import 'package:ynotes/ui/screens/intro/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // Used for the slides animations.
  double _pageOffset = 0.0;
  int _pageIndex = 0;
  late final PageController _pageController = PageController(initialPage: _pageIndex);
  // The duration and curves for the page view transition when toggled, not swiped.
  final Duration _duration = const Duration(milliseconds: 500);
  final Curve _curve = Curves.easeInOut;

  List<Widget> get _pages {
    final List<Slide> pages = slides;
    return pages.asMap().entries.map((entry) {
      final int id = entry.key;
      final Slide value = entry.value;
      return value.widget(_pageOffset - id, _color);
    }).toList();
  }

  // The colors generated from the slides. Used to create color transitions.
  List<YTColor> get _colors => slides.map((slide) => slide.color).toList();

  // A transitionning color based on current page.
  YTColor get _color {
    if (_pageOffset.toInt() + 1 < _colors.length) {
      final YTColor current = _colors[_pageOffset.toInt()];
      final YTColor next = _colors[_pageOffset.toInt() + 1];
      YTColor colorLerp(YTColor _begin, YTColor _end, double t) => YTColor(
          lightColor: Color.lerp(_begin.lightColor, _end.lightColor, t) ?? _begin.lightColor,
          backgroundColor: Color.lerp(_begin.backgroundColor, _end.backgroundColor, t) ?? _begin.backgroundColor,
          foregroundColor: Color.lerp(_begin.foregroundColor, _end.foregroundColor, t) ?? _begin.foregroundColor);
      final res = colorLerp(current, next, _pageOffset - _pageOffset.toInt());
      return res;
    } else {
      return _colors.last;
    }
  }

  // The [YTColor]'s background color used as foreground color here.
  Color get _backgroundColor =>
      _pageOffset.toInt() + 1 < _colors.length ? _color.backgroundColor : _colors.last.backgroundColor;

  // The [YTColor]'s foreground color used as background color here.
  Color get _foregroundColor {
    final Color res = _pageOffset.toInt() + 1 < _colors.length ? _color.foregroundColor : _colors.last.foregroundColor;
    UIUtils.setSystemUIOverlayStyle(systemNavigationBarColor: res);
    return res;
  }

  Color get _lightColor => _pageOffset.toInt() + 1 < _colors.length ? _color.lightColor : _colors.last.lightColor;

  // Action to execute when the user presses `Skip` or `Continue`
  void _continue() {
    Navigator.pushReplacementNamed(context, "/intro/config");
  }

  @override
  void initState() {
    super.initState();
    // When the page are being swiped, the following values are updated.
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page!;
        _pageIndex = _pageController.page!.round();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UIUtils.setSystemUIOverlayStyle(systemNavigationBarColor: _foregroundColor);
    });
  }

  @override
  void dispose() {
    // Set default overlay colors.
    UIUtils.setSystemUIOverlayStyle();
    _pageController.dispose();
    super.dispose();
  }

  // The page header. Contains the skip button.
  Widget get _header => Padding(
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
      );

  // The bottom navigation bar. Contains the previous and next button as well as the dots.
  Widget get _bottomNavBar => Padding(
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
      ));

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
                _header,
                Expanded(
                    child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _pages.length,
                        itemBuilder: (context, i) {
                          return Container(child: _pages[i]);
                          // return _pages[i];
                        })),
                _bottomNavBar
              ],
            ),
          )),
    );
  }
}
