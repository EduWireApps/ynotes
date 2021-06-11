import 'package:flutter/material.dart';

class VerticalScrollShadow extends StatefulWidget {
  final List<Widget> children;

  const VerticalScrollShadow({Key? key, required this.children}) : super(key: key);

  @override
  _VerticalScrollShadowState createState() => _VerticalScrollShadowState();
}

class _VerticalScrollShadowState extends State<VerticalScrollShadow> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController
      ..addListener(() {
        setState(() {
          _scrollPercentage = _scrollController.offset * 100 / _scrollController.position.maxScrollExtent;
        });
        print("$_scrollPercentage%");
      });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(
        controller: _scrollController,
        children: widget.children,
      ),
      IgnorePointer(
          ignoring: !(_scrollController.offset > 30),
          child: AnimatedOpacity(
              opacity: _scrollController.offset > 30 ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: Positioned(top: 0, left: 0, right: 0, child: Container(height: 56, color: Colors.red)))),
      IgnorePointer(
          ignoring: !(_scrollController.offset < (_scrollController.position.maxScrollExtent - 30)),
          child: AnimatedOpacity(
              opacity: _scrollController.offset < (_scrollController.position.maxScrollExtent - 30) ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 56, color: Colors.blue))))
    ]);
  }
}
