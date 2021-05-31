import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/y_page/body.dart';
import 'package:ynotes/ui/components/y_page/header.dart';

class YPage extends StatefulWidget {
  final PageController? controller;
  final String title;
  final List<Widget> headerChildren;
  final Widget? body;

  const YPage(
      {Key? key,
      required this.controller,
      required this.title,
      this.headerChildren = const [],
      this.body})
      : super(key: key);

  @override
  _YPageState createState() => _YPageState();
}

class _YPageState extends State<YPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YPageHeader(
          title: widget.title,
          children: widget.headerChildren,
        ),
        if (widget.body != null) YPageBody(child: widget.body)
      ],
    );
  }
}
