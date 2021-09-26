import 'package:ynotes/router.dart';
import 'package:ynotes/ui/screens/login/login.dart';
import 'package:ynotes/ui/screens/login/sub_pages/ecoledirecte.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/pronote.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/url/form.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/url/url.dart';

final List<CustomRoute> loginRoutes = [
  CustomRoute(path: "/login", page: const LoginPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/login/ecoledirecte", page: const LoginEcoleDirectePage(), relatedApi: -1, show: false),
  CustomRoute(path: "/login/pronote", page: const LoginPronotePage(), relatedApi: -1, show: false),
  CustomRoute(path: "/login/pronote/url", page: const LoginPronoteUrlPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/login/pronote/url/form", page: const LoginPronoteUrlFormPage(), relatedApi: -1, show: false),
];
