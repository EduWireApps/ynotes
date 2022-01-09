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

const String _basePath = '/login';

/// Contains all routes concerning user authentification (`/login/...`)
const List<AppRoute> loginRoutes = [
  AppRoute(path: _basePath, widget: LoginPage(), show: false),
  AppRoute(path: "$_basePath/ecoledirecte", widget: LoginEcoleDirectePage(), show: false),
  AppRoute(path: "$_basePath/pronote", widget: LoginPronotePage(), show: false),
  AppRoute(path: "$_basePath/pronote/url", widget: LoginPronoteUrlPage(), show: false),
  AppRoute(path: "$_basePath/pronote/url/form", widget: LoginPronoteUrlFormPage(), show: false),
  AppRoute(path: "$_basePath/pronote/url/webview", widget: LoginPronoteUrlWebviewPage(), show: false),
  AppRoute(path: "$_basePath/pronote/geolocation", widget: LoginPronoteGeolocationPage(), show: false),
  AppRoute(path: "$_basePath/pronote/geolocation/results", widget: LoginPronoteGeolocationResultsPage(), show: false),
  AppRoute(path: "$_basePath/pronote/geolocation/search", widget: LoginPronoteGeolocationSearchPage(), show: false),
  AppRoute(path: "$_basePath/pronote/qrcode", widget: LoginPronoteQrcodePage(), show: false),
];
