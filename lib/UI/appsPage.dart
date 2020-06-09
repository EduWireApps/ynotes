import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../usefulMethods.dart';
import 'apps/cloud.dart';
import 'apps/mail.dart';

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
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
             theme: lightTheme, 
          darkTheme: darkTheme, 
            themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            initialRoute: initialRoute,
            routes: {
          '/homePage': (context) => Material(child: HomePage()),
          '/cloud': (context) => Material(child: CloudPage()),
          '/mail': (context) => Material(child: MailPage(context:widget.rootcontext)),
        }));
  }
}

class HomePage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  //Easily add apps to ecole directe (for now hardcoded)
  List<App> listAppsEcoleDirecte = [
    App("Messagerie", MdiIcons.mail, route: "mail"),
    App("Cloud", Icons.cloud, route: "cloud")
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
      
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Accédez à vos applications",
              style: TextStyle(
                  fontFamily: "Asap",
                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                  fontSize: screenSize.size.height / 10 * 0.4,
                  fontWeight: FontWeight.w200),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: screenSize.size.height / 10 * 0.4,
            ),
            Wrap(
              children: List.generate(listAppsEcoleDirecte.length, (index) {
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
                                if(listAppsEcoleDirecte[index].route!=null)
                                {
                                   Navigator.pushNamed(context, '/${listAppsEcoleDirecte[index].route}');
                                   initialRoute = '/${listAppsEcoleDirecte[index].route}';
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(21)),
                                width: screenSize.size.width / 3,
                                height: screenSize.size.width / 3,
                                child: Center(
                                  child: Icon(
                                    listAppsEcoleDirecte[index].icon,
                                    size: screenSize.size.width / 6,
                                    color: isDarkModeEnabled
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ))),
                      //label
                      Text(
                        listAppsEcoleDirecte[index].name,
                        style: TextStyle(
                            fontFamily: "Asap",
                            color: isDarkModeEnabled ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
