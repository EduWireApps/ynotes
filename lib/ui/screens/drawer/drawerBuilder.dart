import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/agenda/agendaPage.dart';
import 'package:ynotes/ui/screens/cloud/cloudPage.dart';
import 'package:ynotes/ui/screens/downloads/downloadsExplorer.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/ui/screens/homework/homeworkPage.dart';
import 'package:ynotes/ui/screens/mail/mailPage.dart';
import 'package:ynotes/ui/screens/polls/pollsPage.dart';
import 'package:ynotes/ui/screens/statspage/statspage.dart';
import 'package:ynotes/ui/screens/summary/summaryPage.dart';
import 'package:ynotes/ui/screens/viescolaire/schoolLifePage.dart';
import 'package:ynotes/usefulMethods.dart';

import 'drawerBuilderWidgets/drawer.dart';

bool isQuickMenuShown = false;

int _currentIndex = 0;

///Build a bottom tabbar and tabs
class DrawerBuilder extends StatefulWidget {
  DrawerBuilder({Key? key}) : super(key: key);

  State<StatefulWidget> createState() {
    return _DrawerBuilderState();
  }
}

class _DrawerBuilderState extends State<DrawerBuilder> with TickerProviderStateMixin {
  ///Apps
  ///`relatedApi` should be set to null if both APIs can use it
  ///-1 is only shown in debug mode
  List<Map> entries() {
    return [
      {
        "menuName": "Résumé",
        "icon": MdiIcons.home,
        "page": SummaryPage(
          switchPage: _switchPage,
          key: summaryPage,
        ),
        "key": summaryPage
      },
      {
        "menuName": "Notes",
        "icon": MdiIcons.trophy,
        "page": SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: GradesPage(
            ))
      },
      {
        "menuName": "Devoirs",
        "icon": MdiIcons.calendarCheck,
        "page": HomeworkPage(
          key: homeworkPage,
          hwController: appSys.homeworkController,
        ),
        "key": homeworkPage
      },
      {"menuName": "Agenda", "icon": MdiIcons.calendar, "page": AgendaPage(key: agendaPage), "key": agendaPage},
      {
        "menuName": "Messagerie",
        "icon": MdiIcons.mail,
        "relatedApi": 0,
        "page": MailPage(),
      },
      {
        "menuName": "Vie scolaire",
        "relatedApi": -1,
        "icon": MdiIcons.stamper,
        "page": SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: SchoolLifePage()),
      },
      {"menuName": "Cloud", "icon": MdiIcons.cloud, "relatedApi": 0, "page": CloudPage()},
      {"menuName": "Sondages", "icon": MdiIcons.poll, "relatedApi": 1, "page": PollsAndInfoPage()},
      {
        "menuName": "Fichiers",
        "icon": MdiIcons.file,
        "relatedApi": 0,
        "page": DownloadsExplorer(),
      },
      {
        "menuName": "Statistiques",
        "icon": MdiIcons.chartBar,
        "relatedApi": -1,
        "page": StatsPage(),
      },
    ];
  }
  PageController? drawerPageViewController;

  ValueNotifier<int> _notifier = ValueNotifier<int>(0);
  bool isChanging = false;
  //Boolean
  bool firstStart = true;
  late AnimationController quickMenuAnimationController;

  Animation<double>? quickMenuButtonAnimation;

  StreamSubscription? tabBarconnexion;
  GlobalKey<AgendaPageState> agendaPage = new GlobalKey();
  GlobalKey<SummaryPageState> summaryPage = new GlobalKey();
  GlobalKey<HomeworkPageState> homeworkPage = new GlobalKey();
  bool isOffline = false;
  late Animation<double> showLoginControllerStatus;
  late AnimationController showLoginControllerStatusController;
  final Duration drawerAnimationDuration = Duration(milliseconds: 150);
  AnimationController? bodyController;
  Animation<double>? bodyScaleAnimation;
  Animation<Offset>? bodyOffsetAnimation;
  Animation<Offset>? buttonOffsetAnimation;
  Animation<double>? buttonScaleAnimation;
  Animation<double>? fadeAnimation;
  bool isDrawerCollapsed = true;
  int? _previousPage;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    //Init hw controller
    if (firstStart == true) {
      firstStart = false;
    }

    AppNotification.initNotifications(context, _scrollTo);
    //Mvc init

    initPageControllers();
    //Page sys
    _previousPage = drawerPageViewController?.initialPage;
  }

  @override
  void dispose() {
    _notifier?.dispose();
    drawerPageViewController?.dispose();
    super.dispose();
  }

  initPageControllers() {
    // this creates the controller
    drawerPageViewController = PageController(
      initialPage: 0,
    )..addListener(_onPageViewUpdate);
    bodyController = AnimationController(vsync: this, duration: drawerAnimationDuration);

    showLoginControllerStatusController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    showLoginControllerStatus = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
        parent: showLoginControllerStatusController, curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));

    //Define a controller in order to control  quick menu animation
    quickMenuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    quickMenuButtonAnimation = new Tween(
      begin: 1.0,
      end: 1.3,
    ).animate(
        new CurvedAnimation(parent: quickMenuAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeOut));
  }

  _onPageViewUpdate() {
    _notifier?.value = drawerPageViewController.page.round();
  }

  bool wiredashShown = false;

  @override
  Widget build(BuildContext context) {
    //status bar info
    SystemChrome.setSystemUIOverlayStyle(
        ThemeUtils.isThemeDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);

    double extrasize = 0;
    return WillPopScope(
      onWillPop: () async {
        Future.value(false);
        return false;
      },
      //PAppbar
      child: Scaffold(
          key: _drawerKey,
          resizeToAvoidBottomInset: false,
          drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Theme.of(context).primaryColor, //This will change the drawer background to blue.
              //other styles
            ),
            child: ClipRRect(
              child: Container(
                  width: screenSize.size.width / 5 * 3.6,
                  child: Drawer(
                    child: ValueListenableBuilder(
                        valueListenable: _notifier,
                        builder: (context, dynamic value, child) {
                          return CustomDrawer(
                            entries(),
                            notifier: _notifier,
                            drawerPageViewController: drawerPageViewController,
                          );
                        }),
                  )),
            ),
          ),
          backgroundColor: ThemeUtils.darken(Theme.of(context).backgroundColor, forceAmount: 0.05),
          body: Stack(
            children: <Widget>[
              ClipRRect(
                child: Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(screenSize.size.height / 10 * 0.7),
                    child: ValueListenableBuilder(
                        valueListenable: _notifier,
                        builder: (context, dynamic value, child) {
                          return AppBar(
                              shadowColor: Colors.transparent,
                              backgroundColor: ThemeUtils.isThemeDark
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).primaryColorDark,
                              title: Text(entries()[value]["menuName"]),
                              actions: [
                                if (entries()[value]["key"] != null)
                                  FlatButton(
                                    color: Colors.transparent,
                                    child: Icon(MdiIcons.wrench,
                                        color: ThemeUtils.isThemeDark ? Colors.white : Colors.black),
                                    onPressed: () {
                                      entries()[value]["key"].currentState.triggerSettings();
                                    },
                                  )
                              ],
                              leading: FlatButton(
                                color: Colors.transparent,
                                child: Icon(MdiIcons.menu, color: ThemeUtils.isThemeDark ? Colors.white : Colors.black),
                                onPressed: () async {
                                  _drawerKey.currentState!.openDrawer(); //
                                },
                              ));
                        }),
                  ),
                  body: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: drawerPageViewController,
                    itemBuilder: (context, index) {
                      return entries()[index]["page"];
                    },
                  ),
                ),
              ),

              //Transparent login panel
              ChangeNotifierProvider<LoginController>.value(
                value: appSys.loginController,
                child: Consumer<LoginController>(builder: (context, model, child) {
                  print(model.actualState);
                  if (model.actualState != loginStatus.loggedIn) {
                    showLoginControllerStatusController.forward();
                  } else {
                    showLoginControllerStatusController.reverse();
                  }
                  return AnimatedBuilder(
                      animation: showLoginControllerStatus,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -screenSize.size.height / 10 * 1.2 * showLoginControllerStatus.value),
                          child: Opacity(
                              opacity: 0.8,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: screenSize.size.width / 5 * 2.25, top: screenSize.size.height / 10 * 0.1),
                                  height: screenSize.size.width / 5 * 0.5,
                                  width: screenSize.size.width / 5 * 0.5,
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                  decoration: BoxDecoration(
                                    color: case2(model.actualState, {
                                      loginStatus.loggedIn: Colors.green,
                                      loginStatus.loggedOff: Colors.grey,
                                      loginStatus.error: Colors.red.shade500,
                                      loginStatus.offline: Colors.orange,
                                    }),
                                    borderRadius: BorderRadius.all(Radius.circular(1000)),
                                  ),
                                  child: FittedBox(
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                    case2(
                                      model.actualState,
                                      {
                                        loginStatus.loggedOff: SpinKitThreeBounce(
                                          size: screenSize.size.width / 5 * 0.3,
                                          color: Theme.of(context).primaryColorDark,
                                        ),
                                        loginStatus.offline: Icon(
                                          MdiIcons.networkStrengthOff,
                                          size: screenSize.size.width / 5 * 0.3,
                                          color: Theme.of(context).primaryColorDark,
                                        ),
                                        loginStatus.error: GestureDetector(
                                          onTap: () async {
                                            await model.login();
                                          },
                                          child: Icon(
                                            MdiIcons.exclamation,
                                            size: screenSize.size.width / 5 * 0.3,
                                            color: Theme.of(context).primaryColorDark,
                                          ),
                                        ),
                                        loginStatus.loggedIn: Icon(
                                          MdiIcons.check,
                                          size: screenSize.size.width / 5 * 0.3,
                                          color: Theme.of(context).primaryColorDark,
                                        )
                                      },
                                      SpinKitThreeBounce(
                                        size: screenSize.size.width / 5 * 0.4,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                    ) as Widget,
                                  ])))),
                        );
                      });
                }),
              ),
            ],
          )),
    );
  }

  callbackOnShake(BuildContext context) async {}

  @override
  void dispose() {
    _notifier.dispose();
    drawerPageViewController!.dispose();
    super.dispose();
    appSys.offline!.dispose();
  }

  ///Apps
  ///`relatedApi` should be set to null if both APIs can use it
  ///-1 is only shown in debug mode
  List<Map> entries() {
    return [
      {
        "menuName": "Résumé",
        "icon": MdiIcons.home,
        "page": SummaryPage(
          switchPage: _switchPage,
          key: summaryPage,
        ),
        "key": summaryPage
      },
      {
        "menuName": "Notes",
        "icon": MdiIcons.trophy,
        "page": SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: GradesPage(
              appSys.gradesController,
            )),
      },
      {
        "menuName": "Devoirs",
        "icon": MdiIcons.calendarCheck,
        "page": HomeworkPage(
          key: homeworkPage,
          hwController: appSys.homeworkController,
        ),
        "key": homeworkPage
      },
      {"menuName": "Agenda", "icon": MdiIcons.calendar, "page": AgendaPage(key: agendaPage), "key": agendaPage},
      {
        "menuName": "Messagerie",
        "icon": MdiIcons.mail,
        "relatedApi": 0,
        "page": MailPage(),
      },
      {
        "menuName": "Vie scolaire",
        "relatedApi": -1,
        "icon": MdiIcons.stamper,
        "page": SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: SchoolLifePage()),
      },
      {"menuName": "Cloud", "icon": MdiIcons.cloud, "relatedApi": 0, "page": CloudPage()},
      {"menuName": "Sondages", "icon": MdiIcons.poll, "relatedApi": 1, "page": PollsAndInfoPage()},
      {
        "menuName": "Fichiers",
        "icon": MdiIcons.file,
        "relatedApi": 0,
        "page": DownloadsExplorer(),
      },
      {
        "menuName": "Statistiques",
        "icon": MdiIcons.chartBar,
        "relatedApi": -1,
        "page": StatsPage(),
      },
    ];
  }

  initControllers() async {
    await appSys.gradesController.refresh();
    await appSys.homeworkController.refresh();

    //Lazy reloads
    await appSys.gradesController.refresh(force: true);
    await appSys.homeworkController.refresh(force: true);
  }

  initPageControllers() {
    // this creates the controller
    drawerPageViewController = PageController(
      initialPage: 0,
    )..addListener(_onPageViewUpdate);
    bodyController = AnimationController(vsync: this, duration: drawerAnimationDuration);

    showLoginControllerStatusController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    showLoginControllerStatus = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
        parent: showLoginControllerStatusController, curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));

    //Define a controller in order to control  quick menu animation
    quickMenuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    quickMenuButtonAnimation = new Tween(
      begin: 1.0,
      end: 1.3,
    ).animate(
        new CurvedAnimation(parent: quickMenuAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeOut));
  }

  @override
  void initState() {
    super.initState();

    //Init hw controller
    if (firstStart == true) {
      firstStart = false;
    }

    AppNotification.initNotifications(context, _scrollTo);
    //Mvc init
    initControllers();
    initPageControllers();
    //Page sys
    _previousPage = drawerPageViewController!.initialPage;
  }

  _onPageViewUpdate() {
    _notifier.value = drawerPageViewController!.page!.round();
  }

  _scrollTo(int index) {
    // scroll the calculated ammount
    drawerPageViewController!.jumpToPage(index);
  }

  _switchPage(int index) {
    _scrollTo(index);
  }
}
