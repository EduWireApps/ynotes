import 'package:ynotes_packages/theme.dart';

import 'widgets.dart';

class Slide {
  final IntroSlideWidget Function(double offset, YTColor color) widget;
  final YTColor color;

  Slide(this.widget, this.color);
}
