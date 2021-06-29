import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/appConfig/models.dart';
import 'package:ynotes/core/utils/loggingUtils.dart';
import 'package:ynotes/ui/screens/agenda/agendaPage.dart';
import 'package:ynotes/ui/screens/carousel/carousel.dart';
import 'package:ynotes/ui/screens/cloud/cloudPage.dart';
import 'package:ynotes/ui/screens/downloads/downloadsPage.dart';
import 'package:ynotes/ui/screens/error_page.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/ui/screens/homework/homeworkPage.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/ui/screens/mail/mailPage.dart';
import 'package:ynotes/ui/screens/polls/pollsPage.dart';
import 'package:ynotes/ui/screens/schoolLife/schoolLifePage.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/accountPage.dart';
import 'package:ynotes/ui/screens/summary/summaryPage.dart';

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
  CustomRoute(
      path: "/intro", icon: Icons.info, title: "Introduction", page: SlidingCarousel(), relatedApi: -1, show: false),
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
      path: "/polls",
      icon: MdiIcons.poll,
      title: "Sondages",
      page: PollsAndInfoPage(),
      relatedApi: 1,
      tab: appTabs.POLLS),
  CustomRoute(path: "/account", icon: Icons.person, title: "Compte", page: AccountPage())
];

PageRouteBuilder generateRoute(Widget page, RouteSettings settings) {
  return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c));
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  for (var route in routes) {
    if (settings.name == route.path) {
      Logger.saveLog(object: "ROUTER", text: 'Going to "${settings.name}".');
      return generateRoute(route.page, settings);
    }
  }

  Logger.saveLog(object: "ROUTER", text: 'Route "${settings.name}" not found.');
  return generateRoute(ErrorPage(), settings);
}
