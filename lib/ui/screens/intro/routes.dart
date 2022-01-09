import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/intro/intro.dart';
import 'package:ynotes/ui/screens/intro/sub_pages/config.dart';

const String _basePath = '/intro';

const List<AppRoute> introRoutes = [
  AppRoute(path: _basePath, widget: IntroPage(), show: false),
  AppRoute(path: "$_basePath/config", widget: IntroConfigPage(), show: false)
];
