import 'package:ynotes/router.dart';
import 'package:ynotes/ui/screens/settings/settings.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/account.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/donors.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/licenses.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logs.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/support.dart';

/// Contains all routes concerning global settings.
final List<CustomRoute> settingsRoutes = [
  CustomRoute(path: "/settings", page: const SettingsPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/settings/account", page: const SettingsAccountPage(), relatedApi: -1, show: false),
  // CustomRoute(path: "/settings/notifications", page: const SettingsNotificationsPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/settings/support", page: const SettingsSupportPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/settings/licenses", page: const SettingsLicensesPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/settings/logs", page: const SettingsLogsPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/settings/donors", page: const SettingsDonorsPage(), relatedApi: -1, show: false),
];
