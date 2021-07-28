import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/app_config/models.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/ui/screens/agenda/agenda.dart';
import 'package:ynotes/ui/screens/carousel/carousel.dart';
import 'package:ynotes/ui/screens/cloud/cloud.dart';
import 'package:ynotes/ui/screens/downloads/downloads.dart';
import 'package:ynotes/ui/screens/error.dart';
import 'package:ynotes/ui/screens/grades/grades.dart';
import 'package:ynotes/ui/screens/homework/homework.dart';
import 'package:ynotes/ui/screens/login/login.dart';
import 'package:ynotes/ui/screens/mailbox/mailbox.dart';
import 'package:ynotes/ui/screens/polls/polls.dart';
import 'package:ynotes/ui/screens/school_life/school_life.dart';
import 'package:ynotes/ui/screens/summary/summary.dart';

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
  CustomRoute(path: "/login", page: Login(), relatedApi: -1, show: false),
  CustomRoute(path: "/intro", icon: Icons.info, page: Carousel(), relatedApi: -1, show: false),
  CustomRoute(path: "/summary", icon: MdiIcons.home, title: "Résumé", page: SummaryPage(), tab: appTabs.SUMMARY),
  CustomRoute(path: "/grades", icon: MdiIcons.trophy, title: "Notes", page: GradesPage(), tab: appTabs.GRADES),
  CustomRoute(
      path: "/homework", icon: MdiIcons.calendarCheck, title: "Devoirs", page: HomeworkPage(), tab: appTabs.HOMEWORK),
  CustomRoute(path: "/agenda", icon: MdiIcons.calendar, title: "Agenda", page: AgendaPage(), tab: appTabs.AGENDA),
  CustomRoute(
      path: "/mailbox",
      icon: MdiIcons.mail,
      title: "Messagerie",
      page: MailPage(),
      relatedApi: 0,
      tab: appTabs.MESSAGING),
  CustomRoute(
      path: "/school_life",
      icon: MdiIcons.stamper,
      title: "Vie scolaire",
      page: SchoolLifePage(),
      relatedApi: 0,
      tab: appTabs.SCHOOL_LIFE),
  CustomRoute(
      path: "/cloud", icon: MdiIcons.cloud, title: "Cloud", page: CloudPage(), relatedApi: 0, tab: appTabs.CLOUD),
  CustomRoute(
      path: "/downloads",
      icon: MdiIcons.file,
      title: "Téléchargements",
      page: DownloadsExplorer(),
      relatedApi: 0,
      tab: appTabs.FILES),
  CustomRoute(
      path: "/polls", icon: MdiIcons.poll, title: "Sondages", page: PollsPage(), relatedApi: 1, tab: appTabs.POLLS),
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
      CustomLogger.saveLog(object: "ROUTER", text: 'Going to "${settings.name}".');
      return generateRoute(route.page, settings);
    }
  }

  CustomLogger.saveLog(object: "ROUTER", text: 'Route "${settings.name}" not found.');
  return generateRoute(ErrorPage(), settings);
}
