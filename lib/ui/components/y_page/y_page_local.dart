import 'package:flutter/material.dart';

class YPageLocal extends StatefulWidget {
  final Widget child;

  const YPageLocal({Key? key, required this.child}) : super(key: key);

  @override
  _YPageLocalState createState() => _YPageLocalState();
}

class _YPageLocalState extends State<YPageLocal> {
  @override
  Widget build(BuildContext context) {
    void closePage() => Navigator.pop(context);

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: closePage,
            ),
            centerTitle: false,
            title: Text("Test")),
        body: widget.child);
  }
}
