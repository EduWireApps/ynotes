part of app;

// TODO: document and clean up

class AppRoute {
  final String path;
  final IconData? icon;
  final String? title;
  final bool show;
  final Widget widget;
  final RouteTransition transition;
  final bool Function()? guard;
  final String? fallbackPath;

  const AppRoute(
      {required this.path,
      this.icon,
      this.title,
      this.show = true,
      required this.widget,
      this.transition = RouteTransition.fade,
      this.guard,
      this.fallbackPath});
}

enum RouteTransition { fade, slideLeft, slideRight, slideUp, slideDown }

final List<AppRoute> appRoutes = [];

class AppRouter {
  const AppRouter._();

  PageRouteBuilder _generateRoute(AppRoute route, RouteSettings settings) {
    // TODO: handle guarded routes and transitions
    return PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => route.widget,
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c));
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    for (final route in appRoutes) {
      if (settings.name == route.path) {
        CustomLogger.log("ROUTER", 'Going to "${settings.name}".');
        return _generateRoute(route, settings);
      }
    }

    CustomLogger.log("ROUTER", 'Route "${settings.name}" not found.');
    return generateRoute(const ErrorPage(), settings);
  }
}

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
