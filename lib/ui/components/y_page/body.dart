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
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          padding: EdgeInsets.all(30),
          width: double.infinity,
          child: widget.child),
    );
  }
}
