import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/login/login.dart';
import 'package:ynotes/ui/screens/login/sub_pages/ecoledirecte.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/geolocation/geolocation.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/geolocation/results.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/geolocation/search.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/pronote.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/qrcode.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/url/form.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/url/url.dart';
import 'package:ynotes/ui/screens/login/sub_pages/pronote/url/webview.dart';

/// Contains all routes concerning user authentification (`/login/...`)
final List<CustomRoute> loginRoutes = [
  CustomRoute(path: "/login", page: const LoginPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/login/ecoledirecte", page: const LoginEcoleDirectePage(), relatedApi: -1, show: false),
  CustomRoute(path: "/login/pronote", page: const LoginPronotePage(), relatedApi: -1, show: false),
  CustomRoute(path: "/login/pronote/url", page: const LoginPronoteUrlPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/login/pronote/url/form", page: const LoginPronoteUrlFormPage(), relatedApi: -1, show: false),
  CustomRoute(
      path: "/login/pronote/url/webview", page: const LoginPronoteUrlWebviewPage(), relatedApi: -1, show: false),
  CustomRoute(
      path: "/login/pronote/geolocation", page: const LoginPronoteGeolocationPage(), relatedApi: -1, show: false),
  CustomRoute(
      path: "/login/pronote/geolocation/results",
      page: const LoginPronoteGeolocationResultsPage(),
      relatedApi: -1,
      show: false),
  CustomRoute(
      path: "/login/pronote/geolocation/search",
      page: const LoginPronoteGeolocationSearchPage(),
      relatedApi: -1,
      show: false),
  CustomRoute(path: "/login/pronote/qrcode", page: const LoginPronoteQrcodePage(), relatedApi: -1, show: false),
];
