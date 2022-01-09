part of app;

/// The class that represents a route.
class AppRoute {
  /// The path of the route. By convention, starts with a slash.
  final String path;

  /// The icon associated with the route. It is only showed in the app
  /// drawer if [show] is true.
  final IconData? icon;

  /// The title associated with the route. It is only showed in the app
  /// drawer if [show] is true.
  final String? title;

  /// Is the route shown in the app drawer.
  final bool show;

  /// The widget associated with the route. Usually a widget named like
  /// `<Path>Page`.
  final Widget widget;

  /// The transition associated with the route.
  final RouteTransition transition;

  /// The guard associated with the route. If not null, the function is
  /// ran before rendering the route. If results is false, the router will
  /// redirect to [fallbackPath];
  final bool Function()? guard;

  /// The path to redirect to if [guard] returns false. Defaults to `/loading`.
  final String fallbackPath;

  const AppRoute(
      {required this.path,
      this.icon,
      this.title,
      this.show = true,
      required this.widget,
      this.transition = RouteTransition.fade,
      this.guard,
      this.fallbackPath = "/loading"});
}

/// The transitions for the [AppRoute].
enum RouteTransition {
  /// A classic fade transition.
  fade,

  /// A transition that slides from the right.
  slideHorizontal,

  /// A transition that slides from the bottom.
  slideVertical,

  /// A classic scale transition.
  scale
}

/// The class that manages routes.
class AppRouter {
  const AppRouter._();

  /// The function used to generate the route in [onGenerateRoute]. Takes care of
  /// guards and transitions.
  static PageRouteBuilder _generateRoute(AppRoute route, RouteSettings settings) {
    final bool validRoute = route.guard == null || route.guard!.call();
    route = validRoute ? route : routes.firstWhere((e) => e.path == route.fallbackPath);

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

  /// The function used to generate routes for [MaterialApp.onGenerateRoute].
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    for (final route in routes) {
      if (settings.name == route.path) {
        CustomLogger.log("ROUTER", 'Going to "${settings.name}".');
        return _generateRoute(route, settings);
      }
    }

    CustomLogger.log("ROUTER", 'Route "${settings.name}" not found.');
    return _generateRoute(const AppRoute(path: "", widget: ErrorPage()), settings);
  }

  /// The routes for the whole application.
  static final List<AppRoute> routes = [
    // IMPORTANT: routes are duplicated because of [initialRoute].
    // When starting with a `/`, it creates 2 routes: `/` and `/loading`, leading to errors
    const AppRoute(path: "loading", widget: LoadingPage(), show: false),
    const AppRoute(path: "/loading", widget: LoadingPage(), show: false),
    const AppRoute(path: "/terms", widget: TermsPage(), show: false),
    ...loginRoutes.map((e) => AppRoute(path: e.path, widget: e.page, show: false)).toList(),
    ...introRoutes.map((e) => AppRoute(path: e.path, widget: e.page, show: false)).toList(),
    ...settingsRoutes,
    ...homeRoutes,
    ...gradesRoutes
  ];
}

@Deprecated("Use [AppRoute] instead.")
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

@Deprecated("Use [AppRouter.routes] instead.")
final List<CustomRoute> routes = [
  ...loginRoutes,
  ...introRoutes,
  // ...settingsRoutes,
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
];
