import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';

class TestPage2 extends StatefulWidget {
  @override
  _TestPage2State createState() => _TestPage2State();
}

class _TestPage2State extends State<TestPage2> with YPageMixin {
  @override
  Widget build(BuildContext context) {
    return YPage(
        primaryColor: Colors.blue[700],
        secondaryColor: Colors.teal,
        title: "TestPage 2",
        headerChildren: [Text("TEST 2")],
        body: Column(
          children: [
            Text("Body test 2"),
          ],
        ));
  }
}
