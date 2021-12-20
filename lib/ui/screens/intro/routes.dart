import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/intro/intro.dart';
import 'package:ynotes/ui/screens/intro/sub_pages/config.dart';

final introRoutes = [
  CustomRoute(path: "/intro", page: const IntroPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/intro/config", page: const IntroConfigPage(), relatedApi: -1, show: false)
];
