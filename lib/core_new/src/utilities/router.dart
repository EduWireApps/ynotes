import 'package:flutter/material.dart';

class RouterUtilities {
  const RouterUtilities._();

  /// Returns the arguments given to a named route.
  static T getArgs<T>(BuildContext context) => ModalRoute.of(context)!.settings.arguments as T;
}
