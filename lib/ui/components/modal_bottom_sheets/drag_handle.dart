import 'package:flutter/material.dart';

class DragHandle extends StatefulWidget {
  @override
  _DragHandleState createState() => _DragHandleState();
}

class _DragHandleState extends State<DragHandle> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.2),
      height: 5,
      width: screenSize.size.width / 5 * 2.5,
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(16)),
    );
  }
}
