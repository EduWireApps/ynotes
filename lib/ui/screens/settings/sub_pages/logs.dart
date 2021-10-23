import 'package:flutter/material.dart';
import 'package:flutter_responsive_breakpoints/flutter_responsive_breakpoints.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logs/logs_reader.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogsPageState();
  }
}

class LogsTile extends StatefulWidget {
  final Color gradient;
  final String title;
  final IconData icon;
  const LogsTile({Key? key, required this.gradient, required this.title, required this.icon}) : super(key: key);

  @override
  _LogsTileState createState() => _LogsTileState();
}

class _LogsPageState extends State<LogsPage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.size.width * 0.05, vertical: screenSize.size.height * 0.05),
      width: screenSize.size.width,
      height: screenSize.size.height,
      child: GridView.count(
          crossAxisSpacing: screenSize.size.width * 0.02,
          mainAxisSpacing: screenSize.size.height * 0.02,
          crossAxisCount: responsive<int>(def: 2, md: 3, xl: 4),
          children: List.generate(15, (int y) {
            return LogsTile(gradient: Colors.blue, title: "Test", icon: Icons.tab);
          })),
    );
  }
}

class _LogsTileState extends State<LogsTile> with YPageMixin {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return InkWell(
      onTap: () {
        openLocalPage(const YPageLocal(child: LogsReader(), title: "Logs"));
      },
      child: PhysicalModel(
        color: Colors.lightBlue,
        elevation: 3.5,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(19),
        child: SizedBox(
          width: screenSize.size.width / 5 * 1.5,
          height: screenSize.size.width / 5 * 1.5,
        ),
      ),
    );
  }
}
