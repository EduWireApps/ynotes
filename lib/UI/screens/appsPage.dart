import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../main.dart';
import '../../usefulMethods.dart';
import 'apps/cloud.dart';
import 'apps/mail.dart';
import 'package:ynotes/UI/utils/themeUtils.dart';


class AppsPage extends StatefulWidget {
  final BuildContext rootcontext;

  const AppsPage({Key key, this.rootcontext}) : super(key: key);
  State<StatefulWidget> createState() {
    return _AppsPageState();
  }
}

String initialRoute = '/homePage';

class _AppsPageState extends State<AppsPage> {
  void initState() {}

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
        child: MaterialApp(debugShowCheckedModeBanner: false, theme: lightTheme, darkTheme: darkTheme, themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light, initialRoute: initialRoute, routes: {
      '/homePage': (context) => Material(child: HomePage()),
      '/cloud': (context) => Material(child: CloudPage()),
      '/mail': (context) => Material(child: MailPage(context: widget.rootcontext)),
    }));
  }
}

class HomePage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor, border: Border.all(width: 0, color: Theme.of(context).backgroundColor)),
      width: screenSize.size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Accédez à vos applications",
            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: screenSize.size.height / 10 * 0.4, fontWeight: FontWeight.w200),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: screenSize.size.height / 10 * 0.4,
          ),
          localApi.listApp.length == 0
              ? Text(
                  "Il semblerait qu'aucune application ne soit encore disponible. L'implémentation d'applications est en plein développement, revenez plus tard !",
                  style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black), textAlign: TextAlign.center,
                )
              : Wrap(
                  children: List.generate(localApi.listApp.length, (index) {
                    return Container(
                      margin: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                      child: Column(
                        children: <Widget>[
                          Material(
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: BorderRadius.circular(21),
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(21),
                                  onTap: () {
                                    if (localApi.listApp[index].route != null) {
                                      Navigator.pushNamed(context, '/${localApi.listApp[index].route}');
                                      initialRoute = '/${localApi.listApp[index].route}';
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(21)),
                                    width: screenSize.size.width / 3,
                                    height: screenSize.size.width / 3,
                                    child: Center(
                                      child: Icon(
                                        localApi.listApp[index].icon,
                                        size: screenSize.size.width / 6,
                                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ))),
                          //label
                          Text(
                            localApi.listApp[index].name,
                            style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: screenSize.size.height / 10 * 0.2),
                          )
                        ],
                      ),
                    );
                  }),
                ),
        ],
      ),
    );
  }
}
