import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/router.dart';
import 'package:ynotes/core/logic/app_config/models.dart';
import 'package:ynotes/ui/screens/home/home.dart';

final List<CustomRoute> homeRoutes = [
  CustomRoute(path: "/home", icon: MdiIcons.home, title: "Accueil", page: const HomePage(), tab: appTabs.summary),
];
