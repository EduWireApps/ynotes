import 'package:ynotes/router.dart';
import 'package:ynotes/ui/screens/settings/settings_tmp.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/about.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/account_tmp.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/notifications.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/support.dart';

/// Contains all routes concerning global settings.
final List<CustomRoute> settingsRoutes = [
  CustomRoute(path: "/settings", page: const SettingsPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/settings/account", page: const SettingsAccountPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/settings/notifications", page: const SettingsNotificationsPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/settings/support", page: const SettingsSupportPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/settings/about", page: const SettingsAboutPage(), relatedApi: -1, show: false),
];
