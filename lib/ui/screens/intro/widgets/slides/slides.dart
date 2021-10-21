import 'package:ynotes/core/utils/app_colors.dart';
import 'package:ynotes_packages/theme.dart';

import '../widgets.dart';
import 'slide1.dart';
import 'slide2.dart';

final List<Slide> slides = [
  Slide((double offset, YTColor color) => Slide1(offset: offset, color: color), AppColors.blue),
  Slide((double offset, YTColor color) => Slide2(offset: offset, color: color), AppColors.deepPurple),
  Slide((double offset, YTColor color) => Slide1(offset: offset, color: color), AppColors.teal),
];
