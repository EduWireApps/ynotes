import 'package:flutter/material.dart';

mixin Layout<T extends StatefulWidget> on State<T> {
  bool get isLargeScreen => mounted ? MediaQuery.of(context).size.width > 480 : false;
  bool get isVeryLargeScreen => mounted ? MediaQuery.of(context).size.width > 800 : false;
}
