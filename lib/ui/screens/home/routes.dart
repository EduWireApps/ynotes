import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/logic/app_config/models.dart';
import 'package:ynotes/ui/screens/home/home.dart';

// TODO: delete
final List<CustomRoute> homeRoutesTMP = [
  CustomRoute(path: "/home", icon: Icons.home_rounded, title: "Accueil", page: const HomePage(), tab: appTabs.summary),
];

const List<AppRoute> homeRoutes = [
  AppRoute(path: "/home", widget: HomePage(), icon: Icons.home_rounded, title: "Accueil")
];
