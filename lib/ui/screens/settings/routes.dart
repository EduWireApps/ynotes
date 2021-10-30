import 'package:ynotes/router.dart';
import 'package:ynotes/ui/screens/settings/settings_tmp.dart';

/// Contains all routes concerning global settings.
final List<CustomRoute> settingsRoutes = [
  CustomRoute(path: "/settings", page: const SettingsPage(), relatedApi: -1, show: false),
];
