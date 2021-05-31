import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';

class TestPage extends StatefulWidget {
  final PageController? controller;

  const TestPage({Key? key, required this.controller}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with YPageMixin {
  final YPageLocal settingsPage = YPageLocal();

  @override
  Widget build(BuildContext context) {
    return YPage(
        controller: widget.controller,
        title: "TestPage",
        headerChildren: [Text("TEST")],
        body: Column(
          children: [
            Text("Body"),
            TextButton(
                child: Text("Show local page"),
                // onPressed: () {},
                onPressed: openLocalPage(context, settingsPage))
          ],
        ));
  }
}
