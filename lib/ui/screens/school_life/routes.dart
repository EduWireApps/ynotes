import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/logic/app_config/models.dart';
import 'package:ynotes/ui/screens/school_life/school_life.dart';

/// Contains all routes concerning global settings.
final List<CustomRoute> schoolLifeRoutes = [
  CustomRoute(
      path: "/school_life",
      page: const SchoolLifePage(),
      icon: MdiIcons.stamper,
      title: "Vie scolaire",
      relatedApi: 0,
      tab: appTabs.schoolLife),
];
