import 'package:flutter/cupertino.dart';

class RoutingUtils {
  const RoutingUtils._();

  /// Returns the arguments given to a named route.
  static T getArgs<T>(BuildContext context) => ModalRoute.of(context)!.settings.arguments as T;
}
