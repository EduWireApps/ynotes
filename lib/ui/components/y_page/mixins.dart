import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';

mixin YPageMixin<T extends StatefulWidget> on State<T> {
  openLocalPage(YPageLocal page) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: Material(child: child),
            );
          },
        ));
  }
}
