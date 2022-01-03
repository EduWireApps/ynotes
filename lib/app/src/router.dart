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

enum RouteTransition { fade, slideHorizontal, slideVertical, scale }

class AppRouter {
  const AppRouter._();

  static PageRouteBuilder _generateRoute(AppRoute route, RouteSettings settings) {
    final bool validRoute = route.guard == null || route.guard!.call();
    route = validRoute ? route : appRoutes.firstWhere((e) => e.path == route.fallbackPath);

    Widget getTransition(
        BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      animation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      switch (route.transition) {
        case RouteTransition.slideHorizontal:
          return Align(
              alignment: Alignment.centerRight,
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
                axis: Axis.horizontal,
                axisAlignment: 0,
              ));
        case RouteTransition.slideVertical:
          return Align(
              alignment: Alignment.bottomCenter,
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
                axisAlignment: 0,
              ));
        case RouteTransition.scale:
          return ScaleTransition(alignment: Alignment.center, scale: animation, child: child);
        case RouteTransition.fade:
          return FadeTransition(opacity: animation, child: child);
      }
    }

    return PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => route.widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            getTransition(context, animation, secondaryAnimation, child));
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    for (final route in appRoutes) {
      if (settings.name == route.path) {
        CustomLogger.log("ROUTER", 'Going to "${settings.name}".');
        return _generateRoute(route, settings);
      }
    }

    if (settings.name == "/") {
      // Dirty fix for the root route.
      CustomLogger.log("ROUTER", 'Redirect "/" to "/loading".');
      return _generateRoute(appRoutes.firstWhere((e) => e.path == "/loading"), settings);
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

// TODO: complete
final List<AppRoute> appRoutes = [
  const AppRoute(path: "/loading", widget: LoadingPage(), show: false),
  const AppRoute(path: "/terms", widget: TermsPage(), show: false),
  ...loginRoutes.map((e) => AppRoute(path: e.path, widget: e.page, show: false)).toList(),
  ...introRoutes.map((e) => AppRoute(path: e.path, widget: e.page, show: false)).toList(),
  ...settingsRoutes.map((e) => AppRoute(path: e.path, widget: e.page, show: false)).toList(),
  ...homeRoutes,
  ...gradesRoutes
];

final List<CustomRoute> routes = [
  ...loginRoutes,
  ...introRoutes,
  ...settingsRoutes,
  CustomRoute(path: "/loading", page: const LoadingPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/terms", page: const TermsPage(), relatedApi: -1, show: false),
  ...homeRoutesTMP,
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
