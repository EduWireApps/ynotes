import 'package:ynotes/router.dart';
import 'package:ynotes/ui/screens/login/login.dart';
import 'package:ynotes/ui/screens/login/sub_pages/ecoledirecte.dart';

final List<CustomRoute> loginRoutes = [
  CustomRoute(path: "/login", page: const LoginPage(), relatedApi: -1, show: false),
  CustomRoute(path: "/login/ecoledirecte", page: const LoginEcoleDirectePage(), relatedApi: -1, show: false),
];
