import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class Controller extends ChangeNotifier {
  Controller();

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}

/// A widget that consumes a [ChangeNotifier].
class ControllerConsumer<T extends ChangeNotifier> extends StatelessWidget {
  /// A controller of type [T] that extends [ChangeNotifier].
  final T controller;

  /// The builder function that will be called when the [controller] state
  /// is updated.
  final Widget Function(BuildContext, T, Widget?) builder;

  /// A widget that consumes a [ChangeNotifier].
  const ControllerConsumer({Key? key, required this.controller, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(value: controller, child: Consumer<T>(builder: builder));
  }
}
