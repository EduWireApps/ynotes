import 'package:flutter/material.dart';

class YPageLocal extends StatefulWidget {
  @override
  _YPageLocalState createState() => _YPageLocalState();
}

class _YPageLocalState extends State<YPageLocal> {
  @override
  Widget build(BuildContext context) {
    void closePage() => Navigator.pop(context);

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: closePage,
            ),
            centerTitle: false,
            title: Text("Test")),
        body: Container(
          child: Text("Body"),
        ));
  }
}
