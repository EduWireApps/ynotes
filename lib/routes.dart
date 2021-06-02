import 'package:flutter/material.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/carousel/carousel.dart';
import 'package:ynotes/ui/screens/cloud/cloudPage.dart';
import 'package:ynotes/ui/screens/downloads/downloadsExplorer.dart';
import 'package:ynotes/ui/screens/error_page.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/ui/screens/homework/homeworkPage.dart';
import 'package:ynotes/ui/screens/loading/loadingPage.dart';
import 'package:ynotes/ui/screens/login/loginPage.dart';
import 'package:ynotes/ui/screens/mail/mailPage.dart';
import 'package:ynotes/ui/screens/polls/pollsPage.dart';
import 'package:ynotes/ui/screens/schoolLife/schoolLifePage.dart';
import 'package:ynotes/ui/screens/settings/settingsPage.dart';
import 'package:ynotes/ui/screens/summary/summaryPage.dart';
import 'package:ynotes/ui/screens/testPage.dart';
import 'package:ynotes/ui/screens/testPage2.dart';

List<Map<String, dynamic>> routes = [
  {"path": "/loading", "page": LoadingPage()},
  {"path": "/login", "page": LoginPage()},
  {"path": "/intro", "page": SlidingCarousel()},
  {"path": "/summary", "page": SummaryPage()},
  {"path": "/grades", "page": GradesPage()},
  {
    "path": "/homework",
    "page": HomeworkPage(hwController: appSys.homeworkController)
  },
  {"path": "/mailbox", "page": MailPage()},
  {"path": "/school_life", "page": SchoolLifePage()},
  {"path": "/cloud", "page": CloudPage()},
  {"path": "/files", "page": DownloadsExplorer()},
  {"path": "/polls", "page": PollsAndInfoPage()},
  {"path": "/settings", "page": SettingsPage()},
  {"path": "/test", "page": TestPage()},
  {"path": "/testtwo", "page": TestPage2()},
  {"path": "/error", "page": ErrorPage()},
];

PageRouteBuilder generateRoute(dynamic page) {
  return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, a, __, c) =>
          FadeTransition(opacity: a, child: c));
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  for (var route in routes) {
    if (settings.name == route["path"]) {
      return generateRoute(route["page"]);
    }
  }

  return generateRoute(
      routes.firstWhere((route) => route["path"] == "/error")["page"]);
}
