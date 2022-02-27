import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/settings/settings.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/account.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/donors.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/filters.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/licenses.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logs.dart';
// import 'package:ynotes/ui/screens/settings/sub_pages/notifications.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/patch_notes.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/support.dart';

const String _basePath = "/settings";

/// Contains all routes concerning global settings.
final List<AppRoute> settingsRoutes = [
  const AppRoute(path: _basePath, widget: SettingsPage(), show: false, transition: RouteTransition.slideHorizontal),
  const AppRoute(
      path: "$_basePath/account", widget: SettingsAccountPage(), show: false, transition: RouteTransition.scale),
  const AppRoute(
      path: "$_basePath/filters", widget: SettingsFiltersPage(), show: false, transition: RouteTransition.scale),
  // TODO: fix when notifications are done
  // const AppRoute(
  //     path: "$_basePath/notifications",
  //     widget: SettingsNotificationsPage(),
  //     show: false,
  //     transition: RouteTransition.scale),
  const AppRoute(
      path: "$_basePath/support", widget: SettingsSupportPage(), show: false, transition: RouteTransition.scale),
  const AppRoute(
      path: "$_basePath/licenses", widget: SettingsLicensesPage(), show: false, transition: RouteTransition.scale),
  const AppRoute(path: "$_basePath/logs", widget: SettingsLogsPage(), show: false, transition: RouteTransition.scale),
  const AppRoute(
      path: "$_basePath/donors", widget: SettingsDonorsPage(), show: false, transition: RouteTransition.scale),
  const AppRoute(
      path: "$_basePath/patch-notes", widget: SettingsPatchNotesPage(), show: false, transition: RouteTransition.scale),
];
