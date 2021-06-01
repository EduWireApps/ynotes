import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with YPageMixin {
  @override
  Widget build(BuildContext context) {
    final YPageLocal settingsPage = YPageLocal(
        child: Column(
      children: [
        Text("Page local"),
        TextButton(
            child: Text("Show sub local page"),
            onPressed: () =>
                openLocalPage(YPageLocal(child: Text("Sub local Page")))),
      ],
    ));

    return YPage(
        title: "TestPage",
        headerChildren: [Text("TEST")],
        body: Column(
          children: [
            Text("Body"),
            TextButton(
                child: Text("Show local page"),
                onPressed: () => openLocalPage(settingsPage)),
          ],
        ));
  }
}
