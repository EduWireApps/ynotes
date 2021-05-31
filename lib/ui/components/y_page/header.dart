import 'package:flutter/material.dart';

class YPageHeader extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const YPageHeader({Key? key, required this.title, this.children = const []})
      : super(key: key);

  @override
  _YPageHeaderState createState() => _YPageHeaderState();
}

class _YPageHeaderState extends State<YPageHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        color: Colors.green,
        child: Column(
          children: [
            Text(widget.title, style: TextStyle(color: Colors.red)),
            ...widget.children
          ],
        ));
  }
}
