import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/app_config/models.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/ui/screens/agenda/agenda.dart';
import 'package:ynotes/ui/screens/cloud/cloud.dart';
import 'package:ynotes/ui/screens/downloads/downloads.dart';
import 'package:ynotes/ui/screens/error/error.dart';
import 'package:ynotes/ui/screens/grades/grades.dart';
import 'package:ynotes/ui/screens/home/routes.dart';
import 'package:ynotes/ui/screens/homework/homework.dart';
import 'package:ynotes/ui/screens/intro/routes.dart';
import 'package:ynotes/ui/screens/loading/loading.dart';
import 'package:ynotes/ui/screens/login/routes.dart';
import 'package:ynotes/ui/screens/mailbox/mailbox.dart';
import 'package:ynotes/ui/screens/polls/polls.dart';
import 'package:ynotes/ui/screens/polls/routes.dart';
import 'package:ynotes/ui/screens/school_life/routes.dart';
import 'package:ynotes/ui/screens/settings/routes.dart';
import 'package:ynotes/ui/screens/terms/terms.dart';

class CustomRoute {
  final String path;
  final IconData? icon;
  final String? title;
  final Widget page;
  final int? relatedApi;
  final bool show;
  final appTabs? tab;

  CustomRoute(
      {required this.path, this.icon, this.title, required this.page, this.relatedApi, this.show = true, this.tab});
}

final List<CustomRoute> routes = [
  ...loginRoutes,
  ...introRoutes,
  ...settingsRoutes,
  CustomRoute(path: "/loading", page: const LoadingPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/terms", page: const TermsPage(), relatedApi: -1, show: false),
  ...homeRoutes,
  CustomRoute(path: "/grades", icon: MdiIcons.trophy, title: "Notes", page: const GradesPage(), tab: appTabs.grades),
  CustomRoute(
      path: "/homework", icon: Icons.class__rounded, title: "Devoirs", page: HomeworkPage(), tab: appTabs.homework),
  CustomRoute(path: "/agenda", icon: MdiIcons.calendar, title: "Agenda", page: const AgendaPage(), tab: appTabs.agenda),
  CustomRoute(
      path: "/mailbox",
      icon: MdiIcons.mail,
      title: "Messagerie",
      page: const MailPage(),
      relatedApi: 0,
      tab: appTabs.messaging),
  ...schoolLifeRoutes,
  CustomRoute(
      path: "/cloud", icon: MdiIcons.cloud, title: "Cloud", page: const CloudPage(), relatedApi: 0, tab: appTabs.cloud),
  CustomRoute(
      path: "/downloads",
      icon: MdiIcons.file,
      title: "Téléchargements",
      page: const DownloadsExplorer(),
      relatedApi: 0,
      tab: appTabs.files),
  ...pollsRoutes
  // CustomRoute(
  //     path: "/polls",
  //     icon: MdiIcons.poll,
  //     title: "Sondages",
  //     page: const PollsPage(),
  //     relatedApi: 1,
  //     tab: appTabs.polls),
];

PageRouteBuilder generateRoute(Widget page, RouteSettings settings) {
  return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c));
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  for (final route in routes) {
    if (settings.name == route.path) {
      CustomLogger.log("ROUTER", 'Going to "${settings.name}".');
      return generateRoute(route.page, settings);
    }
  }

  CustomLogger.log("ROUTER", 'Route "${settings.name}" not found.');
  return generateRoute(const ErrorPage(), settings);
}
