import 'package:ynotes/core_new/utilities.dart';
import 'package:ynotes_packages/theme.dart';

import '../widgets.dart';
import 'slide1.dart';
import 'slide2.dart';
import 'slide3.dart';

/// The slides used in the app intro.
///
/// In development, when this variable is upadated, the app must be restarted.
final List<Slide> slides = [
  Slide((double offset, YTColor color) => Slide1(offset: offset, color: color), AppColors.indigo),
  Slide((double offset, YTColor color) => Slide2(offset: offset, color: color), AppColors.teal),
  Slide((double offset, YTColor color) => Slide3(offset: offset, color: color), AppColors.orange),
];
