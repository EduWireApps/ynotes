import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';

mixin YPageMixin<T extends StatefulWidget> on State<T> {
  openLocalPage(YPageLocal page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
