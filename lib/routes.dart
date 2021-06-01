import 'package:flutter/material.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/screens/carousel/carousel.dart';
import 'package:ynotes/ui/screens/cloud/cloudPage.dart';
import 'package:ynotes/ui/screens/downloads/downloadsExplorer.dart';
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

Map<String, Widget Function(BuildContext)> routes = {
  "/loading": (_) => LoadingPage(),
  "/login": (_) => LoginPage(),
  "/intro": (_) => SlidingCarousel(),
  "/summary": (_) => SummaryPage(),
  "/grades": (_) => GradesPage(),
  "/homework": (_) => HomeworkPage(hwController: appSys.homeworkController),
  "/mailbox": (_) => MailPage(),
  "/school_life": (_) => SchoolLifePage(),
  "/cloud": (_) => CloudPage(),
  "/files": (_) => DownloadsExplorer(),
  "/polls": (_) => PollsAndInfoPage(),
  "/settings": (_) => SettingsPage(),
  "/test": (_) => TestPage(),
  "/testtwo": (_) => TestPage2()
};

PageRouteBuilder generateRoute(dynamic page) {
  return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, a, __, c) =>
          FadeTransition(opacity: a, child: c));
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name == "/test") {
    return generateRoute(TestPage());
  }
  if (settings.name == "/testtwo") {
    return generateRoute(TestPage2());
  }
}
