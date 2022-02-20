import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/ui/screens/grades/grades.dart';

bool _guard() => schoolApi.gradesModule.isEnabled;
const String _basePath = "/grades";

const List<AppRoute> gradesRoutes = [
  AppRoute(
      path: _basePath,
      widget: GradesPage(),
      icon: MdiIcons.abTesting,
      title: "Notes",
      guard: _guard,
      fallbackPath: "/loading")
];

class GradesPageArguments {
  final Grade grade;

  const GradesPageArguments({required this.grade});
}
