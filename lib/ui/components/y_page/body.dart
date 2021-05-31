import 'package:flutter/material.dart';

class YPageBody extends StatefulWidget {
  final Widget? child;

  const YPageBody({Key? key, this.child}) : super(key: key);

  @override
  _YPageBodyState createState() => _YPageBodyState();
}

class _YPageBodyState extends State<YPageBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red, width: double.infinity, child: widget.child);
  }
}
