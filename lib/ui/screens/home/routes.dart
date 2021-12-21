import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/logic/app_config/models.dart';
import 'package:ynotes/ui/screens/home/home.dart';

final List<CustomRoute> homeRoutes = [
  CustomRoute(path: "/home", icon: Icons.home_rounded, title: "Accueil", page: const HomePage(), tab: appTabs.summary),
];

// TODO: change that
const List<AppRoute> homeRoutesTMP = [
  AppRoute(path: "/home", widget: HomePage(), icon: Icons.home_rounded, title: "Accueil")
];
