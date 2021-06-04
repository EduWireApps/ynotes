import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/appConfig/models.dart';
import 'package:ynotes/ui/screens/agenda/agendaPage.dart';
import 'package:ynotes/ui/screens/carousel/carousel.dart';
import 'package:ynotes/ui/screens/cloud/cloudPage.dart';
import 'package:ynotes/ui/screens/downloads/downloadsExplorer.dart';
import 'package:ynotes/ui/screens/error_page.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/ui/screens/homework/homeworkPage.dart';
import 'package:ynotes/ui/screens/login/loginPage.dart';
import 'package:ynotes/ui/screens/mail/mailPage.dart';
import 'package:ynotes/ui/screens/polls/pollsPage.dart';
import 'package:ynotes/ui/screens/schoolLife/schoolLifePage.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/accountPage.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logsPage.dart';
import 'package:ynotes/ui/screens/summary/summaryPage.dart';

List<Map<String, dynamic>> routes = [
  {
    "path": "/login",
    "icon": Icons.login,
    "title": "Se connecter",
    "page": LoginPage(),
    "relatedApi": -1,
    "show": false,
  },
  {
    "path": "/intro",
    "icon": Icons.info,
    "title": "Introduction",
    "page": SlidingCarousel(),
    "relatedApi": -1,
    "show": false
  },
  {
    "path": "/summary",
    "icon": MdiIcons.home,
    "title": "Résumé",
    "page": SummaryPage(),
    "tab": appTabs.SUMMARY
  },
  {
    "path": "/grades",
    "icon": MdiIcons.trophy,
    "title": "Notes",
    "page": GradesPage(),
    "tab": appTabs.GRADES
  },
  {
    "path": "/homework",
    "icon": MdiIcons.calendarCheck,
    "title": "Devoirs",
    "page": HomeworkPage(),
    "tab": appTabs.HOMEWORK
  },
  {
    "path": "/agenda",
    "icon": MdiIcons.calendar,
    "title": "Agenda",
    "page": AgendaPage(),
    "tab": appTabs.AGENDA
  },
  {
    "path": "/mailbox",
    "icon": MdiIcons.mail,
    "title": "Messagerie",
    "page": MailPage(),
    "relatedApi": 0,
    "tab": appTabs.MESSAGING
  },
  {
    "path": "/school_life",
    "icon": MdiIcons.stamper,
    "title": "Vie scolaire",
    "page": SchoolLifePage(),
    "relatedApi": 0,
    "tab": appTabs.SCHOOL_LIFE
  },
  {
    "path": "/cloud",
    "icon": MdiIcons.cloud,
    "title": "Cloud",
    "page": CloudPage(),
    "relatedApi": 0,
    "tab": appTabs.CLOUD
  },
  {
    "path": "/files",
    "icon": MdiIcons.file,
    "title": "Fichiers",
    "page": DownloadsExplorer(),
    "relatedApi": 0,
    "tab": appTabs.FILES
  },
  {
    "path": "/polls",
    "icon": MdiIcons.poll,
    "title": "Sondages",
    "page": PollsAndInfoPage(),
    "relatedApi": 1,
    "tab": appTabs.POLLS
  },
  {
    "path": "/account",
    "icon": Icons.person,
    "title": "Compte",
    "page": AccountPage(),
    "tab": appTabs.ACCOUNT
  }
];

PageRouteBuilder generateRoute(dynamic page) {
  return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, a, __, c) =>
          FadeTransition(opacity: a, child: c));
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  logFile("Going to route: \"${settings.name}\"");
  for (var route in routes) {
    if (settings.name == route["path"]) {
      return generateRoute(route["page"]);
    }
  }

  logFile("Route \"${settings.name}\" not found");
  return generateRoute(ErrorPage());
}
