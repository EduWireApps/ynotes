import 'package:ynotes/core/utils/app_colors.dart';
import 'package:ynotes_packages/theme.dart';

import '../widgets.dart';
import 'slide1.dart';
import 'slide2.dart';
import 'slide3.dart';

// TODO: Slide 1 : Prononciation
// TODO: Slide 2 : Notifications
// TODO: Slide 3 : Sécurisé

/// The slides used in the app intro.
///
/// In development, when this variable is upadated, the app must be restarted.
final List<Slide> slides = [
  Slide((double offset, YTColor color) => Slide1(offset: offset, color: color), AppColors.indigo),
  Slide((double offset, YTColor color) => Slide2(offset: offset, color: color), AppColors.teal),
  Slide((double offset, YTColor color) => Slide3(offset: offset, color: color), AppColors.orange),
];
