import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
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
        title: "Test",
        child: Column(
          children: [
            Text("Page local"),
            TextButton(
                child: Text("Show sub local page"),
                onPressed: () => openLocalPage(
                    YPageLocal(title: "Test", child: Text("Sub local Page")))),
          ],
        ));

    return YPage(
        title: "TestPage",
        actions: [
          IconButton(
              onPressed: () => openLocalPage(
                  YPageLocal(title: "Test", child: Text("settings"))),
              icon: Icon(MdiIcons.wrench,
                  color: ThemeUtils.isThemeDark ? Colors.white : Colors.black))
        ],
        body: Column(
          children: [
            Text("Body"),
            TextButton(
                child: Text("Show local page"),
                onPressed: () => openLocalPage(settingsPage)),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              padding: EdgeInsets.all(20),
              child: Text("Dernières notes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              padding: EdgeInsets.all(50),
              child: Text("Box",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              padding: EdgeInsets.all(50),
              child: Text("Box",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              padding: EdgeInsets.all(50),
              child: Text("Box",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              padding: EdgeInsets.all(50),
              child: Text("Box",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              padding: EdgeInsets.all(50),
              child: Text("Box",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              padding: EdgeInsets.all(50),
              child: Text("Box",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              padding: EdgeInsets.all(50),
              child: Text("Box",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ],
        ));
  }
}
