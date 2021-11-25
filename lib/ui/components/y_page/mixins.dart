import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';

@Deprecated("Use Navigator instead")
mixin YPageMixin<T extends StatefulWidget> on State<T> {
  openLocalPage(YPageLocal page) {
    CustomLogger.log("ROUTING", 'Opening local page "${page.title}".');
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: Material(child: child),
            );
          },
        ));
  }
}
